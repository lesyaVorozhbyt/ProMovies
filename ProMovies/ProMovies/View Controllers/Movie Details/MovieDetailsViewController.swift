//
//  MovieDetailsViewController.swift
//  ProMovies
//
//  Created by Jane Strashok on 03.04.2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var castTableView: UITableView!
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var mainMovieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisDescription: UILabel!
    
    @IBOutlet weak var reviewsCount: UILabel!
    
    @IBOutlet weak var synopsisView: UIView!
    @IBOutlet weak var blurBackgroundImage: UIImageView!
    @IBOutlet weak var segmaentControlMovie: UISegmentedControl!
    @IBOutlet var starRatingCollection: [UIImageView]!
    
    var movieId: String?
    var movie: Movie?
    var castAndCrew: CastAndCrewMembers?
    var reviews: Reviews?

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableAndScroll()
        uploadMovie()
        uploadCastAndCrew()
        uploadReviews()
        print(reviews)
    }

    
    private func uploadMovie() {
        MoviesNetworkManager.shared.fetchMovieById(movieId ?? "", completion: { [weak self] response in
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
    
    private func uploadCastAndCrew() {
        MoviesNetworkManager.shared.fetchCastAndCrewForMovie(movieId ?? "") { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(castAndCrew):
                self.castAndCrew = castAndCrew
                DispatchQueue.main.async {
                    self.castTableView.reloadData()
                }
            case .error:
                print("ooops")
            }
        }
    }
    
    private func uploadReviews() {
        MoviesNetworkManager.shared.fetchReviewsForMovie(movieId ?? "") { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(reviews):
                self.reviews = reviews
                DispatchQueue.main.async {
                    self.reviewsTableView.reloadData()
                }
            case .error:
                print("oops")
            }
        }
    }
    
    private func configTableAndScroll() {
        castTableView.delegate = self
        castTableView.dataSource = self
        castTableView.backgroundColor = .clear
        
        castTableView.register(UINib(nibName: "CastTableViewCell", bundle: nil), forCellReuseIdentifier: "CastTableViewCell")
        
        castTableView.rowHeight = 67
        scrollView.delegate = self
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
        let selectedStateSC: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.solidTextColor]
        let normalStateSC: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.opacity50TextColor]
        
        movieTitle.text = movie.title
        
        let hours = (movie.runtime ?? 0)/60
        let minutes = (movie.runtime ?? 0) - hours*60
        durationLabel.text = "\(hours)hr \(minutes)m"
        
//        let genres = movie.genres.map { $0.name }.joined(separator: ", ")
//        genresLabel.text = genres
        
        let rating = round((movie.voteAverage ?? 0)/2 * 10) / 10.0
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
        
        reviewsCount.text = "\(reviews?.totalResults ?? 0) Reviews"
        reviewsCount.textColor = UIColor.opacity50TextColor
        reviewsCount.font = UIFont.header3(weight: .regular)
    }
    
    @IBAction func segmentControllChanged(_ sender: Any) {
        switch segmaentControlMovie.selectedSegmentIndex {
        case 0:
            synopsisView.isHidden = false
            castTableView.isHidden = false
            reviewsTableView.isHidden = true
            reviewsCount.isHidden = true
        case 1:
            reviewsTableView.isHidden = false
            synopsisView.isHidden = true
            castTableView.isHidden = true
            reviewsCount.isHidden = false
        default:
            reviewsTableView.isHidden = true
            synopsisView.isHidden = true
            castTableView.isHidden = true
            reviewsCount.isHidden = true
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func buttonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            performSegue(withIdentifier: "toCastAndCrew", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let castAndCrewVC = segue.destination as? CastAndCrewViewController, segue.identifier == "toCastAndCrew" {
            castAndCrewVC.castAndCrew = castAndCrew
        }
    }
}

