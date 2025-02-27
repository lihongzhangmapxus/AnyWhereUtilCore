//
//  ProjectRequest.swift
//  DropInUISDK
//
//  Created by Chenghao Guo on 2020/2/10.
//  Copyright © 2022 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation
import AFNetworking

@objc public enum NetHTTPMethod: Int {
    case get
    case post
    
    var code: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

@objc public enum NetRequestSerializer: Int {
    case http
    case json
    case propertyList
}


enum DropInUIError: LocalizedError {
    case noData
    case parseFailed

    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data available"
        case .parseFailed:
            return "Failed to parse the data"
        }
    }
}

protocol RequestManagerProtocol {
    func managerRequest(
        withInterface interface: String,
        parameters: [String: Any]?,
        method: NetHTTPMethod,
        requestSerializer: NetRequestSerializer,
        callBack: @escaping((RequestResult) -> Void)
    ) -> URLSessionTask?

    func noAuthorizationManagerRequest(withInterface interface: String,
                                       parameters: [String: Any]?,
                                       method: NetHTTPMethod,
                                       requestSerializer: NetRequestSerializer,
                                       callBack: @escaping((RequestResult) -> Void)) -> URLSessionTask?


}


// MARK: InterfaceLayer
public class ProjectRequest: NSObject {
    public static var shared = ProjectRequest()
    public var requestManager = RequestManager()
    private let noAuthorizationDefault = RequestManager()
    
    public var onRegisterFinish: (() -> Bool)?
    
    // 设置最大递归次数为4次
    private lazy var maxRetries = 4
    
    public override init() {
        super.init()
    }

    @discardableResult
    public func request(withInterface interface: APIPathProviderProtocol, parameters: [String: Any]?, method: NetHTTPMethod, requestSerializer: NetRequestSerializer = .json,
                 retryCount: Int = 0,  // 新增递归次数计数器
                 completed: @escaping((RequestResult) -> Void)) -> URLSessionTask? {
        var task: URLSessionTask?

        let path = interface.getPath()
        // 处理URL特殊字符
//        if let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
//            path = encodedStr
//        }
        task = requestManager.managerRequest(withInterface: path, parameters: parameters, method: method, requestSerializer: requestSerializer) { result in
            completed(result)
//            switch result.type {
//            case .success:
//                completed(result.data as! RequestResult)
//                completed(.success(result.data))
//            case .failure:
//                let tmpTask, let error
//                completed(.failure(tmpTask, error))
//            }
            
        }
        return task
    }

    @discardableResult
    public func request(noAuthorization interface: APIPathProviderProtocol, parameters: [String: Any]?, method: NetHTTPMethod,
        requestSerializer: NetRequestSerializer = .json, completed: @escaping((RequestResult) -> Void) ) -> URLSessionTask? {
        var path = interface.getPath()
        // 处理URL空格情况
        if let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            path = encodedStr
        }
        let task = noAuthorizationDefault.noAuthorizationManagerRequest(
            withInterface: path,
            parameters: parameters,
            method: method,
            requestSerializer: requestSerializer
        ) { result in
            completed(result)
//            switch result {
//            case .success(let data):
//                completed(RequestResult.success(data))
//            case .failure(let tmpTask, let error):
//                completed(RequestResult.failure(tmpTask, error))
//            default:
//                break
//            }
        }
        return task
    }

}
