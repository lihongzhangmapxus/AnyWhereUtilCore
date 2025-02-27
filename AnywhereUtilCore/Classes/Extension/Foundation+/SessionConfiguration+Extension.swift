//
//  SessionConfiguration+Extension.swift
//  DropInUISDK
//
//  Created by Mapxus on 2023/11/30.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation
import AFNetworking

extension URLSessionConfiguration {
    static let swizzleSessionConfiguration: Void = {
        let originalSelector = #selector(getter: URLSessionConfiguration.default)
        let swizzledSelector = #selector(getter: URLSessionConfiguration.swizzledDefault)

        let originalMethod = class_getClassMethod(URLSessionConfiguration.self, originalSelector)
        let swizzledMethod = class_getClassMethod(URLSessionConfiguration.self, swizzledSelector)

        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }()

    @objc class var swizzledDefault: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.swizzledDefault
        configuration.httpAdditionalHeaders = ["token": "your-token"]
        return configuration
    }
}


extension AFHTTPSessionManager {
    static let swizzleGET: Void = {
        let originalSelector = #selector(AFHTTPSessionManager.get(_:parameters:headers:progress:success:failure:))
        let swizzledSelector = #selector(swizzled_GET(_:parameters:headers:progress:success:failure:))
        
        guard let originalMethod = class_getInstanceMethod(AFHTTPSessionManager.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(AFHTTPSessionManager.self, swizzledSelector) else {
            return
        }
        
        let didAddMethod = class_addMethod(AFHTTPSessionManager.self,
                                           originalSelector,
                                           method_getImplementation(swizzledMethod),
                                           method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(AFHTTPSessionManager.self,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()
    
    // Swizzled method
    @objc private func swizzled_GET(_ URLString: String,
                                    parameters: Any?,
                                    headers: [String: String]?,
                                    progress: ((Progress) -> Void)?,
                                    success: ((URLSessionDataTask, Any?) -> Void)?,
                                    failure: ((URLSessionDataTask?, Error) -> Void)?) -> URLSessionDataTask? {
        
        print("*** swizzled method with : \(URLString)")
        
        // Call the original method (because it's been swizzled)
        return swizzled_GET(URLString, parameters: parameters, headers: headers, progress: progress, success: success, failure: failure)
    }
}
