//
//  HomeViewController.swift
//  ProMovies
//
//  Created by Test on 23.03.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark

        MoviesNetworkManager.shared.fetchComingNowMovies { [weak self] response in
               switch response {
               case .success(let movies):
                   self?.movies = movies
                   print("Success")
                   DispatchQueue.main.async {
                       self?.collectionView.reloadData()
                   }
               case .error(let errorMessage):
                   print("Error message")
               }
           }
        
        let layout = UICollectionViewFlowLayout()
                layout.minimumInteritemSpacing = 10
                collectionView.collectionViewLayout = layout

        configCollectionView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Star Movie"
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
         let cellHeight: CGFloat = 400
        
        
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
        let imageUrl = URL(string: movie.poster)
        let imageData = try? Data(contentsOf: imageUrl!)
        cell.posterImage.image = UIImage(data: imageData!)
        cell.titleLable.text = movie.name
        return cell

    }
    
    
}
