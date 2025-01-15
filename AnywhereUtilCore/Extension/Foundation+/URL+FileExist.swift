//
//  URL+FileExist.swift
//  DropInUISDK
//
//  Created by chenghao guo on 2022/8/18.
//  Copyright © 2022 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

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
        let options: [KingfisherOptionsInfoItem] = [
            .diskCacheExpiration(.days(10))
        ]
        ImageCache.default.retrieveImageInDiskCache(forKey: absoluteString, options: options, callbackQueue: .mainCurrentOrAsync) { cacheResult in
            switch cacheResult {
            case .success(let image):
                if let tmp = image {
                    completion(tmp, nil)
                } else {
                    downloadImage(with: self, options: options, completion: completion)
                }
            case .failure:
                downloadImage(with: self, options: options, completion: completion)
            }
        }
    }

    func downloadImage(with url: URL, options: KingfisherOptionsInfo? = nil, completion: @escaping (UIImage?, Error?) -> Void) {
        ImageDownloader.default.downloadImage(with: url, options: options) { result in
            switch result {
            case .success(let value):
                ImageCache.default.storeToDisk(value.originalData, forKey: url.absoluteString)
                completion(value.image, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
