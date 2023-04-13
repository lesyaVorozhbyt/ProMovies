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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        let layout = UICollectionViewFlowLayout()
                layout.minimumInteritemSpacing = 10
                collectionView.collectionViewLayout = layout

        configCollectionView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Star Movie"
    
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        
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
 
}




extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let cellWidth = collectionView.frame.width / 2 - 10
         let cellHeight: CGFloat = 300
        
        
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
        
//        let newSize = CGSize(width: 1000, height: 2000)
//        cell.posterImage.image = cell.posterImage.image?.resized(to: newSize)

        cell.titleLable.text = movie.title
        return cell
    }
}



