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
    @IBOutlet weak var mainMovieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisDescription: UILabel!
    
    @IBOutlet weak var videosCollectionView: UICollectionView!
    @IBOutlet weak var synopsisView: UIView!
    @IBOutlet weak var blurBackgroundImage: UIImageView!
    @IBOutlet weak var segmaentControlMovie: UISegmentedControl!
    @IBOutlet var starRatingCollection: [UIImageView]!
    
    var movieId: String? {
        didSet {
            uploadMovie()
            uploadCastAndCrew()
            uploadVideos()
        }
    }
    var movie: Movie?
    var castAndCrew: CastAndCrewMembers?
    var reviews: Reviews?
    var videos = [Video]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableAndScroll()
        configCollection()
    }

    
    private func uploadMovie() {
        if let movieId = movieId {
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
    }
    
    private func uploadCastAndCrew() {
        if let movieId = movieId {
            MoviesNetworkManager.shared.fetchCastAndCrewForMovie(movieId) { [weak self] response in
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
    }
    
    private func uploadVideos() {
        VideoNetworkManager.shared.fetchRequest(movieid: movieId ?? "", completion: { [weak self] response in
                guard let self = self else {return}
            switch response {
            case let .success(items):
                self.videos = items.results
                DispatchQueue.main.async {
                    self.videosCollectionView.reloadData()
                }
            case .error:
                print("ooops")
            }
        })
    }
    
    private func configTableAndScroll() {
        castTableView.delegate = self
        castTableView.dataSource = self
        castTableView.backgroundColor = .clear
        
        castTableView.register(UINib(nibName: "CastTableViewCell", bundle: nil), forCellReuseIdentifier: "CastTableViewCell")
        
        castTableView.rowHeight = 67
        scrollView.delegate = self
    }
    
    private func configCollection() {
        videosCollectionView.delegate = self
        videosCollectionView.dataSource = self
        
        videosCollectionView.backgroundColor = .clear
        
        videosCollectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
        videosCollectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeaderView")
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
        durationLabel.text = "\((movie.runtime ?? 0) / 60)hr \((movie.runtime ?? 0) % 60)m"
        
//        if let genres = movie.genreIds {
//            genresLabel.text = genres.map({ String($0) }).joined(separator: ", ")
//        }
        
        
        
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
        
        
    }
    
    @IBAction func segmentControllChanged(_ sender: Any) {
        switch segmaentControlMovie.selectedSegmentIndex {
        case 0:
            synopsisView.isHidden = false
            castTableView.isHidden = false
        case 1:
            synopsisView.isHidden = true
            castTableView.isHidden = true
        default:
            synopsisView.isHidden = true
            castTableView.isHidden = true
        }
    }
    
    // MARK: - Navigation

    @objc func buttonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            performSegue(withIdentifier: "toCastAndCrew", sender: nil)
        }
    }
    
    @IBAction func viewAllVieos(_ sender: Any) {
        let movieDetailsSB = UIStoryboard(name: "MovieDetails", bundle: nil)
        if let videosVC = movieDetailsSB.instantiateViewController(withIdentifier: "VideosViewController") as? VideosViewController {
            videosVC.movieId = movieId
            navigationController?.pushViewController(videosVC, animated: true)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let castAndCrewVC = segue.destination as? CastAndCrewViewController, segue.identifier == "toCastAndCrew" {
            castAndCrewVC.castAndCrew = castAndCrew
        }
    }
}

