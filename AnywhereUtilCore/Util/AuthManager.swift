//
//  AuthManager.swift
//  Shoplus
//
//  Created by Mapxus on 2025/1/10.
//

import Foundation
import MapxusBaseSDK

// MARK: - TokenManager
class TokenManager: NSObject {
    var tokenStr: String? {
        get {
            return Keychain.password(forAccount: "MXMToken")
        }
        set {
            guard let tmp = newValue else {
                Keychain.deletePassword(forAccount: "MXMToken")
                return
            }
            let success = Keychain.setPassword(tmp, forAccount: "MXMToken")
            if !success {
                print("Failed to store token in Keychain.")
            }
        }
    }

    /// 检查 token 是否过期
    func isExpired(token: String?) -> Bool {
        guard let token = token, !token.isEmpty else { return true }

        let components = token.components(separatedBy: ".")
        guard components.count > 2 else { return true }

        var claims = components[1]
        // 补齐 Base64 编码
        let paddedLength = claims.count + (4 - (claims.count % 4)) % 4
        claims = claims.padding(toLength: paddedLength, withPad: "=", startingAt: 0)

        guard let claimsData = Data(base64Encoded: claims) else { return true }

        do {
            let json = try JSONSerialization.jsonObject(with: claimsData, options: [])
            if let jsonDict = json as? [String: Any], let exp = jsonDict["exp"] as? NSNumber {
                let now = Date().timeIntervalSince1970
                return exp.doubleValue - now <= 5 * 60 // 过期时间小于 5 分钟视为无效
            }
        } catch {
            print("Failed to parse token claims: \(error)")
        }

        return true
    }

    func isValid() -> Bool {
        return !isExpired(token: tokenStr)
    }
}

// MARK: - AuthManager
public class AuthManager: NSObject {
    static let shared = AuthManager()
    
    private var apiKey: String?         //ShoplusContext.shared.apiKey
    private var apiSecret: String?      //ShoplusContext.shared.apiSecret

    private let queue = DispatchQueue(label: "com.mapxus.authManager")
    private let completionQueue = DispatchQueue(label: "com.mapxus.authManager.completion", attributes: .concurrent)
    private var messages = [((String?) -> Void)]()
    private let tokenManager = TokenManager()
    private let mapServiceHandler = MapServiceHandler()

    public static func setup(apiKey: String?, apiSecret: String?) {
        if let key = apiKey {
            shared.apiKey = key
        }
        if let secret = apiSecret {
            shared.apiSecret = secret
        }
    }
    
    /// 处理消息队列
    private func processMessages(withToken token: String?) {
        queue.async { [weak self] in
            guard let self = self else { return }

            while !self.messages.isEmpty {
                let message = self.messages.removeFirst()
                self.completionQueue.async {
                    message(token)
                }
            }
        }
    }

    /// 清理 Token
    func clearToken() {
        tokenManager.tokenStr = nil
    }

    /// 获取 Token
    func getToken(completion: @escaping (String?) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.messages.append(completion)

            if self.tokenManager.isValid() {
                self.processMessages(withToken: self.tokenManager.tokenStr)
            } else {
                self.refreshToken()
            }
        }
    }

    /// 刷新 Token
    private func refreshToken() {
        guard let apiKey = apiKey,
              let secret = apiSecret else {
            print("API Key or Secret is missing.")
            processMessages(withToken: nil)
            return
        }

        mapServiceHandler.register(apiKey: apiKey, secret: secret) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                print("Failed to refresh token: \(error)")
            }
            self.processMessages(withToken: self.tokenManager.tokenStr)
        }
    }
}

// MARK: - MapServiceHandler
class MapServiceHandler: NSObject, MXMServiceDelegate {
    private var onFinish: ((Error?) -> Void)?

    func register(apiKey: String, secret: String, completion: ((Error?) -> Void)?) {
        onFinish = completion

        guard !apiKey.isEmpty, !secret.isEmpty else {
            let error = NSError(domain: "com.mapxus.error", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid API Key or Secret"])
            onFinish?(error)
            return
        }

        let mapServices = MXMMapServices.shared()
        mapServices.delegate = self
        mapServices.register(withApiKey: apiKey, secret: secret)
    }

    func registerMXMServiceSuccess() {
        onFinish?(nil)
    }

    func registerMXMServiceFailWithError(_ error: Error) {
        onFinish?(error)
    }
}
