//
//  AuthManager.swift
//  Shoplus
//
//  Created by Mapxus on 2025/1/10.
//

import Foundation

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
    
    private let queue = DispatchQueue(label: "com.mapxus.authManager")
    private let completionQueue = DispatchQueue(label: "com.mapxus.authManager.completion", attributes: .concurrent)
    private var messages = [((String?) -> Void)]()
    private let tokenManager = TokenManager()

    //
    public var onRegisterFinish: (() -> Bool)?
    
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
        let onRegister = onRegisterFinish?()
        if onRegister == true {
            self.processMessages(withToken: self.tokenManager.tokenStr)
        } else {
            processMessages(withToken: nil)
        }
    }
}
