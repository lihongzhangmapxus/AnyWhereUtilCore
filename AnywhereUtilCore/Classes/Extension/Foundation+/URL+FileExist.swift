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
        AFImageDownloader.defaultInstance().downloadImage(for: request) { req, resp, img in
            completion(img, nil)
        } failure: { req, resp, error in
            completion(nil, error)
        }
    }
}
