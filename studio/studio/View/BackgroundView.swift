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
    @IBOutlet var heartImage: UIImageView!
    @IBOutlet var tapLabel: UILabel!
    @IBOutlet var favLabel: UILabel!
    
    override func awakeFromNib() {
//        Bundle.main.loadNibNamed("BackgroundView", owner: self, options: nil)
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupLabels()
    }
    
    func setupLabels() {
        tapLabel = UILabel()
        favLabel = UILabel()
        heartImage = UIImageView()
        heartImage.backgroundColor = UIColor.init(hexString: "96A8C8")
        heartImage.image = UIImage(named: "❤️")
        self.addSubview(heartImage)
        self.addSubview(tapLabel)
        self.addSubview(favLabel)
        heartImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.frame.midX)
            make.centerY.equalTo(self.frame.midY)
        }
        favLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(heartImage.snp.centerX)
            make.top.equalTo(heartImage.snp.top)
        }
        tapLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(favLabel.snp.centerX)
            make.top.equalTo(favLabel.snp.top)
            make.centerY.equalTo(self.frame.midY)
        }
    }
    
}
