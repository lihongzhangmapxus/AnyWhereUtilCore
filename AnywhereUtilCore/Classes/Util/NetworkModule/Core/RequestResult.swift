//
//  RequestResult.swift
//  DropInUISDK
//
//  Created by Chenghao Guo on 2020/2/10.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation

public enum RequestResult<T> {
    case success(T?)
    case failure(URLSessionTask?, Error)
}

extension RequestResult {
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    var isFailure: Bool {
        return !isSuccess
    }

    var value: T? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(_, let error):
            return error
        }
    }
}
