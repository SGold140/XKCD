//
//  ViewModel.swift
//  studio
//
//  Created by Samuel Goldsmith on 2/25/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import UIKit

class ComicsViewModel {
    
    let comicsURL = "https://xkcd.now.sh/"
    let comic: Comic
    
    init(comic: Comic) {
        self.comic = comic
    }
    
    var title: String {
        return comic.title
    }
    
    var number: String {
        return comic.number
    }
    
    var image: String {
        return comic.image
    }
    
    var publishedDate: String {
        return comic.published_date
    }
    
    var alternateText: String {
        return comic.alternate_text
    }
    
    func getComics() -> [Comic] {
        
        return []
    }
    
}
