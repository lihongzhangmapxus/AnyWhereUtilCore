//
//  UIImageView+Extension.swift
//  DropInUISDK
//
//  Created by mapxus on 2023/2/9.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit
import AFNetworking

public typealias afnImageSuccess = (_ image: UIImage?, _ error: Error?) -> Void

public extension UIImageView {
    // kf
    func setUrlImage(with urlString: String, placeholder: UIImage? = nil, completion: afnImageSuccess? = nil) {
        setAfnUrl(with: urlString, placeholder: placeholder) { img in
            self.image = img
            completion?(img, nil)
        }
    }
    private func setAfnUrl(with source: AnyImageSource, placeholder: UIImage? = UIImage.getSdkImage(named: "placeholder_image"), finish: ((UIImage?) -> Void)?) {
        guard let url = source.url else {
            finish?(placeholder)
            return
        }
        let key = url.absoluteString
        if let image = AnyImageWebConfig.default.memoryCache[key] {
            finish?(image)
            return
        }
        if let objc = try? AnyImageWebConfig.default.diskCache.value(key), let image = UIImage(data: objc.value) {
            saveToMemory(image, key: key)
            finish?(image)
            return
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30.0)
        
        setImageWith(request, placeholderImage: placeholder) { [weak self] req, rep, image in
            guard let self = self else { return }
            saveToMemory(image, key: key)
//            let data = image.jpegData(compressionQuality: 1.0)
            let data = image.pngData()
            saveToDisk(data, key: key)
            self.image = image
            finish?(image)
        }
    }
    
    
    private func saveToMemory(_ image: UIImage, key: String) {
        AnyImageWebConfig.default.memoryCache[key] = image
    }
    
    private func saveToDisk(_ image: Data?, key: String) {
        if let data = image {
            try? AnyImageWebConfig.default.diskCache.store(AnyDiskStroage(value: data, key: key))
        }
    }

}
