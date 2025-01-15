//
//  SkinManager.swift
//  SkinManager
//

import UIKit

/// 默认皮肤包名（default）
//private(set) var SKIN_DEFAULT_NAME: String = "default"
//
//private let DISkinCurrentSkinName: String = "DISkinCurrentSkinName"
//
//enum DISkinError: Error, LocalizedError {
//    case DISkinNameIsNull
//    case DISkinNameNotExists
//
//    var errorDescription: String? {
//        switch self {
//            case .DISkinNameIsNull:
//                return "皮肤包名为空"
//            case .DISkinNameNotExists:
//                return "皮肤包不存在"
//        }
//    }
//}
//
///// 换肤相关操作完成回调
//typealias SkinActionCompletion = (_ result: Bool, _ msg: String) -> Void
//
//class SkinManager: NSObject {
//    /// 获取默认皮肤包名
//    static func defaultSkinName() -> String {
//        return SkinManager.shared.defaultSkinName
//    }
//    private var defaultSkinName: String = SKIN_DEFAULT_NAME
//
//    /// 获取默认皮肤包信息
//    private(set) var defaultSkinInfo: NSDictionary = [:]
//
//    /// 获取当前皮肤包名
//    static func skinName() -> String {
//        return SkinManager.shared.skinName
//    }
//    private lazy var skinName: String = SKIN_DEFAULT_NAME
//
//    /// 获取当前皮肤包信息
//    static func skinInfo() -> NSDictionary? {
//        return SkinManager.shared.skinInfo
//    }
//    private var skinInfo: NSDictionary?
//
//    ///
//    var regularName: String?
//    var regularPath: String?
//
//    ///
//    var boldName: String?
//    var boldPath: String?
//
//
//    static let shared = SkinManager()
//
//    override init() {
//        super.init()
//        readSkinInfo()
//    }
//
//    private func readSkinInfo() {
//    }
//
//    static private func _dicFromSkinHistoryInfoWithKey(info: NSDictionary?, key: String) -> NSDictionary {
//        guard let tmp = info?.object(forKey: key) as? NSDictionary else {
//            return NSDictionary()
//        }
//        return tmp
//    }
//
//
//    /// 替换皮肤包配置信息
//    func replaceSkinPlistInfo(_ skinPlistInfo: NSDictionary, skinName: String, _ completion: SkinActionCompletion?) {
//        do {
//            try _replaceSkinPlistInfoData(skinPlistInfo: skinPlistInfo, skinName: skinName)
//            completion?(true, "")
//        } catch let error {
//            let msg = "error ：\(error.localizedDescription)，\n skin_plist：\(skinPlistInfo)"
//            completion?(false, msg)
//        }
//    }
//
//    private func _replaceSkinPlistInfoData(skinPlistInfo: NSDictionary, skinName: String) throws {
//        let tmp = SkinManager._dicFromSkinHistoryInfoWithKey(info: skinPlistInfo, key: skinName)
//        if !tmp.allKeys.isEmpty {
//            SkinManager.shared.defaultSkinInfo = tmp
//            SkinManager.shared.skinInfo = tmp
//        }
//    }
//}


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
    var regularName: String?
    var regularPath: String?

    ///
    var boldName: String?
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
