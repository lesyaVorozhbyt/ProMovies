//
//  CastTableViewCell.swift
//  ProMovies
//
//  Created by Jane Strashok on 04.04.2023.
//

import UIKit

class CastTableViewCell: UITableViewCell {

    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var realName: UILabel!
    @IBOutlet weak var photo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
