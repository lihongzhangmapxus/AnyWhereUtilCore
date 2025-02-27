//
//  RequestResult.swift
//  DropInUISDK
//
//  Created by Chenghao Guo on 2020/2/10.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation

@objc public enum RequestResultType: Int {
    case success
    case failure
}

@objc public class RequestResult: NSObject {
    @objc public let type: RequestResultType
    @objc public let data: Any?
    @objc public let error: NSError?
    @objc public let sessionTask: URLSessionTask?

    @objc public init(type: RequestResultType, data: Any? = nil, error: NSError? = nil, sessionTask: URLSessionTask? = nil) {
        self.type = type
        self.data = data
        self.error = error
        self.sessionTask = sessionTask
    }

    @objc public var isSuccess: Bool {
        return type == .success
    }

    @objc public var isFailure: Bool {
        return type == .failure
    }

    @objc public var value: Any? {
        switch type {
        case .success:
            return data
        case .failure:
            return nil
        }
    }

    @objc public var failureError: NSError? {
        switch type {
        case .success:
            return nil
        case .failure:
            return error
        }
    }
}

//
//public enum RequestResult {
//    case success(Any?)
//    case failure(URLSessionTask?, NSError)
//}
//
//extension RequestResult {
//    var isSuccess: Bool {
//        switch self {
//        case .success:
//            return true
//        case .failure:
//            return false
//        }
//    }
//
//    var isFailure: Bool {
//        return !isSuccess
//    }
//
//    var value: Any? {
//        switch self {
//        case .success(let value):
//            return value
//        case .failure:
//            return nil
//        }
//    }
//
//    var error: NSError? {
//        switch self {
//        case .success:
//            return nil
//        case .failure(_, let error):
//            return error
//        }
//    }
//}


//@objc public enum RequestResultType: Int {
//    case success
//    case failure
//}
//
//@objc public class RequestResult: NSObject {
//    @objc public let type: RequestResultType
//    @objc public let task: URLSessionTask?
//    @objc public let error: Error?
//    
//    @objc public init(type: RequestResultType, task: URLSessionTask? = nil, error: Error? = nil) {
//        self.type = type
//        self.task = task
//        self.error = error
//    }
//    
//    @objc public var isSuccess: Bool {
//        return type == .success
//    }
//    
//    @objc public var isFailure: Bool {
//        return type == .failure
//    }
//    
//    @objc public var value: Any? {
//        guard type == .success else { return nil }
//        return task
//    }
//}
