//
//  LanguageFormat.swift
//  Shoplus
//
//  Created by Mapxus on 2025/1/13.
//

import Foundation

public struct LanguageFormat
{
    /// 语言映射表，用于从语言字符串映射到 `Language` 枚举
    static let languageMapping: [String: Language] = [
        "Hans": .zh_Hans,
        "zh-Hans": .zh_Hans,
        "Hant": .zh_HK,
        "zh-HK": .zh_HK,
        "ja": .ja
    ]
    
    /// 根据输入的 Language 或 Locale.preferredLanguages 返回具体的 Language
    public static func resolveLanguage(from inputLanguage: Language?) -> Language {
        guard let selectedLanguage = inputLanguage else {
            return preferredLanguage()
        }
        return selectedLanguage == .system ? preferredLanguage() : selectedLanguage
    }
    
    /// 获取首选语言（基于 Locale.preferredLanguages 或默认语言）
    public static func preferredLanguage(with defaultLanguage: String? = nil) -> Language {
        let preferredLang = defaultLanguage ?? Locale.preferredLanguages.first ?? "en"
        
        // 遍历映射表找到对应的语言
        for (key, language) in languageMapping {
            if preferredLang.contains(key) {
                return language
            }
        }
        
        // 默认返回英文
        return .en
    }
}
