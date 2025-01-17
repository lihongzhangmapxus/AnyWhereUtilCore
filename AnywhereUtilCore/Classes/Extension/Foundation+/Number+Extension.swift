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


public extension CGFloat {
    func toString(decimalPlaces: Int? = nil, roundingMode: NumberFormatter.RoundingMode = .halfUp) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = roundingMode
        if let decimalPlaces = decimalPlaces {
            numberFormatter.minimumFractionDigits = decimalPlaces
            numberFormatter.maximumFractionDigits = decimalPlaces
        }
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
