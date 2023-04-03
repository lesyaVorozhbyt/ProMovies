//
//  MovieDetailsViewController.swift
//  ProMovies
//
//  Created by Jane Strashok on 03.04.2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var mainMovieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisDescription: UILabel!
    
    @IBOutlet weak var blurBackgroundImage: UIImageView!
    @IBOutlet weak var segmaentControlMovie: UISegmentedControl!
    @IBOutlet var starRatingCollection: [UIImageView]!
    var movieId: String?
    var movie: Movie?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        callNM()
        
        // Do any additional setup after loading the view.
    }

    
    private func callNM() {
        MoviesNetworkManager.shared.fetchMovieById(movieId ?? "", completion: { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(movie):
                self.movie = movie
                self.updateUI()
            case .error:
                print("oooops")
            }
        })
    }
    
    private func updateUI() {
        movieTitle.text = movie?.originalTitle
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
