//
//  ViewModel.swift
//  studio
//
//  Created by Samuel Goldsmith on 2/25/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreData

class ComicsViewModel {
    
    var delegate: ComicsProtocol?
    var CP = C.Url.Parameters.self
    
    func fetchComics(start: Int, end: Int) {
        var comicBooks = [ComicBook]()
//        clearData()
        let endpoint = C.Url.Path
        comicFor: for _ in start...end {
            
            Alamofire.request("\(endpoint)/\(Int.random(in: 0...2000))")
                .responseJSON(completionHandler: { response in
//                    print(response)
                    
                guard response.result.error == nil else { return }
                guard let json = response.result.value as? [String: Any] else { return }
                
                self.getData(from: URL(string: json[self.CP.Image] as! String)!, completion: { (data, response, error) in
                    
                    guard let _ = data, error == nil else { return }
                    
//                    print(json)
                    let url = json[self.CP.Image] as? String
//                    let image = UIImage(data: data, scale: 1.0)
                    var num: String = ""
                    if let number = (json[self.CP.Number] as? Int) {
                        num = String(number)
                    }
                    
                    let alt = json[self.CP.Alternate] as? String
                    let title = json[self.CP.Title] as? String
                    
                    if let month = json[self.CP.Month] as? String,
                        let day = json[self.CP.Day] as? String,
                        let year = json[self.CP.Year] as? String
                    {
                        let c = NSDateComponents()
                        c.year = Int(year)!
                        c.month = Int(month)!
                        c.day = Int(day)!
                        let date1 = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: c as DateComponents)
                        
                        let df = DateFormatter()
                        
                        let month1 = "\(df.monthSymbols[Int(month)! - 1]) \(day)\(c.day.getSuffix()), \(year)"
                        if let millis = date1?.toMillis() {
                            DispatchQueue.main.async {
                                if let comic = self.makeComicBook(named: title!, withPublishedDate: month1, andTimestamp: millis, number: num, alternateText: alt!, url: url!) {
                                        comicBooks.append(comic)
                                        if comicBooks.count == C.Fetch.Amount {
                                            self.delegate?.loadComics(comics: comicBooks, start: start, end: end)
                                        }
                                    }
                                }
                        }
                    }
                })
            })
        }
    }
    
    func loadComics(start: Int, end: Int) -> [ComicBook] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let context = appDelegate.persistentContainer.viewContext as? NSManagedObjectContext else { return [] }
        var s = start
        var cb: [ComicBook] = []
        let fetchRequest = NSFetchRequest<ComicBook>(entityName: "ComicBook")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let comicBooks = try? context.fetch(fetchRequest) as? [ComicBook], let count = comicBooks?.count, count != 0 {
            for comic in Array((comicBooks?[s..<end])!) {
               cb.append(comic)
            }
        }
        return cb
    }
    
    func makeComicBook(named title: String, withPublishedDate date: String, andTimestamp timestamp: Double, number: String, alternateText alt: String, url: String) -> ComicBook? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let context = appDelegate.persistentContainer.viewContext as? NSManagedObjectContext else { return nil }
        guard let entity = NSEntityDescription.entity(forEntityName: "ComicBook", in: context) else { return nil }
        
        let comicBook = NSManagedObject(entity: entity, insertInto: context) as? NSManagedObject
        
        comicBook?.setValue(title, forKeyPath: "title")
        comicBook?.setValue(date, forKeyPath: "published_date")
        comicBook?.setValue(number, forKeyPath: "number")
        comicBook?.setValue(false, forKey: "isFavorite")
        comicBook?.setValue(alt, forKeyPath: "alternate_text")
        comicBook?.setValue(url, forKey: "image_url")
        comicBook?.setValue(timestamp, forKey: "timestamp")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error)")
        }
        
        return comicBook as! ComicBook
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func clearData() {
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let context = appDelegate.persistentContainer.viewContext as? NSManagedObjectContext else { return }
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ComicBook")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
}

protocol ComicsProtocol {
    func removeActionSheet(view: UIView)
    func showDetailView(comic: ComicBook)
    func loadComics(comics: [ComicBook], start: Int, end: Int)
    func makeFavorite(number: String, idx: IndexPath)
}
