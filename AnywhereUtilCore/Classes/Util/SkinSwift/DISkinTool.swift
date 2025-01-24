//
//  DISkinTool.swift
//  SkinManager
//

import UIKit

//
/** 换肤配置文件 plist 中固定的key 值 */
private let DISkinColorTypeKey = "Normal"
private let SkinFontTypeKey = "Font"
private let DISkinFontNameKey = "Name"
private let DISkinFontSizeKey = "Size"
private let DISkinCornerKey = "Corner"

// MARK: - DISkinTool (工具类)
final class DISkinTool {
    private let key: String
    private let valueType: SkinValueType
    
    init(key: String, type: SkinValueType) {
        self.key = key
        self.valueType = type
    }
    
    func value(alpha: CGFloat = 1.0) -> Any? {
        switch valueType {
        case .color:
            return fetchColor(alpha: alpha)
        case .font(let fontType):
            return fetchFont(type: fontType)
        case .corner:
            return fetchCorner()
        case .unknown:
            assertionFailure("未知的皮肤元素")
            return nil
        }
    }
    
    private func fetchColor(alpha: CGFloat) -> UIColor? {
        let skinInfo = SkinManager.shared.currentSkinInfo
        let packValue = skinPackValue(skinInfo as NSDictionary, key: key, type: valueType, skinName: SkinManager.currentSkinName())
        guard let colorHex = packValue as? String, !colorHex.isEmpty else {
            return nil
        }
        let color = UIColor.hexColor(colorHex)
        return alpha < 1.0 ? color.withAlphaComponent(alpha) : color
    }
    
    private func fetchFont(type: SkinFontType) -> UIFont? {
        return skinFontForKey(
            key,
            SkinManager.shared.currentSkinInfo as NSDictionary,
            SkinManager.currentSkinName(),
            isBold: type == .bold
        )
    }
    
    private func fetchCorner() -> CGFloat {
        guard let cornerValue = skinPackValue(
            SkinManager.shared.currentSkinInfo as NSDictionary,
            key: key,
            type: .corner,
            skinName: SkinManager.currentSkinName()
        ) as? CGFloat else {
            return 0.0 // 默认圆角值
        }
        return cornerValue
    }
    
    private func defaultFont(for type: SkinFontType) -> UIFont {
        switch type {
        case .regular:
            return UIFont.systemFont(ofSize: 14)
        case .bold:
            return UIFont.boldSystemFont(ofSize: 14)
        }
    }
    
    func skinPackValue(_ info: NSDictionary?, key: String, type: SkinValueType, skinName: String) -> Any? {
        let valueTypeKey: String
        switch type {
        case .color:
            valueTypeKey = DISkinColorTypeKey
        case .corner:
            valueTypeKey = DISkinCornerKey
        default:
            return nil
        }
        guard let valueInfo = info?.value(forKey: valueTypeKey) as? NSDictionary else {
            return nil
        }
        return valueInfo.value(forKey: key)
    }
}

extension DISkinTool
{    
    private func skinFontForKey(_ key: String, _ skinInfo: NSDictionary?, _ skinName: String, isBold: Bool) -> UIFont? {
        guard let fontInfo = skinInfo?.value(forKey: SkinFontTypeKey) as? NSDictionary else {
            return defaultSystemFont(isBold)
        }
        // 获取字体名称
//        let customFontName = fontInfo.value(forKey: DISkinFontNameKey) as? String
        let fontSize = fontInfo.value(forKey: key) as? CGFloat ?? 14.0
        let resourceName = isBold ? SkinManager.shared.boldName : SkinManager.shared.regularName
        // 尝试加载自定义字体
        if let font = loadFontFrom(fontName: resourceName, fontSize: fontSize) {
            return font
        }
        var resourcePath = isBold ? SkinManager.shared.boldPath : SkinManager.shared.regularPath
        if resourcePath == nil {
            if isBold == true {
                resourcePath = BundleCore.utilBundle?.path(forResource: "Ubuntu-Bold", ofType: "ttf")
            } else {
                resourcePath = BundleCore.utilBundle?.path(forResource: "Ubuntu-Regular", ofType: "ttf")
            }
        }
        if let sdkFont = registerFontFrom(resourcePath, fontSize: fontSize) {
            return sdkFont
        }
        return defaultSystemFont(isBold, fontSize: fontSize)
    }

    private func loadFontFrom(fontName: String?, fontSize: CGFloat) -> UIFont? {
        if let fontName = fontName, let font = UIFont(name: fontName, size: fontSize) {
//            return UIFontMetrics.default.scaledFont(for: font, maximumPointSize: fontSize)
            return font
        }
        return nil
    }

    private func registerFontFrom(_ resourcePath: String?, fontSize: CGFloat) -> UIFont? {
        guard let path = resourcePath else { return nil }
        
        // 尝试注册 SDK 字体
        let result = UIFont.registerFonts(path)
        switch result {
        case .success(let fontName):
            if let customFont = UIFont(name: fontName, size: fontSize) {
                return customFont
            }
        case .failure(let error):
            print("Failed to register font: \(error)")
        }
        return nil
    }

    private func defaultSystemFont(_ isBold: Bool, fontSize: CGFloat = 14) -> UIFont {
        return isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
    }
}


// MARK: - 快速获取皮肤值
public func ThemeColor(_ key: String, alpha: CGFloat = 1.0) -> UIColor? {
    return DISkinTool(key: key, type: .color).value(alpha: alpha) as? UIColor
}

public func ThemeFont(_ key: String, _ type: SkinFontType = .regular) -> UIFont? {
    return DISkinTool(key: key, type: .font(type)).value() as? UIFont
}

public func ThemeCorner(_ key: String) -> CGFloat {
    if let value = DISkinTool(key: key, type: .corner).value() as? CGFloat {
        return value
    }
    return 0.0
}
