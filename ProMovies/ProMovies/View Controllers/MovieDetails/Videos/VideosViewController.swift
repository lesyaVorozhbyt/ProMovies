//
//  VideosViewController.swift
//  ProMovies
//
//  Created by Test on 03.04.2023.
//

import UIKit

class VideosViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movieId: String? {
        didSet {
//        fetchVideos()
    }
    }
    
    var video = [VideoResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: delete hardcode
        movieId = "980078"
        
//        fetchVideos()
        setupTableView()
        
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
//    private func fetchVideos() async {
//        await withCheckedContinuation { countinuation in
//            MoviesNetworkManager.shared.fetchVideos(moviesId: movieId, completion: { [weak self] response in
//            switch response {
//            case let .success(video):
//                self.video = video
//                self.tableView.reloadData()
//            case .error:
//                print("bro, something wrong")
//            })
//            countinuation.resume(returning: Void())
//            }
//        }
//    }

}

extension VideosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        video.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier, for: indexPath) as? VideoTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    
}
