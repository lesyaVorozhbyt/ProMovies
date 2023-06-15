//
//  VideosViewController.swift
//  ProMovies
//
//  Created by Test on 03.04.2023.
//

import UIKit
import WebKit

class VideosViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var url = URL(string: "https://www.youtube.com/watch?v=")
    
    var movieId: String? {
        didSet {
        fetchVideos()
    }
    }
    
    var video = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVideos()
        setupTableView()
        
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
    }
    
    private func fetchVideos() {
        VideoNetworkManager.shared.fetchRequest(movieid: movieId ?? "", completion: { [weak self] response in
                guard let self = self else {return}
            switch response {
            case let .success(items):
                self.video = items.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .error:
                print("bro, something wrong")
            }
        })
    }

}

extension VideosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        video.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier, for: indexPath) as? VideoTableViewCell else {
            return UITableViewCell()
        }
        cell.key = video[indexPath.row].key
        cell.playVideo()
        return cell
    }
}
