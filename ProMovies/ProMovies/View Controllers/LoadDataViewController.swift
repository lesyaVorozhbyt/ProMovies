//
//  LoadDataViewController.swift
//  ProMovies
//
//  Created by Jane Strashok on 13.03.2023.
//

import UIKit

class LoadDataViewController: UIViewController {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var sucessView: UIView!
    @IBOutlet weak var errorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callNM()
    }
    
    private func callNM() {
        MoviesNetworkManager.shared.fetchComingNowMovies(completion: { [weak self] response in
            guard let self = self else { return }
            self.loadingView.isHidden = true
            switch response {
            case let .success(movies):
                self.sucessView.isHidden = false
            case .error:
                self.errorView.isHidden = false
            }
//            self.movies = movies
//            DispatchQueue.main.async {
//                self.itemsList.reloadData()
//                self.refreshControl.endRefreshing()
//            }
        })
    }

}
