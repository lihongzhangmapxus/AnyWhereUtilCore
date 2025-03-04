//
//  ShoplusServerConfig.swift
//  Shoplus
//
//  Created by Mapxus on 2025/1/10.
//

import Foundation

// 定义一个通用协议来获取服务器主机地址
@objc public protocol ServerProviderProtocol {
    var host: String { get }
    func serverHost() -> String
}

// 定义一个通用协议来获取 API 路径
@objc public protocol APIPathProviderProtocol {
    func getPath() -> String
}

@objc public enum Environment: Int {
    case dev
    case prod
    case kawasaki
}

struct AppConfig {
    /// 当前环境，默认为开发环境
    static var currentEnvironment: Environment = .dev
    
    /// 自定义主机配置
    /// AppConfig.customHosts[.mapApiHost] = "custom-map-api.com"
    /// AppConfig.customHosts[.anywhereHost] = "custom-anywhere.com"
    static var customHosts: [AnyHashable: String] = [:]
}

@objc public class ServerConfig: NSObject, ServerProviderProtocol {
    @objc public enum HostType: Int {
        case mapApiHost
        case serviceHost
        case anywhereHost
    }

    public let type: HostType

    public init(type: HostType) {
        self.type = type
    }

    /// 根据当前环境返回对应的主机地址
    public var host: String {
        // 检查是否有自定义主机配置
        if let customHost = AppConfig.customHosts[self] {
            return customHost
        }
        // 返回默认主机配置
        return getDefaultHost(for: AppConfig.currentEnvironment)
    }

    /// 生成完整的服务器地址
    public func serverHost() -> String {
        return "https://\(host)"
    }

    /// 根据环境返回默认主机配置
    private func getDefaultHost(for environment: Environment) -> String {
        switch type {
        case .mapApiHost:
            return hostForEnvironment(environment, dev: "map-api-test.mapxus.com",
                                      prod: "map-api.mapxus.com",
                                      kawasaki: "map-api.mapxus.co.jp")
        case .serviceHost:
            return hostForEnvironment(environment, dev: "map-service-test.mapxus.com",
                                      prod: "map-service.mapxus.com",
                                      kawasaki: "map-service.mapxus.co.jp")
        case .anywhereHost:
            return hostForEnvironment(environment, dev: "anywhere-test.mapxus.com",
                                      prod: "anywhere.mapxus.com",
                                      kawasaki: "anywhere.mapxus.co.jp")
        }
    }

    /// 根据环境返回主机
    private func hostForEnvironment(_ environment: Environment, dev: String, prod: String, kawasaki: String) -> String {
        switch environment {
        case .dev: return dev
        case .prod: return prod
        case .kawasaki: return kawasaki
        }
    }
}

//enum APIPathProvider: APIPathProviderProtocol {
//    case shoplusQuestionPois // 示例：现有的 API 路径
//
//    func getPath() -> String {
//        switch self {
//        case .shoplusQuestionPois:
//            let mapApiConfig = ServerConfig(type: .mapApiHost)
//            return mapApiConfig.host + "/api/v3/shoplus/question/pois"
//        }
//    }
//}
