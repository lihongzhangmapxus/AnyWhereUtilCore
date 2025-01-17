//
//  UIView+Theme.swift
//  vip
//
//  Created by mapxus on 2022/7/5.
//

import UIKit

private struct nameStruct {
    static var theme_backgroundColorKey: Void?
    static var theme_ButtonTitleKey: Void?
    static var theme_ButtonBackColorKey: Void?
}

public extension UIView {
    var theme_backgroundColor: Theme.Color? {
        set {
            guard let value = newValue?.rawValue else { return }
            if let color = ThemeColor(value) {
                register(value, methodKey: "setBackgroundColor:", dataKey: &nameStruct.theme_backgroundColorKey)
                performThemePicker(selector: "setBackgroundColor:", value: color)
            }
        }
        get {
            guard let rawValue = theme_valueFor(&nameStruct.theme_backgroundColorKey) else { return nil }
            return Theme.Color(rawValue: rawValue)
        }
    }
}

public extension UIButton {
    func theme_setTitleColor(_ color: Theme.Color?, for state: UIControl.State) {
        guard let value = color?.rawValue else { return }
        if let color = ThemeColor(value) {
            setTitleColor(color, for: state)
            var pik = pickers
            var dict: [String: Any] = (pik[String("\(state.rawValue)")] as? [String: Any]) ?? [String: Any]()
            dict.updateValue(value, forKey: "setTitleColor:forState:")
            pik.updateValue(dict, forKey: String("\(state.rawValue)"))

            objc_setAssociatedObject(self, &themePickerKey, pik, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func theme_setBackgroundColor(_ color: Theme.Color?, for state: UIControl.State) {
        guard let value = color?.rawValue else { return }
        if let color = ThemeColor(value) {
            setBackgroundImage(imageFromColor(color: color), for: state)
            layer.masksToBounds = true
            var pik = pickers
            var dict: [String: Any] = (pik[String("\(state.rawValue)")] as? [String: Any]) ?? [String: Any]()
            dict.updateValue(value, forKey: "setBackgroundImage:forState:")
            pik.updateValue(dict, forKey: String("\(state.rawValue)"))

            objc_setAssociatedObject(self, &themePickerKey, pik, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UIButton {
    // 重写主题更新方法
    @objc override func updateTheme() {
        self.pickers.forEach { key, value in
            if let dict = value as? [String: Any] {
                dict.forEach {stateKey, selectorValue in
                    let state = UIControl.State(rawValue: UIControl.State.RawValue(key)!)
                    guard let string = selectorValue as? String, let color = ThemeColor(string) else {
                        return
                    }
                    UIView.animate(withDuration: 0.3) { [self] in
                        if stateKey == "setTitleColor:forState:" {
                            setTitleColor(color, for: state)
                        } else if stateKey == "setBackgroundImage:forState:" {
                            setBackgroundImage(imageFromColor(color: color), for: state)
                        }
                    }
                }
            } else {
                if let valueStr = value as? String, let color = ThemeColor(valueStr) {
                    performThemePicker(selector: key, value: color)
                }
            }
        }
    }

    func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
    }
}
