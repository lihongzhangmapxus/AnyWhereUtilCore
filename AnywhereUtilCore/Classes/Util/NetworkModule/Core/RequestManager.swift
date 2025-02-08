//
//  RequestManager.swift
//  DropInUISDK
//
//  Created by Chenghao Guo on 2020/2/7.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation
import AFNetworking

public class RequestManager: RequestManagerProtocol
{
    public var manager: AFHTTPSessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        var headers: Dictionary = [:]
        if let additionalHeaders = configuration.httpAdditionalHeaders {
            headers = additionalHeaders
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
        manager.requestSerializer = request
        manager.responseSerializer = AFHTTPResponseSerializer()
        return manager
    }()

    private let noAuthorizationManager: AFHTTPSessionManager = {
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        return manager
    }()
    
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
