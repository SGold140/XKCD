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
    func fetchComics() //-> [Comic]
    {
        let endpoint = "https://xkcd.now.sh/"
        var comics: [Comic] = []
        Alamofire.request(endpoint)
            .responseJSON { response in
                
                guard response.result.error == nil else { return }
                guard let json = response.result.value as? [String: Any] else { return }
                print(json)
//                guard let year = json["year"] as? String else { return }
//                guard let number = json["num"] as? String else { return }
////                guard let image = json["img"] as? String else { return }
////                guard let title = json["title"] as? String else { return }
//                guard let alternateText = json["alt"] as? String else { return }
                comics.append(Comic(title: "Comic", number: "3", image: "img", publishedDate: "10/22/12", alternateText: "alternate"))
                self.delegate?.loadComics(comics: comics)
        }
//
//        guard let url = URL(string: endpoint) else {
//            print("Error: cannot create URL")
//            return []
//        }
//        var fetchedComics: [Comic] = []
//        let urlRequest = URLRequest(url: url)
//        let session = URLSession.shared
//        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
//            guard error == nil else { return }
//            guard let responseData = data else { return }
//            do {
//                guard let comic = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else { return }
//                print(comic.description)
//                guard let year = comic["year"] as? String else { return }
//                guard let number = comic["num"] as? String else { return }
//                guard let image = comic["img"] as? String else { return }
//                guard let title = comic["title"] as? String else { return }
//                guard let alternateText = comic["alt"] as? String else { return }
//
//                let newComic = Comic(title: title, number: number, image: image, publishedDate: year, alternateText: alternateText)
//                fetchedComics.append(newComic)
//                print(year)
//            } catch {
//                print("error converting data")
//                return
//            }
//        })
//        task.resume()
//        return fetchedComics
    }
}
