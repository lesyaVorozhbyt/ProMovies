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
                await movieDuration.updateMovieDurations(for: movies)
                DispatchQueue.main.async {
                                            self.collectionView.reloadData()
                                        }
            }
        case 1:
            Task{
                await fetchComingSoonMovies()
                await movieDuration.updateMovieDurations(for: movies)
                DispatchQueue.main.async {
                                            self.collectionView.reloadData()
                                        }
            }
        default:
            break
        }
    }
 
    var movies = [Movie]()
    let movieDuration = MovieDurations()
    let genres = Genres()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark

        genres.fetchGenres()
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout

        
        configCollectionView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Star Movie"
        Task {
            await fetchNowShowingMovies()
            await movieDuration.updateMovieDurations(for: movies)
            DispatchQueue.main.async {
                                        self.collectionView.reloadData()
                                    }
        }
        
    }

    
    func fetchNowShowingMovies() async {
        await withCheckedContinuation { continuation in
            MoviesNetworkManager.shared.fetchComingNowMovies { [weak self] response in
                switch response {
                case .success(let movies):
                    self?.movies = movies.results
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
                    self?.movies = movies.results
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
        
        if let posterPath = movie.posterPath ,
           let imageUrl =  URL(string: "https://image.tmdb.org/t/p/w500//\(posterPath)"){
            let imageData = try? Data(contentsOf: imageUrl)
            cell.posterImage.image = UIImage(data: imageData!)
        }
      
        cell.titleLabel.text = movie.title
        
        if let genreIds = movies[indexPath.row].genreIds {
            let genreName = genres.getGenreNames(for: genreIds, from: genres.genres)
            cell.genreLabel.text = genreName
        } else {
            cell.genreLabel.text = "Жанри невідомі"
        }
        
        if let duration = movieDuration.movieDurations[movie.id] {
            cell.durationLabel.text = "\u{00B7}\(duration/60)hr\(duration%60)m"
                } else {
                    cell.durationLabel.text = "N/A"
                }
        cell.configure(rating: ((movie.voteAverage ?? 0) * 10))
        
        return cell
    }
    
}



