//
//  UIImageView+Extension.swift
//  DropInUISDK
//
//  Created by mapxus on 2023/2/9.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit
import Kingfisher
import AFNetworking

public typealias afnImageSuccess = (_ image: UIImage?, _ error: Error?) -> Void

public extension UIImageView {
    // kf
    func setUrlImage(with urlString: String, placeholder: UIImage? = nil, completion: afnImageSuccess? = nil) {
        guard let url = urlString.asURL else {
            completion?(nil, nil)
            return
        }
        kf.setImage(with: url, placeholder: placeholder) { result in
            switch result {
            case .success(let result):
                if let success = completion {
                    success(result.image, nil)
                }
            case .failure(let error):
                if let closure = completion {
                    closure(nil, error)
                }
            }
        }
//        if let cachedImage = ImageCacheManager.shared.loadImage(for: url) {
//            DispatchQueue.main.async { [self] in
//                image = cachedImage
//            }
//            return
//        }
//        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
//        setImageWith(request, placeholderImage: placeholder) { req, resp, image in
//            self.image = image
//            if let data = image.jpegData(compressionQuality: 1.0) {
//                ImageCacheManager.shared.save(imageData: data, for: url)
//            }
//            completion?(image, nil)
//        } failure: { req, resp, error in
//            self.image = placeholder
//            completion?(nil, error)
//        }
    }
    // afn
    func setAfnUrl(with url: URL, placeholder: UIImage? = UIImage.getSdkImage(named: "placeholder_image"), finish: ((UIImage) -> Void)?) {
        self.setImageWith(URLRequest(url: url), placeholderImage: placeholder) { req, rep, image in
            finish?(image)
        }
    }
}

public class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let maxCacheSize: Int64 = 50 * 1024 * 1024  // 50 MB
    private let cacheExpirationInterval: TimeInterval = 7 * 24 * 60 * 60  // 7 days

    public init() {
        let cachesPath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesPath.appendingPathComponent("ImageCache", isDirectory: true)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        
        cleanExpiredCache()
        manageCacheSize()
    }

    // Cache Path for a given URL
    func cachePath(for url: URL) -> URL {
        return cacheDirectory.appendingPathComponent(url.lastPathComponent)
    }

    // Save image data to cache with timestamp
    func save(imageData: Data, for url: URL) {
        let path = cachePath(for: url)
        try? imageData.write(to: path)
        updateFileModificationDate(at: path)
        manageCacheSize()
    }

    // Load image from cache
    func loadImage(for url: URL) -> UIImage? {
        let path = cachePath(for: url)
        
        if fileManager.fileExists(atPath: path.path), !isFileExpired(at: path) {
            updateFileModificationDate(at: path)
            return UIImage(contentsOfFile: path.path)
        }
        
        return nil
    }
    
    // Update file modification date to keep it fresh in the cache
    private func updateFileModificationDate(at path: URL) {
        try? fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: path.path)
    }

    // Check if a file is expired based on its modification date
    private func isFileExpired(at path: URL) -> Bool {
        guard let attributes = try? fileManager.attributesOfItem(atPath: path.path),
              let modificationDate = attributes[.modificationDate] as? Date else {
            return false
        }
        
        return Date().timeIntervalSince(modificationDate) > cacheExpirationInterval
    }
    
    // Clean expired cache files
    private func cleanExpiredCache() {
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.contentModificationDateKey]) else {
            return
        }
        
        for file in files {
            if isFileExpired(at: file) {
                try? fileManager.removeItem(at: file)
            }
        }
    }

    // Manage cache size by removing oldest files if the size exceeds the limit
    private func manageCacheSize() {
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey, .contentModificationDateKey]) else {
            return
        }
        // 在 reduce 中显式指定类型为 Int64
        var totalSize: Int64 = files.reduce(0 as Int64) { (currentTotal, fileURL) -> Int64 in
            let fileSize = (try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
            return currentTotal + Int64(fileSize)
        }
        if totalSize > maxCacheSize {
            let sortedFiles = files.sorted {
                let date1 = (try? $0.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? Date.distantPast
                let date2 = (try? $1.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? Date.distantPast
                return date1 < date2
            }
            for file in sortedFiles {
                try? fileManager.removeItem(at: file)
                totalSize -= Int64((try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0)
                
                if totalSize <= maxCacheSize {
                    break
                }
            }
        }
    }
}
