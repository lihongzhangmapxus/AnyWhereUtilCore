//
//  AnywhereUtilCoreTests.swift
//  AnywhereUtilCoreTests
//
//  Created by Mapxus on 2025/1/14.
//

import XCTest
//@testable import AnywhereUtilCore
import AnywhereUtilCore

final class AnywhereUtilCoreTests: XCTestCase {
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    
    func testExample() throws {
        let str = "test".localized()
        print("** language = \(str)")
        
        let appSettings = AppSettings.shared
        print("** 当前首选语言: \(appSettings.preferredLanguage.code)")
        print("** 当前Language: \(appSettings.preferredLanguage)")
        Language.configureResourceBundleProvider {
            return Bundle.main
        }
        
        // 更新为简体中文
        AppSettings.shared.updatePreferredLanguage(to: .zh_Hans)
        print("** 更新后的语言: \(AppSettings.shared.preferredLanguage.code)")
        
        // 更新为系统语言
        AppSettings.shared.updatePreferredLanguage(to: .system)
        print("** 更新后的语言: \(AppSettings.shared.preferredLanguage.code)")
        
        if let bundle = AppSettings.shared.preferredLanguage.bundle() {
            let localizedString = bundle.localizedString(forKey: "test", value: nil, table: nil)
            print("** localizedString = \(localizedString)")
        }
    }
    
    func testUpdatePreferredLanguage() throws {
        AppSettings.shared.updatePreferredLanguage(to: .zh_Hans)
        print("** 更新后的语言: \(AppSettings.shared.preferredLanguage.code)")
        let code = AppSettings.shared.preferredLanguage.code
        let mainBundle = Bundle.main
        guard let path = mainBundle.path(forResource: code, ofType: "lproj"),
              let bundle = Foundation.Bundle(path: path) else {
            return
        }
        
        let str = "test".localized(in: bundle)
        print("** language = \(str)")
    }
    
    func testTheme() throws {
        let color = ThemeColorConfiguration(overrides: [
            \.backgroundColor : "#FF0000"
        ])
        let font = ThemeFontConfiguration(overrides: [
            \.fontHeading1 : 20
        ])
        let corner = ThemeCornerConfiguration(overrides: [
            \.buttonShapeCorner : 10
        ])
                
        let theme = ThemeStruct(colorConfiguration: color, fontConfiguration: font, cornerConfiguration: corner)
        
        let appSettings = AppSettings.shared
        appSettings.currentTheme = theme
        
        let tFont = ThemeFont(Theme.Font.font_heading_1.rawValue)
        let tColor = ThemeColor(Theme.Color.backgroundColor.rawValue)
        let tConrer = ThemeCorner(Theme.Corner.buttonShapeCorner.rawValue)
        print("** tFont = \(tFont)")
        print("** tColor = \(tColor)")
        print("** tConrer = \(tConrer)")
    }
    
    func testNetwork() throws {
//        AppConfig.customHosts[.mapApiHost] = "custom-map-api.com"
//        AppConfig.customHosts[.anywhereHost] = "custom-anywhere.com"
        
        AppConfig.currentEnvironment = .dev
        print("*** = host = \(ServerConfig.mapApiHost.serverHost())")  // 输出: https://custom-map-api.com
        print("*** = service = \(ServerConfig.serviceHost.serverHost())") // 输出: https://map-service-test.mapxus.com
        print("*** = anywhere = \(ServerConfig.anywhereHost.serverHost())") // 输出: https://custom-anywhere.com
        
//        AppConfig.customHosts[.mapApiHost] = nil
//        print(ServerConfig.mapApiHost.serverHost())  // 输出: https://map-api-test.mapxus.com
        
        AuthManager.setup(apiKey: "", apiSecret: "")
        
        let expectation = self.expectation(description: "Network Request")
        enum APIPathProvider: APIPathProviderProtocol {
            case shoplusQuestionPois // 示例：现有的 API 路径

            func getPath() -> String {
                switch self {
                case .shoplusQuestionPois:
                    return ServerConfig.anywhereHost.serverHost() + "/api/v3/shoplus/question/pois"
                }
            }
        }
        let re = ProjectRequest()
        re.request(withInterface: APIPathProvider.shoplusQuestionPois, parameters: nil, method: .get) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                print("*** data = \(data)")
                expectation.fulfill()
                break
            case .failure(let task, let error):
                XCTAssertNil(error)
                print("*** error = \(error)")
                expectation.fulfill()
                break
            }
        }
        waitForExpectations(timeout: 20) // 设置超时时间为 20 秒
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
