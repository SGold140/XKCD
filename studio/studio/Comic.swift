//
//  Comic.swift
//  studio
//
//  Created by Samuel Goldsmith on 2/25/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import UIKit

class Comic {

    var title: String
    var number: String
    var image: String
    var published_date: String
    var alternate_text: String
    
    init(title: String, number: String, image: String, publishedDate: String, alternateText: String) {
        self.title = title
        self.number = number
        self.image = image
        self.published_date = publishedDate
        self.alternate_text = alternateText
    }
    
}
