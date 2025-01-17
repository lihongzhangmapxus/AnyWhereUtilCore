//
//  UILabel+Theme.swift
//  vip
//
//  Created by mapxus on 2022/7/5.
//

import UIKit

public extension UILabel {
    private struct nameStruct {
        static var theme_textColorKey: Void?
    }

    var theme_textColor: Theme.Color? {
        set {
            guard let value = newValue?.rawValue else { return }
            if let color = ThemeColor(value) {
                register(value, methodKey: "setTextColor:", dataKey: &nameStruct.theme_textColorKey)
                performThemePicker(selector: "setTextColor:", value: color)
            }
        }
        get {
            guard let rawValue = theme_valueFor(&nameStruct.theme_textColorKey) else { return nil }
            return Theme.Color(rawValue: rawValue)
        }
    }
}
