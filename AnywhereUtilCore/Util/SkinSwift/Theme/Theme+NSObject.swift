//
//  Theme+NSObject.swift
//  vip
//
//  Created by mapxus on 2022/7/5.
//

import Foundation
import UIKit

var themePickerKey: Void?

public extension NSObject {
    private struct nameStruct {
        static var kThemeDeinitBlocks: Void?
        static var addPickerNotificationKey: Void?
    }

    // 属性字典
    var pickers: [String: Any] {
        if let pickers = objc_getAssociatedObject(self, &themePickerKey) as? [String: Any] {
            return pickers
        } else {
            let pickers = [String: Any]()

            if objc_getAssociatedObject(self, &nameStruct.kThemeDeinitBlocks) == nil {
                let deinitHelper = self.addThemeDeinitBlock { [weak self] in
                    // 释放对象通知
                    NotificationCenter.default.removeObserver(self as Any, name: NSNotification.Name(rawValue: "themeDidChange"), object: nil)
                }
                objc_setAssociatedObject(self, &nameStruct.kThemeDeinitBlocks, deinitHelper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }

            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "themeDidChange"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: NSNotification.Name(rawValue: "themeDidChange"), object: nil)

            objc_setAssociatedObject(self, &themePickerKey, pickers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return pickers
        }
    }

    // 注册属性变化
    func register(_ value: String, methodKey: String, dataKey: UnsafeRawPointer) {
        objc_setAssociatedObject(self, dataKey, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)

        var pik = pickers
        pik.updateValue(value, forKey: methodKey)
        objc_setAssociatedObject(self, &themePickerKey, pik, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func theme_valueFor(_ dataKey: UnsafeRawPointer) -> String? {
        return objc_getAssociatedObject(self, dataKey) as? String
    }

    var hasAddPickerNotification: Bool {
        get {
            return objc_getAssociatedObject(self, &nameStruct.addPickerNotificationKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &nameStruct.addPickerNotificationKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    @objc func updateTheme() {
        pickers.forEach { (key: String, value: Any) in
            UIView.animate(withDuration: 0.3) { [self] in
                if let tmp = value as? String, let color = ThemeColor(tmp) {
                    performThemePicker(selector: key, value: color)
                }
            }
        }
    }

    func performThemePicker(selector: String, value: Any) {
        let sel = Selector(selector)
        perform(sel, with: value)
    }
}

extension NSObject {
    // 记录需要释放的通知主体
    func addThemeDeinitBlock(_ deinitBlock: (() -> Void)?) -> Any? {
        guard let deinitBlock = deinitBlock else { return nil }
        let deinitBlockExecutor = ThemeDeinitBlockExecutor.executorWithDeinitBlock(deinitBlock)
        return deinitBlockExecutor
    }
}

class ThemeDeinitBlockExecutor: NSObject {
    var deinitBlock: (() -> Void)?
    // 接收更换主题模式的通知block
    class func executorWithDeinitBlock(_ deinitBlock: (() -> Void)?) -> ThemeDeinitBlockExecutor {
        let deinitBlockExecutor = ThemeDeinitBlockExecutor()
        deinitBlockExecutor.deinitBlock = deinitBlock
        return deinitBlockExecutor
    }
    // 执行析构方法，释放注册的通知
    deinit {
        if deinitBlock != nil {
            deinitBlock!()
            deinitBlock = nil
        }
    }
}
