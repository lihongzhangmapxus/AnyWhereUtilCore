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
            completion?(img, nil)
        }
    }
    func setAfnUrl(with urlString: String, placeholder: UIImage? = UIImage.getSdkImage(named: "placeholder_image"), finish: ((UIImage?) -> Void)?) {
        guard let url = URL(string: urlString) else {
            finish?(placeholder)
            return
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30.0)
        self.setImageWith(request, placeholderImage: placeholder) { req, rep, image in
            AFImageDownloader.defaultInstance().imageCache?.add(image, for: request, withAdditionalIdentifier: nil)
            self.image = image
            finish?(image)
        }
    }
}
