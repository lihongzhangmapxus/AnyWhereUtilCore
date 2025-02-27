//
//  MemoryCache.swift
//  
//
//  Created by seongho.hong on 2021/10/03.
//

import Foundation
import UIKit

public final class MemoryCache<Value>: CacheStorage where Value: Codable {
        
    private lazy var memoryCache: NSCache<NSString, NSData> = {
        let imageCache = NSCache<NSString, NSData>()
        imageCache.countLimit = countLimit
        return imageCache
    }()
    
    private let countLimit: Int
    
    public init(countLimit: Int) {
        self.countLimit = countLimit
    }
        
    public func value(forKey key: String) throws -> Value? {
        try memoryCache
            .object(forKey: NSString(string: key))
            .flatMap { Data(referencing: $0) }
            .flatMap { try JSONDecoder().decode(Value.self, from: $0) }
    }
    
    public func save(_ value: Value, forKey key: String) throws {
        let data = try JSONEncoder().encode(value)
        memoryCache.setObject(NSData(data: data), forKey: NSString(string: key))
    }

}


class AnyMemoryCache: NSCache<NSString, UIImage>
{
    private let weakCache = NSMapTable<NSString, UIImage>(keyOptions: .weakMemory, valueOptions: .weakMemory)
    private var keys = Set<String>()
    private let lock = NSLock()
    public override init() {
        super.init()
        Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { [unowned self] (_) in
            self.removeExpired()
        }.fire()
    }
    
    func removeExpired() {
        lock.lock()
        defer { lock.unlock() }
        for key in keys {
            let expiredTime = Date.init(timeIntervalSinceNow: -300)
            if let objc = self.object(forKey: key as NSString) {
                if objc.time ?? Date.distantPast < expiredTime {
                    keys.remove(key)
                    self.removeObject(forKey: key as NSString)
                }
            } else {
                keys.remove(key)
            }
        }
    }
    
    subscript(key: String) -> UIImage? {
        set {
            lock.lock()
            defer { lock.unlock() }
            let nsKey = key as NSString
            if let newValue = newValue {
                newValue.time = Date()
                keys.insert(key)
                self.setObject(newValue, forKey: nsKey)
                self.weakCache.setObject(newValue, forKey: nsKey)
            } else {
                self.removeObject(forKey: nsKey)
                keys.remove(key)
                self.weakCache.removeObject(forKey: nsKey)
            }
        }
        get {
            lock.lock()
            defer { lock.unlock() }
            let nsKey = key as NSString
            var value = self.object(forKey: nsKey)
            if value == nil, !key.isEmpty {
                value = weakCache.object(forKey: nsKey)
            }
            if let value = value {
                setObject(value, forKey: nsKey)
                value.time = Date()
            }
            return value
        }
    }
    
    public override func removeAllObjects() {
        lock.lock()
        defer { lock.unlock() }
        super.removeAllObjects()
        self.weakCache.removeAllObjects()
        keys.removeAll()
    }
    
    public func removeStongReferecen() {
        super.removeAllObjects()
        keys.removeAll()
    }
}
