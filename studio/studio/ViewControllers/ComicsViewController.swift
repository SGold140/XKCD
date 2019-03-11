//
//  ViewController.swift
//  studio
//
//  Created by Samuel Goldsmith on 2/24/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import UIKit
import CoreData

class ComicsViewController: UIViewController, UITableViewDelegate {

  
//    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var comicsTableView: UITableView!
    
    var barButtonItem1: UIBarButtonItem!
    var barButtonItem2: UIBarButtonItem!
    var barButtonItem3: UIBarButtonItem!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext?
    
    let viewModel = ComicsViewModel()
    var comicEntities: [ComicBook] = []
    var chosenComic: ComicBook?
    var limit: Int?
    var maxNumComics = 50 // arbitrary number
    var isInitialFetch = true
    var numFavComics: Int = 0
    let amount = C.Fetch.Amount
    let label = UILabel(frame: CGRect(x: 0, y: 5, width: 20, height: 20))
    var isFullScreen = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.activityStartAnimating(activityColor: .white, backgroundColor: .darkGray)
        viewModel.delegate = self
        context = appDelegate.persistentContainer.viewContext
        comicsTableView.delegate = self
        comicsTableView.dataSource = self
        comicsTableView.estimatedRowHeight = 450.0
        viewModel.fetchComics(start: 1, end: 5)
        numFavComics = comicEntities.filter{ $0.isFavorite }.count
    }
    
    override func viewWillLayoutSubviews() {
        comicsTableView.register(UINib(nibName: "ComicsTableViewCell", bundle: nil), forCellReuseIdentifier: "comic")
        setupNavbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    func setupNavbar() {
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes =
        [
            NSAttributedString.Key.font: UIFont(name: "MonacoBSemi", size: 22.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationItem.title = "XKCD"
        
        barButtonItem1 = UIBarButtonItem(title: "<", style: .plain, target: self, action: nil)
        barButtonItem1.tintColor = UIColor.white
        barButtonItem2 = UIBarButtonItem(title: "❤️", style: .plain, target: self, action: #selector(gotoFavorites))
        
        
        barButtonItem3 = addBadge()
        
        navigationItem.leftBarButtonItems = [barButtonItem1]
        navigationItem.rightBarButtonItems = [barButtonItem3, barButtonItem2]
        
    }
    
    func addBadge() -> UIBarButtonItem {
        
//        let label = UILabel(frame: CGRect(x: 0, y: 5, width: 20, height: 20))
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont(name: "MonacoBSemi", size: 9)
        label.textColor = .black
        label.backgroundColor = .white
        
        
        label.text = "\(numFavComics)"
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
        rightButton.addSubview(label)

        // Bar button item
        return UIBarButtonItem(customView: rightButton)
    }

    
    @objc func gotoFavorites() {
        self.performSegue(withIdentifier: "favorites", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "favorites" {
            let dest = segue.destination as! FavoritesViewController
            dest.favorites = comicEntities.filter { $0.isFavorite }
        }
        if segue.identifier == "details" {
            let comic = chosenComic
            let dest = segue.destination as! DetailViewController
            dest.modalPresentationStyle = .overCurrentContext
            dest.comic = comic
            dest.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3.3)
        }
        
    }
}

extension ComicsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicEntities.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = comicsTableView.dequeueReusableCell(withIdentifier: "ComicsTableViewCell", for: indexPath) as? ComicsTableViewCell
        cell?.delegate = self
        cell?.isUserInteractionEnabled = true
        cell?.selectionStyle = .none
        cell?.comic = comicEntities[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let c = comicEntities.count
        if indexPath.row == c-1 { // Last cell
            if c < maxNumComics {
                limit = c + amount
                
                if let lim = self.limit {
                    self.viewModel.fetchComics(start: c-1, end: lim-1)
                }
            }

        }
       
    }
}

extension ComicsViewController: ComicsProtocol {
    func removeActionSheet(view: UIView) {
        view.removeFromSuperview()
    }
    
    func showDetailView(comic: ComicBook) {
        self.chosenComic = comic 
//        if let _ = UIApplication.getTopMostViewController() {
            performSegue(withIdentifier: "details", sender: self)
//        }

    }
    
    func loadComics(comics: [ComicBook], start: Int, end: Int) {
        for comic in comics {
            if !comicEntities.contains(comic) {
                self.comicEntities.append(comic)
            }
        }
        DispatchQueue.main.async {
            self.comicsTableView.reloadData()
        }
        self.view.activityStopAnimating()
    }
 
    func makeFavorite(number: String, idx: IndexPath) {
        // Fetch the comic from CoreData
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ComicBook")
        fetchRequest.predicate = NSPredicate(format: "number == %@", number)
        if let comic = try? context?.fetch(fetchRequest).first as? ComicBook {
            comic?.isFavorite = !(comic?.isFavorite)!
            if (comic?.isFavorite)! {
                numFavComics += 1
            } else {
                numFavComics -= 1
            }
        }
        do {
            try context?.save()
        } catch {
            print(error)
        }
        label.text = "\(numFavComics)"
        self.comicsTableView.reloadRows(at: [idx], with: .none)
    }
}
