//
//  UIImageView+Extension.swift
//  DropInUISDK
//
//  Created by mapxus on 2023/2/9.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit
import Kingfisher

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
}
