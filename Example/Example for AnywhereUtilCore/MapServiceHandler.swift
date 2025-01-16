//
//  MapServiceHandler.swift
//  AnywhereUtil_Example
//
//  Created by Mapxus on 2025/1/16.
//

import Foundation
import MapxusBaseSDK

// MARK: - MapServiceHandler
class MapServiceHandler: NSObject, MXMServiceDelegate {
    
    private var onFinish: ((Error?) -> Void)?
    
    func register(apiKey: String, secret: String, completion: ((Error?) -> Void)?) {
        onFinish = completion
        
        guard !apiKey.isEmpty, !secret.isEmpty else {
            let error = NSError(domain: "com.mapxus.error", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid API Key or Secret"])
            onFinish?(error)
            return
        }
        
        let mapServices = MXMMapServices.shared()
        mapServices.delegate = self
        mapServices.register(withApiKey: apiKey, secret: secret)
    }
    
    func registerMXMServiceSuccess() {
        onFinish?(nil)
    }
    
    func registerMXMServiceFailWithError(_ error: any Error) {
        onFinish?(error)
    }
    
}

