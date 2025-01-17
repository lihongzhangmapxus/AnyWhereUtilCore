//
//  RequestManager.swift
//  DropInUISDK
//
//  Created by Chenghao Guo on 2020/2/7.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation
import AFNetworking

final class RequestManager: RequestManagerProtocol
{
    private var authorization: String?
    private var manager: AFHTTPSessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        var headers: Dictionary = [:]
        if let additionalHeaders = configuration.httpAdditionalHeaders {
            headers = additionalHeaders
        }
        if let token = Keychain.password(forAccount: "MXMToken") {
            headers["Authorization"] = token
            headers["token"] = token
        }
        configuration.httpAdditionalHeaders = headers
        var protocols: [AnyClass] = []
        
        if let list = configuration.protocolClasses, !list.isEmpty {
            protocols.append(contentsOf: list)
        }
        configuration.protocolClasses = protocols
        let manager = AFHTTPSessionManager(sessionConfiguration: configuration)
        let request = AFHTTPRequestSerializer()
        request.timeoutInterval = 30 // 设置超时时间为 30 秒
        if let token = Keychain.password(forAccount: "MXMToken") {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.setValue(token, forHTTPHeaderField: "token")
        }
        manager.requestSerializer = request
        manager.responseSerializer = AFHTTPResponseSerializer()
        return manager
    }()

    private let noAuthorizationManager: AFHTTPSessionManager = {
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        return manager
    }()
    
    func setSerializer(with token: String) {
        authorization = token
    }

    @discardableResult
    func noAuthorizationManagerRequest(withInterface interface: String, parameters: [String: Any]?, method: NetHTTPMethod, requestSerializer: NetRequestSerializer, callBack: @escaping ((RequestResult<Data>) -> Void)) -> URLSessionTask? {
        switch requestSerializer {
        case .http:
            noAuthorizationManager.requestSerializer = AFHTTPRequestSerializer()
        case .json:
            noAuthorizationManager.requestSerializer = AFJSONRequestSerializer()
        case .propertyList:
            noAuthorizationManager.requestSerializer = AFPropertyListRequestSerializer()
        }

        let successBlock: (URLSessionDataTask, Any) -> Void = { _, data in
            callBack(.success(data as? Data))
        }
        let failureBlock: (URLSessionDataTask?, Error) -> Void = { sectionTask, error in
            callBack(.failure(sectionTask, error))
        }

        switch method {
        case .get:
            let task = noAuthorizationManager.get(
                interface,
                parameters: parameters,
                headers: nil,
                progress: nil,
                success: successBlock,
                failure: failureBlock
            )
            return task
        case .post:
            let task = noAuthorizationManager.post(
                interface,
                parameters: parameters,
                headers: nil,
                progress: nil,
                success: successBlock,
                failure: failureBlock
            )
            return task
        }
    }

    @discardableResult
    func managerRequest(
        withInterface interface: String,
        parameters: [String: Any]?,
        method: NetHTTPMethod,
        requestSerializer: NetRequestSerializer,
        callBack: @escaping ((RequestResult<Data>) -> Void)
    ) -> URLSessionTask? {
        switch requestSerializer {
        case .http:
            manager.requestSerializer = AFHTTPRequestSerializer()
        case .json:
            manager.requestSerializer = AFJSONRequestSerializer()
        case .propertyList:
            manager.requestSerializer = AFPropertyListRequestSerializer()
        }
        
        if let auth = authorization, !auth.isEmpty {
            manager.requestSerializer.setValue(auth, forHTTPHeaderField: "Authorization")
            manager.requestSerializer.setValue(auth, forHTTPHeaderField: "token")
        }

        let successBlock: (URLSessionDataTask, Any) -> Void = { _, data in
            callBack(.success(data as? Data))
        }
        let failureBlock: (URLSessionDataTask?, Error) -> Void = { task, error in
            callBack(.failure(task, error))
        }

        switch method {
        case .get:
            let task = manager.get(
                interface,
                parameters: parameters,
                headers: nil,
                progress: nil,
                success: successBlock,
                failure: failureBlock
            )
            return task
        case .post:
            let task = manager.post(
                interface,
                parameters: parameters,
                headers: nil,
                progress: nil,
                success: successBlock,
                failure: failureBlock
            )
            return task
        }
    }
}
