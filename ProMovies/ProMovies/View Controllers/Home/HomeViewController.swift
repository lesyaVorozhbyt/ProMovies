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
            fetchNowShowingMovies()
        case 1:
            fetchComingSoonMovies()
        default:
            break
        }
    }
    
    var movies = [Movie]()
    var genres: [Int: String] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        fetchGenres()
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout

        configCollectionView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Star Movie"
        fetchNowShowingMovies()
    }
    
    func fetchNowShowingMovies() {
        MoviesNetworkManager.shared.fetchComingNowMovies { [weak self] response in
            switch response {
            case .success(let movies):
                self?.movies = movies
                print("Success")
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .error(_):
                print("Error message")
            }
        }
    }

    func fetchComingSoonMovies() {
        MoviesNetworkManager.shared.fetchComingSoonMovies { [weak self] response in
            switch response {
            case .success(let movies):
                self?.movies = movies
                print("Success")
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .error(_):
                print("Error message")
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
        return cell
    }
}



