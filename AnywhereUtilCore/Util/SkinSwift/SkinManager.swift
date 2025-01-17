//
//  SkinManager.swift
//  SkinManager
//

import UIKit

// MARK: - 定义错误
enum SkinError: Error, LocalizedError {
    case skinNameIsNull
    case skinNameNotExists
    case fontLoadFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .skinNameIsNull:
            return "皮肤包名为空"
        case .skinNameNotExists:
            return "皮肤包不存在"
        case .fontLoadFailed(let fontName):
            return "字体加载失败：\(fontName)"
        }
    }
}

// MARK: - 类型定义
enum SkinValueType {
    case color
    case font(SkinFontType)
    case corner
    case unknown
}

public enum SkinFontType {
    case regular
    case bold
}

// MARK: - 换肤操作回调
typealias SkinActionCompletion = (Result<Void, SkinError>) -> Void

// MARK: - SkinManager (核心管理类)
final class SkinManager {
    static let shared = SkinManager()
    
    ///
    var regularName: String? = "Ubuntu" {
        didSet {
            if regularName == nil {
                regularName = "Ubuntu"
            }
        }
    }
    var regularPath: String?

    ///
    var boldName: String? = "Ubuntu-Bold" {
        didSet {
            if boldName == nil {
                boldName = "Ubuntu-Bold"
            }
        }
    }
    var boldPath: String?

    private(set) var defaultSkinName: String = "default"
    private(set) var currentSkinName: String = "default"
    private(set) var defaultSkinInfo: [String: Any] = [:]
    private(set) var currentSkinInfo: [String: Any] = [:]
    
    private init() {}
    
    // MARK: 获取默认皮肤名
    static func defaultSkinName() -> String {
        shared.defaultSkinName
    }
    
    // MARK: 获取当前皮肤名
    static func currentSkinName() -> String {
        shared.currentSkinName
    }
    
    // MARK: 替换皮肤信息
    func replaceSkinInfo(skinName: String, skinPlistInfo: [String: Any], completion: SkinActionCompletion? = nil) {
        guard !skinName.isEmpty else {
            completion?(.failure(.skinNameIsNull))
            return
        }
        
        // 检查皮肤信息是否存在
        guard let newSkinInfo = skinPlistInfo[skinName] as? [String: Any] else {
            completion?(.failure(.skinNameNotExists))
            return
        }
        
        // 更新皮肤信息
        self.currentSkinName = skinName
        self.currentSkinInfo = newSkinInfo
        self.defaultSkinInfo = skinPlistInfo["default"] as? [String: Any] ?? [:]
        
        completion?(.success(()))
    }
}
