//
//  String+Extesion.swift
//  DropInUISDK
//
//  Created by mapxus on 2023/6/7.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit
import Foundation

public extension String {
    
    // 需要你在主项目添加一个 extension，来处理bundle
    // Bundle 需要自己处理
    func localized(with args: [CVarArg]? = nil, in bundle: Bundle? = Bundle.main) -> String {
        SDKLocalizedString(self, bundle: bundle, comment: "", args: args)
    }
    
    private func SDKLocalizedString(_ key: String,
                                    tableName: String? = nil,
                                    bundle: Bundle?,
                                    value: String = "",
                                    comment: String,
                                    args: [CVarArg]? = nil) -> String {
        // 获取本地化字符串
        let localizedString = bundle?.localizedString(
            forKey: key,
            value: value,
            table: tableName
        )

        // 如果提供了参数，则格式化字符串
        if let args = args, !args.isEmpty {
            return String(format: localizedString ?? "", arguments: args)
        } else {
            return localizedString ?? ""
        }
    }
}
