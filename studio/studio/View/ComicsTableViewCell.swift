//
//  ComicsTableViewCell.swift
//  studio
//
//  Created by Samuel Goldsmith on 2/25/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import UIKit
import SnapKit

class ComicsTableViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var favButton: UIButton!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var altTextLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var comicImageView: UIImageView!
    var expandedView: UIScrollView?
    
    var delegate: ComicsProtocol?
    let customColor = UIColor.init(hexString: "#505B6E")
    
    override func awakeFromNib() {
        print("Awaking from nib")
        super.awakeFromNib()
        setupOutlets()
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandImage))
        self.addGestureRecognizer(tap)
    }
    
    var comic: ComicBook? {
        didSet {
            if let title = comic?.title {
                self.title = title
            }
            if let num = comic?.number {
                self.number = num
            }
            if let date = comic?.published_date {
                self.date = date
            }
            if let alt = comic?.alternate_text {
                self.alternateText = alt
            }
            if let image = comic?.image_url, let url = URL(string: image), let data = try? Data(contentsOf: url) {
                self.comicImage = UIImage(data: data)
            }
            if let isFavorite = comic?.isFavorite {
                self.isFavorite = isFavorite
            }
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.font = UIFont(name: "MonacoBSemi", size: 25.0)
            titleLabel.sizeToFit()
            titleLabel.textColor = UIColor.white
            titleLabel.text = title
        }
    }
    
    var number: String? {
        didSet {
            numberLabel.font = UIFont(name: "MonacoBSemi", size: 11.0)
            numberLabel.textColor = customColor
            numberLabel.text = "#\(number!) ●"
        }
    }
    
    var date: String? {
        didSet {
            dateLabel.font = UIFont(name: "MonacoBSemi", size: 11.0)
            dateLabel.textColor = customColor
            dateLabel.sizeToFit()
            dateLabel.text = date
        }
    }
    
    var comicImage: UIImage? {
        didSet {
            comicImageView?.image = comicImage
            comicImageView.sizeToFit()
            scrollView.addSubview(comicImageView)
            scrollView.isUserInteractionEnabled = true
        }
    }
    
    var alternateText: String? {
        didSet {
            altTextLabel.font = UIFont(name: "MonacoBSemi", size: 11.0)
            altTextLabel.textColor = customColor
            altTextLabel.text = alternateText
        }
    }
    
    var isFavorite: Bool? {
        didSet {
            if isFavorite! {
                self.favButton.layer.opacity = 1.0
            } else {
                self.favButton.layer.opacity = 0.25
            }
        }
    }
    
    func setupOutlets() {
        titleLabel = UILabel()
        titleLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(titleLabel)
        favButton = UIButton()
        self.addSubview(favButton)
        favButton.setTitle("❤️", for: .normal)
        favButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        
        numberLabel = UILabel()
        self.addSubview(numberLabel)
        dateLabel = UILabel()
        self.addSubview(dateLabel)
        
        scrollView = UIScrollView()
        self.addSubview(scrollView)
        comicImageView = UIImageView()
    
//        comicImageView.contentMode = UIView.ContentMode.scaleAspectFill
//        scrollView.contentSize = comicImageView.bounds.size
        scrollView.addSubview(comicImageView)
        altTextLabel = UILabel()
        self.addSubview(altTextLabel)
        
        favButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20.0)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        favButton.layer.opacity = self.comic?.isFavorite ?? false ? 1.0 : 0.25
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(30.0)
            make.left.equalTo(self).offset(20.0)
            make.right.equalTo(self).offset(favButton.frame.width + 20.0)
        }
      
        
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20.0)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(30.0)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(numberLabel.snp.right).offset(10.0)
            make.centerY.equalTo(numberLabel.snp.centerY)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(numberLabel.snp.bottom).offset(10.0)
            make.left.equalTo(titleLabel.snp.left).offset(20.0)
            make.right.equalTo(favButton.snp.right)
        }
        comicImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(scrollView)
            make.centerX.equalTo(scrollView.snp.centerX)
            make.centerY.equalTo(scrollView.snp.centerY)
        }
        scrollView.contentSize = comicImageView.bounds.size
        altTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(self.snp.right).offset(-20.0)
            make.top.equalTo(scrollView.snp.bottom).offset(10.0)
            make.height.equalTo(40.0).priority(.high)
            make.bottom.equalTo(self).offset(-1.0).priority(.high)
        }
    }
    
    @objc func like() {
        if let num = self.comic?.number, let idx = getIndexPath() {
            self.delegate?.makeFavorite(number: (String(num)), idx: idx)
        }
    }
    
    private func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            return nil
        }
        return superView.indexPath(for: self)
    }
    
    @objc func expandImage(sender: ComicsTableViewCell) {
        if let top = UIApplication.getTopMostViewController() {
            expandedView = UIScrollView(frame: UIScreen.main.bounds)
            expandedView?.tag = 1
            let imageV = UIImageView(image: self.comicImageView.image)
            if let expFrame = expandedView?.frame {
                imageV.frame = expFrame
            }
            imageV.contentMode = .scaleAspectFill
            self.expandedView?.addSubview(imageV)
            self.expandedView?.minimumZoomScale = 1.0
            self.expandedView?.maximumZoomScale = 6.0
            self.expandedView?.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
            expandedView?.addGestureRecognizer(tap)
            
            top.view.addSubview(expandedView!)

            self.delegate?.showDetailView(comic: self.comic!)
        }
    }
    
    @objc func tapToDismiss() {
        self.delegate?.removeActionSheet(view: expandedView!)
    }
}
