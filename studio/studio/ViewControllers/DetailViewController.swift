//
//  DetailViewController.swift
//  studio
//
//  Created by Samuel Goldsmith on 3/10/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var numberDateLabel: UILabel!
    @IBOutlet var heartImageLabel: UILabel!
    @IBOutlet var alternateLabel: UILabel!

    var comic: ComicBook? {
        didSet {
            createLabels()
        }
    }
    
    var titleLabelText: String?
    var numberLabelText: String?
    var altLabelText: String?
    
    override func viewDidLoad() {
        guard let comic = comic else { return }
        print(comic)
//        createLabels()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
        self.view.addGestureRecognizer(tap)
    }

    @objc func tapToDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
         view.frame = CGRect(x: 0, y: view.globalPoint!.y + (UIScreen.main.bounds.height - 250.0), width: UIScreen.main.bounds.width, height: 250.0)
         view.isUserInteractionEnabled = true
    }
    
    func createLabels() {
        titleLabel = UILabel()
        numberDateLabel = UILabel()
        alternateLabel = UILabel()
        heartImageLabel = UILabel()
        
        for label in [titleLabel, numberDateLabel, alternateLabel, heartImageLabel] {
            view.addSubview(label!)
        }
        setupLabels(comic: comic!)
        makeConstraints()
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(-50.0)
            make.width.equalTo(view.snp.width).offset(30.0)
            make.left.equalTo(view.snp.left).offset(10.0)
        }
        numberDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(-40.0)
            make.width.equalTo(view.snp.width)
            make.left.equalTo(view.snp.left).offset(10.0)
        }
        heartImageLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.frame.midY)
            make.right.equalTo(view.frame.maxX).offset(-20.0)
        }
        alternateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(numberDateLabel.snp.bottom).offset(20.0)
            make.width.equalTo(view.snp.width).offset(-25.0)
            make.centerX.equalTo(view.frame.midX)
            make.bottom.equalTo(view.frame.maxY).offset(-40.0)
        }
    }
    
    func setupLabels(comic: ComicBook) {
        if let title = comic.title {
            titleLabel.text = title
        }
        if let pubDate = comic.published_date, let num = comic.number {
            numberDateLabel.text = "#\(num) • \(pubDate))"
        }
        if let alt = comic.alternate_text {
            alternateLabel.text = alt
        }
        heartImageLabel.layer.opacity = self.comic?.isFavorite ?? false ? 1.0 : 0.4
    }
    
}


