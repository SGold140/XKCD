//
//  Constants.swift
//  studio
//
//  Created by Samuel Goldsmith on 3/8/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import Foundation

struct C {
    struct Url {
        static let Path = "https://xkcd.now.sh/"
        struct Parameters {
            static let Month = "month"
            static let Day = "day"
            static let Year = "year"
            static let Image = "img"
            static let Alternate = "alt"
            static let Title = "title"
            static let Number = "num"
        }
    }
    struct Fetch {
        static let Amount = 5
        static let Maximum = 250
    }
}
