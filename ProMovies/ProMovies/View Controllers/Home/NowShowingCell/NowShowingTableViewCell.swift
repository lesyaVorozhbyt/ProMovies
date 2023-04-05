//
//  NowShowingTableViewCell.swift
//  ProMovies
//
//  Created by Lera Cuk on 03.04.2023.
//

import UIKit

class NowShowingTableViewCell: UICollectionViewCell {

    @IBOutlet weak var durationLable: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var genreLable: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
