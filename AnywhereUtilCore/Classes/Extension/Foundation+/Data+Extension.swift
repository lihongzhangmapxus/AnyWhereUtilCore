//
//  Data+Extension.swift
//  Shoplus
//
//  Created by Mapxus on 2025/1/14.
//

import Foundation

public extension Data {
    var asDict: [String: Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
    }
}
