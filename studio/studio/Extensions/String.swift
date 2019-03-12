//
//  String.swift
//  studio
//
//  Created by Samuel Goldsmith on 3/11/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        let font = UIFont.init(name: "MonacoBSemi", size: 25.0)
        (self as AnyObject).draw(in: rect, withAttributes: [.font: font!])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
