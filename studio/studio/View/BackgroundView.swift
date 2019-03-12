//
//  BackgroundView.swift
//  studio
//
//  Created by Samuel Goldsmith on 3/10/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import UIKit
import SnapKit

class BackgroundView: UIView {
    
//    @IBOutlet var background: UIView?
    @IBOutlet var heartImage: UILabel!
    @IBOutlet var tapLabel: UILabel!
    @IBOutlet var favLabel: UILabel!
    var containerView: UIView!
    
    override func awakeFromNib() {
//        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupLabels()
        
    }
    
    func setupLabels() {
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200.0))
        tapLabel = UILabel()
        favLabel = UILabel()
        heartImage = UILabel()
        
        heartImage.backgroundColor = UIColor.init(hexString: "96A8C8")
        
        heartImage.text = "❤️"
        heartImage.font = UIFont(name: "MonacoBSemi", size: 50.0)
         containerView.addSubview(heartImage)
         containerView.addSubview(favLabel)
         containerView.addSubview(tapLabel)
         self.addSubview(containerView)
      
//        favLabel.snp.makeConstraints { (make) in
////            make.centerY.equalTo(UIScreen.main.bounds.height / 2.7)
////            make.bottom.equalTo(tapLabel.snp.top).offset(25.0)
////            make.centerX.equalTo(containerView.snp.centerX)
//        }
        heartImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(favLabel.snp.top).offset(340.0)
            
//            make.bottom.equalTo(favLabel.snp.top).offset(-120.0)
            make.centerX.equalTo(containerView.snp.centerX)
//            make.bottom.equalTo(favLabel.snp.top).offset(30.0)
        }
//        tapLabel.snp.makeConstraints { (make) in
//            make.bottom.equalTo(containerView.snp.bottom).offset(100.0)
//        }
        favLabel.tintColor = UIColor.white
        
    }
    
}
