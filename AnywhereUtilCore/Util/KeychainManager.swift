//
//  KeychainManager.swift
//  Shoplus
//
//  Created by Mapxus on 2025/1/10.
//

import Foundation
import Security

struct Keychain {
    /// This is used to identify your service
    static let bundleIdentifier: String = {
        return Bundle.main.bundleIdentifier ?? ""
    }()
    
    /// Keychain-related constants
    struct KeychainConstants {
        static let account = kSecAttrAccount as String
        static let service = kSecAttrService as String
        static let accessGroup = kSecAttrAccessGroup as String
        static let classGenericPassword = kSecClassGenericPassword as String
        static let returnData = kSecReturnData as String
        static let matchLimit = kSecMatchLimit as String
        static let valueData = kSecValueData as String
        static let accessible = kSecAttrAccessible as String
    }
    
    /// Actions that can be performed with Keychain
    enum Action {
        case insert
        case fetch
        case delete
    }
    
    /// A private queue for thread-safe operations
    private static let queue = DispatchQueue(label: "com.mapxus.keychain")
    
    // MARK: - Public Methods

    /// Query password using account in a Keychain service
    static func password(forAccount account: String,
                         service: String = bundleIdentifier,
                         accessGroup: String = "") -> String? {
        return queue.sync {
            guard !service.isEmpty && !account.isEmpty else { return nil }
            
            var query: [String: Any] = [
                KeychainConstants.account: account,
                KeychainConstants.classGenericPassword: kSecClassGenericPassword,
                KeychainConstants.returnData: kCFBooleanTrue as Any,
                KeychainConstants.matchLimit: kSecMatchLimitOne
            ]
            
            if !accessGroup.isEmpty {
                query[KeychainConstants.accessGroup] = accessGroup
            }
            
            return handleFetch(query: &query).1
        }
    }
    
    /// Set the password for the account in a Keychain service
    @discardableResult
    static func setPassword(_ password: String,
                            forAccount account: String,
                            service: String = bundleIdentifier,
                            accessGroup: String = "",
                            accessibility: CFString = kSecAttrAccessibleWhenUnlocked) -> Bool {
        return queue.sync {
            guard !service.isEmpty && !account.isEmpty else { return false }
            
            var query: [String: Any] = [
                KeychainConstants.account: account,
                KeychainConstants.classGenericPassword: kSecClassGenericPassword,
                KeychainConstants.accessible: accessibility
            ]
            
            if !accessGroup.isEmpty {
                query[KeychainConstants.accessGroup] = accessGroup
            }
            
            let passwordData = password.data(using: .utf8)
            return handleInsert(query: &query, passwordData: passwordData) == errSecSuccess
        }
    }
    
    /// Delete password for the account in a Keychain service
    @discardableResult
    static func deletePassword(forAccount account: String,
                               service: String = bundleIdentifier,
                               accessGroup: String = "") -> Bool {
        return queue.sync {
            guard !service.isEmpty && !account.isEmpty else { return false }
            
            var query: [String: Any] = [
                KeychainConstants.account: account,
                KeychainConstants.classGenericPassword: kSecClassGenericPassword
            ]
            
            if !accessGroup.isEmpty {
                query[KeychainConstants.accessGroup] = accessGroup
            }
            
            return handleDelete(query: query) == errSecSuccess
        }
    }

    // MARK: - Private Methods

    /// Handle inserting a password into Keychain
    private static func handleInsert(query: inout [String: Any], passwordData: Data?) -> OSStatus {
        var attributes: [String: AnyObject] = [:]
        var status = SecItemCopyMatching(query as CFDictionary, nil)

        switch status {
        case errSecSuccess:
            attributes[KeychainConstants.valueData] = passwordData as AnyObject?
            status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        case errSecItemNotFound:
            query[KeychainConstants.valueData] = passwordData as AnyObject?
            status = SecItemAdd(query as CFDictionary, nil)
        default:
            break
        }
        return status
    }

    /// Handle fetching a password from Keychain
    private static func handleFetch(query: inout [String: Any]) -> (OSStatus, String) {
        query[KeychainConstants.returnData] = true as Any
        query[KeychainConstants.matchLimit] = kSecMatchLimitOne
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if let result = result as? Data,
           let password = String(data: result, encoding: .utf8) {
            return (status, password)
        }
        return (status, "")
    }

    /// Handle deleting a password from Keychain
    private static func handleDelete(query: [String: Any]) -> OSStatus {
        return SecItemDelete(query as CFDictionary)
    }

    /// Get error message for Keychain status
    static func errorMessage(for status: OSStatus) -> String {
        if let message = SecCopyErrorMessageString(status, nil) {
            return String(message)
        }
        return "Unknown error (\(status))"
    }
}

