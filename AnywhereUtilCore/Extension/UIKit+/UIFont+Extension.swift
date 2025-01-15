//
//  UIFont+Extension.swift
//  DropInUISDK
//
//  Created by Mapxus on 2024/7/5.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit

public enum RegisterFontError: Error {
    case invalidFontFile
    case fontPathNotFound
    case initFontError
    case registerFailed(String) // 允许附加错误信息
}

public extension UIFont {
    /// 动态注册字体
    /// - Parameters:
    ///   - path: 字体文件路径
    ///   - newFontName: （可选）重命名字体
    /// - Returns: 注册成功时返回字体名称，失败返回错误
    static func registerFonts(_ path: String, newFontName: String? = nil) -> Result<String, RegisterFontError> {
        // 检查字体文件是否存在
        guard let fontData = NSData(contentsOfFile: path) else {
            return .failure(.fontPathNotFound)
        }

        // 创建字体数据提供者
        guard let fontDataProvider = CGDataProvider(data: fontData) else {
            return .failure(.invalidFontFile)
        }

        // 创建字体引用
        guard let fontRef = CGFont(fontDataProvider) else {
            return .failure(.initFontError)
        }

        // 获取字体原始名称
        let originalFontName = fontRef.fullName as String? ?? "UnknownFont"
        let targetFontName = newFontName ?? originalFontName

        // 确保先卸载可能已存在的同名字体
        CTFontManagerUnregisterGraphicsFont(fontRef, nil)

        // 注册字体
        var fontError: Unmanaged<CFError>?
        if CTFontManagerRegisterGraphicsFont(fontRef, &fontError) {
            return .success(targetFontName)
        } else {
            let errorMessage = fontError?.takeUnretainedValue().localizedDescription ?? "Unknown error"
            return .failure(.registerFailed(errorMessage))
        }
    }
}

public extension UIFont
{
    /// 获取常规自定义字体
    static func regular(_ size: CGFloat) -> UIFont {
        guard let name = SkinManager.shared.regularName else {
            return .systemFont(ofSize: size)
        }
        return loadFont(size, name: name, path: SkinManager.shared.regularPath)
    }

    /// 获取加粗自定义字体
    static func bold(_ size: CGFloat) -> UIFont {
        guard let name = SkinManager.shared.boldName else {
            return .boldSystemFont(ofSize: size)
        }
        return loadFont(size, name: name, path: SkinManager.shared.boldPath)
    }

    private static func loadFont(_ size: CGFloat, name: String, path: String?) -> UIFont
    {
        if let customFont = UIFont(name: name, size: size) {
            return customFont
        } else if let path = path {
            // 如果自定义字体未注册，尝试注册字体文件
            let result = UIFont.registerFonts(path)
            switch result {
            case .success(let fontName):
                if let customFont = UIFont(name: fontName, size: size) {
                    return customFont
                }
            case .failure(let error):
                print("*** Failed to register font: \(error)")
            }
        }
        return UIFont.systemFont(ofSize: size)
    }
}
