//
//  ViewModel.swift
//  studio
//
//  Created by Samuel Goldsmith on 2/25/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import UIKit
import Alamofire

class ComicsViewModel {
    var delegate: ComicsProtocol?
    
    func fetchComics(start: Int = 1, end: Int = 10) {
        
        let endpoint = "https://xkcd.now.sh/"
//        var comics: [Comic] = []
        var tempComics: [Comic] = []
        for i in start...end {
            print("i is \(i), start: \(start)")
            print("-----------------")
            Alamofire.request(endpoint + "\(i)")
                .responseJSON(completionHandler: { response in
                    print(response)
                    guard response.result.error == nil else { return }
                    guard let json = response.result.value as? [String: Any] else { return }
                    self.getData(from: URL(string: json["img"] as! String)!, completion: { (data, response, error) in
                        guard let data = data, error == nil else { return }
                        
                        let image = UIImage(data: data, scale: 1.0)
                        let number = json["num"] as! Int
                        let alt = json["alt"] as! String
                        let publishedDate = self.getPublishedDate(month: json["month"] as! String, day: json["day"] as! String, year: json["year"] as! String)
                        let title = json["title"] as! String
                        
                        let comic = Comic.init(title: title, number: number, image: image!, publishedDate: publishedDate, alternateText: alt)
                        self.delegate?.loadComic(comic: comic)
                    })
                })
            }
        }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getPublishedDate(month: String, day: String, year: String) -> String {
        var date: String = "\(month)/\(day)/\(year)"
        return date
    }
    
}

protocol ComicsProtocol {
    func loadComic(comic:Comic)
    func makeFavorite()
}
