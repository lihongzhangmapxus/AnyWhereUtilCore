//
//  Language.swift
//  AnywhereUtilCore
//
//  Created by Mapxus on 2025/1/14.
//

import Foundation

@objc public enum Language: Int {
    case zh_HK
    case zh_Hans
    case en
    case ja
    case system

    public var code: String {
        switch self {
        case .zh_HK: return Constants.zhHant
        case .zh_Hans: return Constants.zhHans
        case .en: return Constants.en
        case .ja: return Constants.ja
        case .system: return Constants.system
        }
    }

    struct Constants {
        static let zhHant = "zh-Hant"
        static let zhHans = "zh-Hans"
        static let en = "en"
        static let ja = "ja"
        static let system = "system"
    }

    /// 外部传入的资源 Bundle
    private static var resourceBundleProvider: (() -> Bundle?)?

    /// 配置资源 Bundle 提供者
    public static func configureResourceBundleProvider(_ provider: @escaping () -> Bundle?) {
        resourceBundleProvider = provider
    }

    /// 获取对应语言的资源 Bundle
    public func bundle() -> Bundle? {
        guard let resourceBundle = Self.resourceBundleProvider?() else {
            return nil
        }

        if code == Constants.system {
            return preferredSystemBundle(in: resourceBundle)
        }

        return loadBundle(for: code, in: resourceBundle)
    }

    /// 加载指定语言的 Bundle
    private func loadBundle(for code: String, in resourceBundle: Bundle) -> Bundle? {
        guard let path = resourceBundle.path(forResource: code, ofType: "lproj"),
              let languageBundle = Bundle(path: path) else { return nil }
        return languageBundle
    }

    /// 获取系统首选语言的 Bundle
    private func preferredSystemBundle(in resourceBundle: Bundle) -> Bundle? {
        guard let preferredLanguage = Locale.preferredLanguages.first else { return nil }
        let resolvedCode = LanguageFormat.preferredLanguage(with: preferredLanguage).code
        return loadBundle(for: resolvedCode, in: resourceBundle)
    }
    
    /// 获取 `.system` 模式下首选语言的枚举值
    public func preferredLanguage() -> Language {
        if self == .system, let preferredLanguageCode = Locale.preferredLanguages.first {
            switch preferredLanguageCode {
            case Constants.zhHant: return .zh_HK
            case Constants.zhHans: return .zh_Hans
            case Constants.en: return .en
            case Constants.ja: return .ja
            default: return .en // 默认值
            }
        }
        return self
    }
    
    /// 根据字符串返回对应的 Language 枚举
    public static func from(string: String) -> Language {
        switch string.lowercased() {
        case Constants.zhHant.lowercased(), "hant", "zh_hk": return .zh_HK
        case Constants.zhHans.lowercased(), "hans", "zh_cn": return .zh_Hans
        case Constants.en.lowercased(), "english", "us", "uk": return .en
        case Constants.ja.lowercased(), "japanese", "jp": return .ja
        default: return .system // 默认返回 system
        }
    }
}