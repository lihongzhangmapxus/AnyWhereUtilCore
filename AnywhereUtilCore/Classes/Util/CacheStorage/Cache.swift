import Foundation

public protocol CacheStorage {
    associatedtype Value
    
    func value(forKey key: String) throws -> Value?
    func save(_ value: Value, forKey key: String) throws
}

public class Cache<Value>: CacheStorage where Value: Codable {
    
    private let memory: MemoryCache<Value>
    
    private let disk: DiskCache<Value>
    
    public init(memory: MemoryCache<Value> = .init(countLimit: 300), disk: DiskCache<Value> = .init()) {
        self.memory = memory
        self.disk = disk
    }
    
    public func value(forKey key: String) throws -> Value? {
        if let memoryValue = try memory.value(forKey: key) {
            return memoryValue
        }

        if let diskValue = try disk.value(forKey: key) {
            try memory.save(diskValue, forKey: key)
            return diskValue
        }
        
        return nil
    }
    
    public func save(_ value: Value, forKey key: String) throws {
        try memory.save(value, forKey: key)
        try disk.save(value, forKey: key)
    }
    
}

/// Image(_ source: Source)
public protocol AnyImageSource {
    var url: URL? { get }
    var source: UIImage? { get }
}


/// Disk Cache Config
protocol AnyDiskConfig {
    var maxDate: ExpirationDate { get }
    var maxSize: Int64 { get }
    var manager: FileManager { get }
    var saveCachePath: URL { get }
    var diskQueue: DispatchQueue { get }
    init()
}


enum AnyError: Error {
    enum DiskError {
        case create(_ error: Error, _ path: String)
        case store(_ error: Error)
        case storeSetAttributes(_ error: Error)
        case meta(_ error: Error)
        case toData(_ error: Error)
        case remove(_ error: Error)
        case removeAll(_ error: Error)
        case createDirectory(_ error: Error)
    }
    case diskError(DiskError)
    
}


extension AnyError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .diskError(diskError):
            switch diskError {
            case let .create(error, path):
                return "WFErrorr: \(error.localizedDescription), path: \(path)"
            case let .store(error):
                return "WFErrorr: \(error.localizedDescription), store failture"
            case let .meta(error):
                return "WFErrorr: \(error.localizedDescription),  read meta failture"
            case let .toData(error):
                return "WFErrorr: \(error.localizedDescription),  file toData failture"
            case let .remove(error):
                return "WFErrorr: \(error.localizedDescription),  remove file failture"
            case let .removeAll(error):
                return "WFErrorr: \(error.localizedDescription),  remove all failture"
            case let .createDirectory(error):
                return "WFErrorr: \(error.localizedDescription),  createDirectory failture"
            case let .storeSetAttributes(error):
                return "WFErrorr: \(error.localizedDescription),  storeSetAttributes failture"
            }
        }
    }
}
