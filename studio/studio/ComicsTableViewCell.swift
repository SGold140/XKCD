//
//  ComicsTableViewCell.swift
//  studio
//
//  Created by Samuel Goldsmith on 2/25/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import UIKit

class ComicsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var altTextLabel: UILabel!
    @IBOutlet weak var comicImage: UIImageView!
    
    var comic: Comic? {
        didSet {
            titleLabel.text = comic?.title
            numberLabel.text = String(describing: comic!.number)
            dateLabel.text = comic?.published_date
            altTextLabel.text = comic?.alternate_text
            comicImage.image = comic?.image
        }
    }
    
}
