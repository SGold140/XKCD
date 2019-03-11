//
//  Int.swift
//  studio
//
//  Created by Samuel Goldsmith on 3/8/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import Foundation

extension Int {
    
    func getSuffix() -> String {
        switch self {
            case 1,21,31: return "st"
            case 2,22: return "nd"
            case 3,23: return "rd"
            case 4...20, 24...30: return "th"
            default: return ""
        }
    }
    func toString() -> String {
        return String(self)
    }
    
}
