//
//  HomeViewController.swift
//  ProMovies
//
//  Created by Test on 23.03.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nowShowingComingSoonSegmentedControl: UISegmentedControl!
    
    @IBAction func nowShowingComingSoonSegmentOnButtonTouch(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Task{
                await fetchNowShowingMovies()
                await updateMovieDurations(for: movies)
            }
        case 1:
            Task{
                await fetchComingSoonMovies()
                await updateMovieDurations(for: movies)
            }
        default:
            break
        }
    }
    
    
    
    var movies = [Movie]()
    var genres: [Int: String] = [:]
    var movieDurations: [Int: Int] = [:]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        self.navigationController?.tabBarController?.tabBar.barTintColor = UIColor(red: 15.0/255.0, green: 27.0/255.0, blue: 43.0/255.0, alpha: 1.0/255.0)
        
  
        fetchGenres()
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout

        configCollectionView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Star Movie"
        Task {
            await fetchNowShowingMovies()
            await updateMovieDurations(for: movies)
        }
        
        
    }
    
    
    
    
    
    
    func fetchNowShowingMovies() async {
        await withCheckedContinuation { continuation in
            MoviesNetworkManager.shared.fetchComingNowMovies { [weak self] response in
                switch response {
                case .success(let movies):
                    self?.movies = movies
                    print("Success")
                case .error(_):
                    print("Error message")
                }
                continuation.resume(returning: Void())
            }
        }
        
        
    }

    func fetchComingSoonMovies() async {
        await withCheckedContinuation { continuation in
            MoviesNetworkManager.shared.fetchComingSoonMovies { [weak self] response in
                switch response {
                case .success(let movies):
                    self?.movies = movies
                    print("Success")
                case .error(_):
                    print("Error message")
                }
                continuation.resume(returning: Void())
            }
        }
        
    }
    
    func configCollectionView(){
        
        collectionView.register(UINib(nibName: "NowShowingTableViewCell", bundle: nil), forCellWithReuseIdentifier: "NowShowingTableViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetchGenres(){
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=55957fcf3ba81b137f8fc01ac5a31fb5"
        if let url = URL(string: urlString) {
            // Створюємо URLSession
            let session = URLSession.shared
            // Створюємо data task для виконання запиту
            let task = session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        // Розпарсюємо відповідь в форматі JSON
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        // Отримуємо масив жанрів з JSON
                        if let genresData = json?["genres"] as? [[String: Any]] {
                            for genreData in genresData {
                                // Отримуємо id та назву жанру
                                let id = genreData["id"] as? Int
                                let name = genreData["name"] as? String
                                // Додаємо жанр до словника
                                if let id = id, let name = name {
                                    self.genres[id] = name
                                }
                            }
                        }
                    } catch {
                        print("Помилка розпарсювання JSON: \(error.localizedDescription)")
                    }
                }
            }
            // Запускаємо data task
            task.resume()
        }
    }
    
    
    
    func getGenreNames( for genreIds: [Int], from genres: [Int:String]) -> String?{
        var genreNames: [String] = []
        for genreId in genreIds {
            if let genreName = genres[genreId]{
                genreNames.append(genreName)
            }
        }
        return genreNames.first
    }
    
    func fetchMovieDuration(for movie: Movie, completion: @escaping (Result<Int, Error>) -> Void) {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)?api_key=55957fcf3ba81b137f8fc01ac5a31fb5") else {
                return completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            }
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                    return
                }
                if statusCode <= 299 && statusCode >= 200 {
                    guard let data = data else {
                        completion(.failure(NSError(domain: "Invalid data", code: 0, userInfo: nil)))
                        return
                    }
                    let decoder = JSONDecoder()
                    guard let movieDetails = try? decoder.decode(MovieDetails.self, from: data) else {
                        completion(.failure(NSError(domain: "Invalid data format", code: 0, userInfo: nil)))
                        return
                    }
                    completion(.success(movieDetails.duration!))
                } else {
                    completion(.failure(NSError(domain: "Invalid status code", code: statusCode, userInfo: nil)))
                }

            }.resume()
        }
    
    func updateMovieDurations(for movies: [Movie]) async {
        await withCheckedContinuation { continuation in
            var items = movies.count
            for movie in movies {
                fetchMovieDuration(for: movie) { result in
                    switch result {
                    case .success(let duration):
                        DispatchQueue.main.async {
                            self.movieDurations[movie.id] = duration // Update the movieDurations dictionary
                        }
                        
                    case .failure(let error):
                        print("Error fetching duration for movie \(movie.title): \(error.localizedDescription)")
                    }
                    items -= 1
                    if items < 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        continuation.resume(returning: Void())
                    }
                }
            }
        }
        
    }
    
 
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let cellWidth = collectionView.frame.width / 2 - 10
         let cellHeight: CGFloat = 370
        
        
         return CGSize(width: cellWidth, height: cellHeight)
     }
}


extension HomeViewController: UICollectionViewDelegate {
    
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowShowingTableViewCell", for: indexPath) as? NowShowingTableViewCell else{
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.row]
        let imageUrl =  URL(string: "https://image.tmdb.org/t/p/w500//\(movie.poster)")!
        let imageData = try? Data(contentsOf: imageUrl)
        cell.posterImage.image = UIImage(data: imageData!)
        cell.titleLable.text = movie.title
//        cell.genreLable.text = movie.genre
        // Використання функції для отримання назв жанрів з масиву цілих чисел
        if let genreIds = movies[indexPath.row].genreIds {
            let genreName = getGenreNames(for: genreIds, from: genres)
//            let genreString = genreNames.joined(separator: ", ")
            cell.genreLable.text = genreName
        } else {
            cell.genreLable.text = "Жанри невідомі"
        }
        
        if let duration = movieDurations[movie.id] {
            cell.durationLable.text = "\u{00B7}\(duration/60)hr\(duration%60)m"
                } else {
                    cell.durationLable.text = "N/A"
                }
        
        
        return cell
    }
    
}



