//
//  URL+FileExist.swift
//  DropInUISDK
//
//  Created by chenghao guo on 2022/8/18.
//  Copyright © 2022 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

public extension URL {
    var cacheStr: String { return absoluteString }
    var downloadUrl: URL { return self }

    func isFileExist() -> Bool {
        let manager = FileManager.default
        return manager.fileExists(atPath: path)
    }
}

public extension URL {
    func loadImage(with completion: @escaping (UIImage?, Error?) -> Void) {
        let request = URLRequest(url: self, cachePolicy: .returnCacheDataElseLoad)
        
        let key = self.absoluteString
        if let image = AnyImageWebConfig.default.memoryCache[key] {
            completion(image, nil)
            return
        }
        if let objc = try? AnyImageWebConfig.default.diskCache.value(key), let image = UIImage(data: objc.value) {
            AnyImageWebConfig.default.memoryCache[key] = image
            completion(image, nil)
            return
        }

        AFImageDownloader.defaultInstance().downloadImage(for: request) { req, resp, img in
            AnyImageWebConfig.default.memoryCache[key] = img
            //确保你保存的是透明背景的 PNG 图像格式，因为 PNG 是支持透明度的，而 JPEG 不支持透明背景。你可以在保存图片时确保图像格式为 PNG。
            let data = img.pngData()
            saveToDisk(data, key: key)
            completion(img, nil)
        } failure: { req, resp, error in
            completion(nil, error)
        }
    }
    
    private func saveToDisk(_ image: Data?, key: String) {
        if let data = image {
            try? AnyImageWebConfig.default.diskCache.store(AnyDiskStroage(value: data, key: key))
        }
    }
}


extension URL: AnyImageSource {
    public var url: URL? {
        return self
    }
    public var source: UIImage? {
        return nil
    }
}
