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
  
    
    @IBOutlet weak var comicsTableView: UITableView!
    var barButtonItem1: UIBarButtonItem!
    var barButtonItem2: UIBarButtonItem!
    var barButtonItem3: UIBarButtonItem!
    
    let viewModel = ComicsViewModel()
    var comicsArray: [Comic] = []
    var limit = 10
    var maxNumComics = 500 // arbitrary number
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        comicsTableView.register(UINib(nibName: "ComicsTableViewCell", bundle: nil), forCellReuseIdentifier: "comic")
        viewModel.delegate = self
        
        comicsTableView.delegate = self
        comicsTableView.dataSource = self

        setupNavbar()
        viewModel.fetchComics()
//        comicsTableView.reloadData()
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
        let barButtonItem3 = UIBarButtonItem()
        barButtonItem3.addBadge(number: 99, color: UIColor.white)
        navigationItem.leftBarButtonItems = [barButtonItem1]
        navigationItem.rightBarButtonItems = [barButtonItem3, barButtonItem2]
        
    }
    
    func addBadge(itemvalue: String) -> UIBarButtonItem {
        
        let badgeButton = UILabel()
        badgeButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        badgeButton.tintColor = UIColor.black
//        badgeButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        
        return UIBarButtonItem(customView: badgeButton)
        
    }
    
    @objc func gotoFavorites() {
        self.performSegue(withIdentifier: "favorites", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! FavoritesViewController
    }
    
}

extension ComicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicsArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 1.7
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = comicsTableView.dequeueReusableCell(withIdentifier: "comic", for: indexPath) as! ComicsTableViewCell
        cell.selectionStyle = .none
        cell.comic = comicsArray[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("IndexPath: \(indexPath.row)")
        // Check to see if we're at the last cell
        if indexPath.row == comicsArray.count - 1 {
            if comicsArray.count < maxNumComics { // 500 -> arbitrary large number
                let index = comicsArray.count
                limit = index + 10
                
                // Fetch the next 10 comics
                viewModel.fetchComics(start: index + 1, end: limit)
                self.perform(#selector(loadPages), with: nil, afterDelay: 1.0)
            }
        }
    }
    
    @objc func loadPages() {
        self.comicsTableView.reloadData()
    }
    
}

extension ComicsViewController: ComicsProtocol {
    func loadComic(comic: Comic) {
        self.comicsArray.append(comic)
        print("COMICS ARRAY COUNT: \(self.comicsArray.count)")
        
        // Once 10 comics have been added to the array, call reloadData() on tableView
        if comicsArray.count % 10 == 0 {
            DispatchQueue.main.async {
                self.comicsTableView.reloadData()
            }
        }
    }
    
    
    func makeFavorite() {
        
        // Fetch the correct comic from CoreData
        
        // Set isFavorite = true
        
        // Reload the row to display the heart
    }
    
    
}
