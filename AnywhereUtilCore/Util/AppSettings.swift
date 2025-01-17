//
//  AppSettings.swift
//  AnywhereUtilCore
//
//  Created by Mapxus on 2025/1/14.
//

import Foundation

public class AppSettings {

    /// 当前用户的首选语言
    public var preferredLanguage: Language

    // 当前用户的主题
    public var currentTheme: ThemeStruct = ThemeStruct()
    
    /// 初始化
    public init() {
        // 加载存储的语言，或者使用系统默认语言
        self.preferredLanguage = Self.resolveInitialLanguage()
    }

    /// 更新用户的首选语言
    public func updatePreferredLanguage(to newLanguage: Language) {
        // 如果是 .system，则根据系统首选语言动态解析
        self.preferredLanguage = LanguageFormat.resolveLanguage(from: newLanguage)
        savePreferredLanguage(to: self.preferredLanguage)
    }

    /// 加载初始语言
    private static func resolveInitialLanguage() -> Language {
        // 尝试从持久化存储加载
        if let storedCode = loadStoredLanguage(),
           let resolvedLanguage = LanguageFormat.languageMapping[storedCode] {
            return resolvedLanguage
        }
        // 使用系统语言作为默认
        return LanguageFormat.preferredLanguage()
    }

    /// 保存语言到 UserDefaults
    private func savePreferredLanguage(to language: Language) {
        UserDefaults.standard.set(language.code, forKey: "PreferredLanguage")
    }

    /// 从持久化存储中加载语言代码
    private static func loadStoredLanguage() -> String? {
        return nil
//        return UserDefaults.standard.string(forKey: "PreferredLanguage")
    }
    
    // reset Theme
    public func resetTheme() {
        currentTheme = ThemeStruct()
    }
}
