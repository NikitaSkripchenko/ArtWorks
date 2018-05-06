//
//  ArtWorkTableViewCell.swift
//  FoodTracker
//
//  Created by Nikita Skripchenko on 05.05.2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class ArtWorkTableViewCell: UITableViewCell {

    //Props
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imgLabel: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
