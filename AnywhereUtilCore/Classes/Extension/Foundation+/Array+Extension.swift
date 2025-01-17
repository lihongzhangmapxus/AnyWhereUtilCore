//
//  Array+Extension.swift
//  DropInUISDK
//
//  Created by Mapxus on 2023/11/9.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation

enum DataError: Error {
    case indexOutOfBounds
}

public extension Array {
    // array[safe: index]
    subscript(safe index: Int) -> Element? {
//        assert(self.count >= 0 && index < self.count, "Index out of bounds")
        return indices.contains(index) ? self[index] : nil
    }

    func getElement(safe index: Int) throws -> Element {
        guard self.isEmpty && index < self.count else {
            throw DataError.indexOutOfBounds
        }
        return self[index]
    }

    /// 获取随机数
    /// - Parameter numElements: 个数
    /// - Returns: 随机数组
    func randomElements(numElements: Int) -> [Element] {
        var elements = [Element]()
        var selectedIndices = Set<Int>()
        let limit = Swift.min(numElements, self.count)
        while elements.count < limit {
            let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
            // 检查随机索引是否已被选中过
            if !selectedIndices.contains(randomIndex) {
                selectedIndices.insert(randomIndex)
                if let item = self[safe: randomIndex] {
                    elements.append(item)
                }
            }
        }
        return elements
    }
}

public extension Array where Element: Hashable {
    // 去重
    var unique: [Element] {
        return Array(Set(self))
    }
}

public extension Sequence {
    // 去除重复元素
    func unique<T: Hashable>(by keySelector: (Element) -> T) -> [Element] {
        var seen: Set<T> = []
        return filter { seen.insert(keySelector($0)).inserted }
    }
}

// 用于字典的合并，接收的参数是一个键值对时，就可以添加到原有的字典中，并且对原有字典的重复值进行覆盖为新值，不重复则保留
public extension Dictionary {
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value) {
            for (k, v) in other {
                self[k] = v
        }
    }
    
    init<S: Sequence>(uniquePairs: S) where S.Element == (key: Key, value: Value) {
        self.init()
        for (key, value) in uniquePairs {
            self[key] = value
        }
    }
}

// 字典去重
public protocol Duplicatable {
    func isDuplicate(with other: Self) -> Bool
}
