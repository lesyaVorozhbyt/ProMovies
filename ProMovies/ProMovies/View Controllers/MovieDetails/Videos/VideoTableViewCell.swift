//
//  VideoTableViewCell.swift
//  ProMovies
//
//  Created by Test on 03.04.2023.
//

import UIKit
import WebKit

class VideoTableViewCell: UITableViewCell {
    @IBOutlet weak var playVideoWebKit: WKWebView!
    
    static let identifier = "VideoCell"
    
    var key: String?
    
    func playVideo() {
        guard let key = self.key else { return }
        guard var url = URL(string: "https://www.themoviedb.org/video/play?key=\(key)&width=990&height=630&_=1682418478611") else { return }
        playVideoWebKit?.load(URLRequest.init(url: url))
    }
}
