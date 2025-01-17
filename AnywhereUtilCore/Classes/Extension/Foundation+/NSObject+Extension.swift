//
//  NSObject+Extension.swift
//  AnywhereUtilCore
//
//  Created by Mapxus on 2025/1/17.
//

import Foundation

public extension NSObject {
    /// 获取关联对象
    func getAssociatedObject<T>(_ key: UnsafeRawPointer, defaultValue: T) -> T {
        return objc_getAssociatedObject(self, key) as? T ?? defaultValue
    }
    
    /// 设置关联对象
    func setAssociatedObject<T>(_ key: UnsafeRawPointer, value: T, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, key, value, policy)
    }
}
