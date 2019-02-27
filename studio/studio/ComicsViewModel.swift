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
    func fetchComics()
    {
        
        let endpoint = "https://xkcd.now.sh/"
        var comics: [Comic] = []
        Alamofire.request(endpoint)
            .responseJSON(completionHandler: { response in

                guard response.result.error == nil else { return }
                guard let json = response.result.value as? [String: Any] else { return }
                self.getData(from: URL(string: json["img"] as! String)!, completion: { (data, response, error) in
                    guard let data = data else { return }
                    guard error == nil else { return }
                    
                    let image = UIImage(data: data, scale: 1.0)
                    let number = json["num"] as! Int
                    let alt = json["alt"] as! String
                    let publishedDate = self.getPublishedDate(month: json["month"] as! String, day: json["day"] as! String, year: json["year"] as! String)
                    let title = json["title"] as! String
                    
                    let comic = Comic.init(title: title, number: number, image: image!, publishedDate: publishedDate, alternateText: alt)
                    comics.append(comic)
                    self.delegate?.loadComics(comics: comics)
                })
                
            })
        }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getPublishedDate(month: String, day: String, year: String) -> String {
        var date: String = "\(month)/\(day)/\(year)"
        return date
    }
    
}
