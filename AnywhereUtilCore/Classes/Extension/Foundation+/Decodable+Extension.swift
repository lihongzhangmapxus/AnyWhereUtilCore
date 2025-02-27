//
//  File.swift
//  AnywhereUtilCore
//
//  Created by Mapxus on 2025/1/15.
//

import Foundation

enum DecodableError: LocalizedError {
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

extension Decodable {
    public static func decode(from data: Data?, key: String?) throws -> Self {
        guard let dataTmp = data else {
            throw DecodableError.noData
        }

        let jsonData: Data
        if let key = key, let dict = dataTmp.asDict, let nestedDict = dict[key] {
            jsonData = try JSONSerialization.data(withJSONObject: nestedDict, options: [])
        } else if let dict = dataTmp.asDict {
            jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
        } else {
            throw DecodableError.parseFailed
        }
        return try JSONDecoder().decode(Self.self, from: jsonData)
    }
}


public extension JSONSerialization {
    static func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
}
