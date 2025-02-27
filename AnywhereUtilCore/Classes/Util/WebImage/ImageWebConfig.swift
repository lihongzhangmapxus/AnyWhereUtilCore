//
//  AnyImageWebConfig.swift
//  AnywhereUtilCore
//
//  Created by Mapxus on 2025/2/21.
//

import Foundation

class AnyDiskConfigObjc: AnyDiskConfig
{
    var manager: FileManager = .default
    var maxDate: ExpirationDate = .days(7)
    var maxSize: Int64 = .max
    
    var saveCachePath: URL = {
        let basePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        var baseUrl = URL(fileURLWithPath: basePath)
        baseUrl.appendPathComponent("defalut_\(#function)")
        return baseUrl
    }()
    var diskQueue: DispatchQueue = DispatchQueue.init(label: "DiskQueue_\(UUID().uuidString)")
    required init() {
    }
}


class AnyImageWebConfig {
    static let `default` = AnyImageWebConfig()
    var diskConfig = AnyDiskConfigObjc()
    lazy var diskCache = AnyDiskCache(diskConfig)
    var memoryCache = AnyMemoryCache()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(removeStrongMemory), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeStrongMemory), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeDiskExpiredOrLimit), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc func removeDiskExpiredOrLimit() {
        AnyImageWebConfig.default.memoryCache.removeStongReferecen()
    }
    
    @objc func removeStrongMemory() {
        try? AnyImageWebConfig.default.diskCache.removeExpiredOrLimit()
    }
    
}

