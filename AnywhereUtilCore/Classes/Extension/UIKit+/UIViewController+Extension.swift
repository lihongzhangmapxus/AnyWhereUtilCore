//
//  UIViewController+Extension.swift
//  AnywhereUtilCore
//
//  Created by Mapxus on 2025/1/15.
//

import Foundation

public extension UIViewController {
    static func windowRootViewController() -> UIViewController? {
        var windowController: UIViewController?
        if #available(iOS 15.0, *) {
            let window = UIApplication.shared.windows.first
            windowController = window?.rootViewController
        } else {
            let window = UIApplication.shared.keyWindow
            windowController = window?.rootViewController
        }
        return windowController
    }
    
    /// 显示带跳转设置的提示框（可自定义跳转URL）
//    static func gotoAuthorization(settingsURL: URL = URL(string: UIApplicationOpenSettingsURLString)!) {
//        if UIApplication.shared.canOpenURL(settingsURL) {
//            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//        }
//    }
}
