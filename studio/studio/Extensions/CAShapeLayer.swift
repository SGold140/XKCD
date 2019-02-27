//
//  CAShapeLayer.swift
//  studio
//
//  Created by Samuel Goldsmith on 2/27/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import Foundation
import UIKit

extension CAShapeLayer {
    
    func drawCircleAtLocation(location: CGPoint, radius: CGFloat, color: UIColor) {
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }

}
