//
//  VideoCollectionViewCell.swift
//  ProMovies
//
//  Created by Jane Strashok on 09.06.2023.
//

import UIKit
import WebKit

class VideoCollectionViewCell: UICollectionViewCell, WKNavigationDelegate {

    @IBOutlet weak var videoPreviewHolder: WKWebView!
    var key: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoPreviewHolder.navigationDelegate = self
        // Initialization code
    }
    
    func playVideo() {
        guard let key = self.key else { return }
        guard var url = URL(string: "https://www.themoviedb.org/video/play?key=\(key)&width=990&height=630&_=1682418478611") else { return }
        videoPreviewHolder?.load(URLRequest.init(url: url))
        videoPreviewHolder.allowsBackForwardNavigationGestures = true
    }
}
