//
//  DiskCache.swift
//  
//
//  Created by seongho.hong on 2021/10/03.
//

import Foundation

public struct DiskCache<Value>: CacheStorage where Value: Codable {
    
    private let fileManager: DiskCacheFileManagable
    
    public init(fileManager: DiskCacheFileManagable = DefaultFileManager()) {
        self.fileManager = fileManager
    }
    
    public func value(forKey key: String) throws -> Value? {
        let filePathURL = try fileManager.filePathURL(forKey: key)
        guard let data = try? fileManager.data(of: filePathURL) else {
            return nil
        }
        
        let value = try JSONDecoder().decode(Value.self, from: data)
        return value
    }
    
    public func save(_ value: Value, forKey key: String) throws {
        let filePathURL = try fileManager.filePathURL(forKey: key)
        try fileManager.assureDirectoryExists(filePathURL: filePathURL)
        
        let data = try JSONEncoder().encode(value)
        try fileManager.write(data, to: filePathURL)
    }
    
    private func filePathURL(forKey key: String) throws -> URL {
        try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(key)
    }
    
}


class AnyDiskStroage
{
    var value: Data
    var key: String
    
    required public init(value: Data, key: String) {
        self.value = value
        self.key = key
    }
}

class AnyDiskCache
{
    let lock = NSLock()
    let config: AnyDiskConfig
    init(_ config: AnyDiskConfig) {
        self.config = config
        try? prepareDocuments()
    }
    
    func prepareDocuments() throws {
        let fileManager = config.manager
        let path = config.saveCachePath.path
        guard !fileManager.fileExists(atPath: path) else { return }
        do {
            try fileManager.createDirectory(at: config.saveCachePath,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        } catch {
            throw AnyError.diskError(.create(error, path))
        }
    }
    
    func checkExist(_ key: String) -> Bool {
        let path = config.saveCachePath.appendingPathComponent(key.md5)
        return config.manager.fileExists(atPath: path.path)
    }
    
    func store(_ data: AnyDiskStroage) throws {
        let key = data.key.md5
        let path = config.saveCachePath.appendingPathComponent(key)
        let date = Date()
        do {
            try data.value.write(to: path)
        } catch {
            throw AnyError.diskError(.store(error))
        }
        
        do {
            try config.manager.setAttributes([.creationDate : date,
                                              .modificationDate: config.maxDate.appendSince(date)],
                                             ofItemAtPath: path.path)
        } catch {
            throw AnyError.diskError(.storeSetAttributes(error))
        }
        
    }
    
    func value(_ key: String) throws -> AnyDiskStroage? {
        let path = config.saveCachePath.appendingPathComponent(key.md5)
        guard config.manager.fileExists(atPath: path.path) else {
            return nil
        }
        let fileMeta: URLResourceValues
        do {
            fileMeta = try path.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
        } catch {
            throw AnyError.diskError(.meta(error))
        }
        guard let modificationDate = fileMeta.contentModificationDate, modificationDate > Date() else {
            try? config.manager.removeItem(at: path)
            return nil
        }
        do {
            let data = try Data(contentsOf: path)
            config.diskQueue.async {
                let now = Date()
                try? self.config.manager.setAttributes(
                    [.modificationDate: self.config.maxDate.appendSince(now),
                     .creationDate: now],
                    ofItemAtPath: path.path)
            }
            return AnyDiskStroage(value: data, key: key)
        } catch {
            throw AnyError.diskError(.toData(error))
        }
    }
    
    func remove(_ key: String) throws {
        let path = config.saveCachePath.appendingPathComponent(key.md5)
        guard config.manager.fileExists(atPath: path.path) else {
            return
        }
        do {
            try config.manager.removeItem(at: path)
        } catch {
            throw AnyError.diskError(.remove(error))
        }
    }
    
    func removeExpiredOrLimit() throws {
        var paths = config.manager.enumerator(at: config.saveCachePath, includingPropertiesForKeys: [URLResourceKey.creationDateKey, URLResourceKey.contentModificationDateKey, .fileSizeKey])?.allObjects as? [URL]
        let date = Date()
        var waitSortPaths = [(URL, Date, Int)]()
        if config.maxSize != 0 { // maxSize noLimit
            guard let pathsValue = paths else { return }
            let totalSize: Int64 = pathsValue.reduce(0, { (size, path) in
                if let meta = try? path.resourceValues(forKeys: [.fileSizeKey, .creationDateKey]),
                   let fileSize = meta.fileSize, let createDate = meta.creationDate {
                    waitSortPaths.append((path, createDate, fileSize))
                    return size + Int64(fileSize)
                }
                return size
            })
            if config.maxSize < totalSize { // need remove // 排序然后反正来吧
                waitSortPaths.sort { $0.1 > $1.1 }
                var needRemove: Int = Int(totalSize - config.maxSize / 2)
                while needRemove > 0 {
                    if let value = waitSortPaths.popLast() {
                        do {
                            guard config.manager.fileExists(atPath: value.0.path) else { return }
                            needRemove -= value.2
                            try config.manager.removeItem(at: value.0)
                        } catch {
                            throw AnyError.diskError(.remove(error))
                        }
                    }
                }
                paths = waitSortPaths.map{ $0.0 }
            }
            waitSortPaths.removeAll()
        }
        let needRemove = paths?.filter({ (value) -> Bool in
            if let metaInfo = try? value.resourceValues(forKeys: [URLResourceKey.creationDateKey, URLResourceKey.contentModificationDateKey]) {
                if metaInfo.isDirectory ?? false {
                    return false
                }
                return (metaInfo.contentModificationDate ?? date) < date
            }
            return false
        })
        try needRemove?.forEach({ (url) in
            do {
                guard config.manager.fileExists(atPath: url.path) else { return }
                try config.manager.removeItem(at: url)
            } catch {
                throw AnyError.diskError(.remove(error))
            }
        })
    }
    
    func removeAll() throws {
        do {
            try config.manager.removeItem(at: config.saveCachePath)
            try prepareDocuments()
        } catch {
            throw AnyError.diskError(.removeAll(error))
        }
    }
}
