//
//  ScreenUtils.swift
//  Shoplus
//
//  Created by Mapxus on 2025/1/13.
//

import UIKit

public class ScreenUtils {
    /// 获取状态栏高度
    public class var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let keyWindow = windowScene.windows.first { $0.isKeyWindow }
                return keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            }
            return 0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }

    /// 屏幕宽度
    public class var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    /// 屏幕高度
    public class var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }

    /// iPhone X 系列顶部安全区域高度
    public class var safeAreaTop: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let keyWindow = windowScene.windows.first { $0.isKeyWindow }
            return keyWindow?.safeAreaInsets.top ?? 0
        }
        return 0
    }

    /// iPhone X 系列底部安全区域高度
    public class var safeAreaBottom: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let keyWindow = windowScene.windows.first { $0.isKeyWindow }
            return keyWindow?.safeAreaInsets.bottom ?? 0
        }
        return 0
    }
}
