//
//  NowShowingTableViewCell.swift
//  ProMovies
//
//  Created by Lera Cuk on 03.04.2023.
//

import UIKit

class NowShowingTableViewCell: UICollectionViewCell {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var starRatingView: StarRatingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
//    var starRatingView = StarRatingView()
        
    func configure(rating: Double) {
        if starRatingView == nil {
//            starRatingView = StarRatingView()
            self.contentView.addSubview(starRatingView)
            starRatingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                starRatingView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                starRatingView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                starRatingView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                starRatingView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
        }
        starRatingView.update(rating1: rating) // convert percentage to star rating
    }
    
    
}

