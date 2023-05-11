//
//  ReviewTableViewCell.swift
//  ProMovies
//
//  Created by Jane Strashok on 10.04.2023.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewView: UIView!
    @IBOutlet var starReviewCollection: [UIImageView]!
    @IBOutlet weak var reviewContent: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var publishDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
