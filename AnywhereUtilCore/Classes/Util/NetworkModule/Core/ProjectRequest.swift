//
//  ProjectRequest.swift
//  DropInUISDK
//
//  Created by Chenghao Guo on 2020/2/10.
//  Copyright © 2022 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation
import AFNetworking

public enum NetHTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum NetRequestSerializer {
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
        callBack: @escaping((RequestResult<Data>) -> Void)
    ) -> URLSessionTask?

    func noAuthorizationManagerRequest(withInterface interface: String,
                                       parameters: [String: Any]?,
                                       method: NetHTTPMethod,
                                       requestSerializer: NetRequestSerializer,
                                       callBack: @escaping((RequestResult<Data>) -> Void)) -> URLSessionTask?


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
                 completed: @escaping((RequestResult<Data>) -> Void)) -> URLSessionTask? {
        var task: URLSessionTask?

        var path = interface.getPath()
        // 处理URL特殊字符
        if let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            path = encodedStr
        }
        task = requestManager.managerRequest(withInterface: path, parameters: parameters, method: method, requestSerializer: requestSerializer) { result in
            switch result {
            case .success(let data):
                completed(RequestResult.success(data))
            case .failure(let tmpTask, let error):
                completed(RequestResult.failure(tmpTask, error))
            }
        }
        return task
    }

    @discardableResult
    public func request(noAuthorization interface: APIPathProviderProtocol, parameters: [String: Any]?, method: NetHTTPMethod,
        requestSerializer: NetRequestSerializer = .json, completed: @escaping((RequestResult<Data>) -> Void) ) -> URLSessionTask? {
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
            switch result {
            case .success(let data):
                completed(RequestResult.success(data))
            case .failure(let tmpTask, let error):
                completed(RequestResult.failure(tmpTask, error))
            default:
                break
            }
        }
        return task
    }
    
    // 定义一个泛型请求方法
    public class func performRequest<T: Decodable>(withInterface interface: APIPathProviderProtocol, parameters: [String: Any]?, jsonArrayKey: String = "result", method: NetHTTPMethod = .get, completion: @escaping (Result<T, Error>) -> Void) {
        ProjectRequest.shared.request(withInterface: interface, parameters: parameters, method: method) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedObject: T = try T.decode(from: data, key: jsonArrayKey)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(error))
                }
            case .failure(_, let error):
                completion(.failure(error))
            }
        }
    }
}
