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
    
    @IBOutlet weak var synopsisView: UIView!
    @IBOutlet weak var blurBackgroundImage: UIImageView!
    @IBOutlet weak var segmaentControlMovie: UISegmentedControl!
    @IBOutlet var starRatingCollection: [UIImageView]!
    var movieId: String = "458156"
    var movie: Movie?
    
    let image = UIImage(named: "randonImage")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        callNM()
        //updateUI()
        // Do any additional setup after loading the view.
    }

    
    private func callNM() {
        MoviesNetworkManager.shared.fetchMovieById(movieId, completion: { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(movie):
                self.movie = movie
                DispatchQueue.main.async {
                    self.updateUI()
                }
            case .error:
                print("oooops")
            }
        })
    }
    
    private func updateUI() {
        guard let movie = movie else { return }
        
        let dispatchQueue = DispatchQueue(label: "com.dowlload.image")
        let blurImageUrl = URL(string: "https://image.tmdb.org/t/p/w500//\(movie.backdropPath!)")!
        let posterImageData = URL(string: "https://image.tmdb.org/t/p/w500//\(movie.posterPath!)")!
        dispatchQueue.async {
            if let blurImageData = try? Data(contentsOf: blurImageUrl),
               let posterImageData = try? Data(contentsOf: posterImageData) {
                DispatchQueue.main.async { [weak self] in
                  guard let self = self else { return }
                    self.blurBackgroundImage.image = UIImage(data: blurImageData)
                    self.mainMovieImage.image = UIImage(data: posterImageData)
                }
            }
        }
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterialDark)
        let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurBackgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.9
        blurBackgroundImage.contentMode = .scaleAspectFill
        blurBackgroundImage.addSubview(blurEffectView)
        let selectedStateSC: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let normalStateSC: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        
        movieTitle.text = movie.title
        
        let hours = (movie.runtime)/60
        let minutes = movie.runtime - hours*60
        durationLabel.text = "\(hours)hr \(minutes)m"
        
        let genres = movie.genres.map { $0.name }.joined(separator: ", ")
        genresLabel.text = genres
        
        let rating = round(movie.voteAverage/2 * 10) / 10.0
        ratingLabel.text = "\(rating)/5"
        
        let floorRating = floor(rating)
        let remainingRating = rating - floorRating
        
        for index in 0..<Int(floorRating) {
            starRatingCollection[index].image = UIImage(systemName: "star.fill")
            if remainingRating > 0, index == Int(floorRating)-1 {
                starRatingCollection[index+1].image = UIImage(systemName: "star.fill.left")
            }
        }
        
        synopsisDescription.text = movie.overview
        
        
        
        segmaentControlMovie.setTitleTextAttributes(selectedStateSC, for: .selected)
        segmaentControlMovie.setTitleTextAttributes(normalStateSC, for: .normal)
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
