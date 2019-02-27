//
//  UIBarButtonItem.swift
//  studio
//
//  Created by Samuel Goldsmith on 2/27/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    func addBadge(number: Int, offset: CGPoint = CGPoint.zero, color: UIColor) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(7)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: CGPoint(x: UIScreen.main.bounds.maxX - 5.0, y: UIScreen.main.bounds.minY - 10.0), radius: radius, color: color)
        
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        let number = 99
        
        label.string = "\(number)"
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y), size: CGSize(width: 8, height: 16))
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
    }
    
}
