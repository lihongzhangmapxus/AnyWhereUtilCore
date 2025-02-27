//
//  UITextField+Theme.swift
//  DropInUISDK
//
//  Created by mapxus on 2023/1/9.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit

private var textColorKey = "textColorKey"

public extension UITextField {
    private struct nameStruct {
        static var theme_textColorKey: Void?
        static var theme_attributedPlaceholderKey: Void?
    }

    var theme_textColor: Theme.Color? {
        set {
            guard let value = newValue?.stringValue else { return }
            if let color = ThemeColor(value) {
                register(value, methodKey: "setTextColor:", dataKey: &nameStruct.theme_textColorKey)
                performThemePicker(selector: "setTextColor:", value: color)
            }
        }
        get {
            return nil
//            guard let rawValue = theme_valueFor(&nameStruct.theme_textColorKey) else { return nil }
//            return Theme.Color(rawValue: rawValue)
        }
    }
}
