//
//  FavoritesViewController.swift
//  studio
//
//  Created by Samuel Goldsmith on 2/27/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {


    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet var detailView: UIView!
    let label = UILabel(frame: CGRect(x: 0, y: 5, width: 20, height: 20))
    
    var favorites: [ComicBook] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        favTableView.delegate = self
        favTableView.dataSource = self
        favTableView.backgroundView = BackgroundView.fromNib()
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes =
            [
                NSAttributedString.Key.font: UIFont(name: "MonacoBSemi", size: 22.0)!,
                NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationItem.title = "XKCD"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItems = [addBadge(), UIBarButtonItem(title: "❤️", style: .plain, target: self, action: nil)]
        
        
        
        
    }
    
    func addBadge() -> UIBarButtonItem {
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont(name: "MonacoBSemi", size: 9)
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "\(favorites.count)"
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
        rightButton.addSubview(label)
        
        return UIBarButtonItem(customView: rightButton)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = favTableView.dequeueReusableCell(withIdentifier: "ComicsTableViewCell", for: indexPath) as? ComicsTableViewCell {
            cell.comic = favorites[indexPath.row]
                return cell
        }
        return UITableViewCell()
    }
    
    
}
