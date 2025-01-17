//
//  Number+Extension.swift
//  DropInUISDK
//
//  Created by Mapxus on 2024/7/19.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation

public extension UInt {
    func toDouble() -> Double {
        Double(self)
    }
    func toInt() -> Int {
        Int(self)
    }
}

public extension Int {
    func toDouble() -> Double {
        Double(self)
    }
}

public extension Double {
    func toInt() -> Int {
        Int(self)
    }
}
