//
//  Date.swift
//  studio
//
//  Created by Samuel Goldsmith on 3/6/19.
//  Copyright © 2019 Samuel Goldsmith. All rights reserved.
//

import Foundation

extension Date {
    
    func toMillis() -> Double! {
        return self.timeIntervalSince1970 * 1000
    }
    
    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }
    
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
