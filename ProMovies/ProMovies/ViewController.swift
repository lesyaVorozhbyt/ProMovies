//
//  ViewController.swift
//  ProMovies
//
//  Created by Антон Яценко on 23.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var movies: [Movie]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        callNM()
        // Do any additional setup after loading the view.
    }


    private func callNM() {
        MoviesNetworkManager.shared.fetchComingNowMovies(completion: { [weak self] movies in
            guard let self = self else { return }
//            self.movies = movies
//            DispatchQueue.main.async {
//                self.itemsList.reloadData()
//                self.refreshControl.endRefreshing()
//            }
        })
    }
}

