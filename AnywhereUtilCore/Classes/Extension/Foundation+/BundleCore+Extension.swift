//
//  BundleCore+Extension.swift
//  AnywhereUtilCore
//
//  Created by Mapxus on 2025/1/17.
//

import Foundation

class BundleCore  {
    static let anywhereUtilBundle: Bundle = {
        return Bundle(for: BundleCore.self)
    }()
    
    // https://juejin.cn/post/6911570896691920910
    static var utilBundle: Bundle? {
        get{
            let modularName = "AnywhereUtilCore"
            guard let bundleURL = Bundle(for: BundleCore.self).url(forResource: modularName, withExtension: "bundle") else {
                return nil
            }
            guard let bundle = Bundle(url: bundleURL) else {
                return nil
            }
            return bundle
        }
        
    }
}
