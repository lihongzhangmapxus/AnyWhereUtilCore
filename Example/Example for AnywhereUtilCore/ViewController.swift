//
//  ViewController.swift
//  AnywhereUtilCore
//
//  Created by Mapxus on 2025/1/14.
//

import UIKit
import AnywhereUtilCore

class ViewController: UIViewController {

    private lazy var label = createLabel()
    private lazy var label2 = createLabel2()
    private lazy var button = createButton()
    private lazy var networkbtn = createNetworkButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configTheme()
        configSubviews()
        
    }

}


extension ViewController
{
    func configTheme() {
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
        let regularPath = Bundle.main.path(forResource: "Ubuntu", ofType: "ttf")
        let boldPath = Bundle.main.path(forResource: "Ubuntu-Bold", ofType: "ttf")
        theme.setupFontResources(withRegular: "Ubuntu", regularPath: regularPath, bold: "Ubuntu-Bold", boldPath: boldPath)

        let appSettings = AppSettings.shared
        appSettings.currentTheme = theme
        
        AppConfig.currentEnvironment = .prod
//        let tFont = ThemeFont(Theme.Font.font_heading_1.rawValue)
//        let tColor = ThemeColor(Theme.Color.titleTextColor.rawValue)
//        let tConrer = ThemeCorner(Theme.Corner.buttonShapeCorner.rawValue)
        
    }
    
    func configSubviews() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), // 与第一个 label 保持间距
            label.widthAnchor.constraint(equalToConstant: 200),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(label2)
        NSLayoutConstraint.activate([
            label2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20), // 与第一个 label 保持间距
            label2.widthAnchor.constraint(equalToConstant: 200),
            label2.heightAnchor.constraint(equalToConstant: 50)
        ])
        label.theme_backgroundColor = .primaryBgColor
        label2.theme_backgroundColor = .backgroundColor
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 20), // 与第一个 label 保持间距
            button.widthAnchor.constraint(equalToConstant: 200), // 按钮宽度
            button.heightAnchor.constraint(equalToConstant: 50)  // 按钮高度
        ])
        
        view.addSubview(networkbtn)
        NSLayoutConstraint.activate([
            networkbtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            networkbtn.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20), // 与第一个 label 保持间距
            networkbtn.widthAnchor.constraint(equalToConstant: 200), // 按钮宽度
            networkbtn.heightAnchor.constraint(equalToConstant: 50)  // 按钮高度
        ])
        
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "test".localized()
        label.font = ThemeFont(Theme.Font.font_heading_1.rawValue)
        label.font = ThemeFont(Theme.Font.font_heading_1.rawValue, .bold)
        label.theme_textColor = .titleTextColor
        label.layer.cornerRadius = 6
        return label
    }
    
    private func createLabel2() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "test".localized()
        label.font = ThemeFont(Theme.Font.font_heading_1.rawValue, .bold)
        label.font = ThemeFont(Theme.Font.font_heading_1.rawValue)
        label.theme_textColor = .titleTextColor
        label.layer.cornerRadius = 6
        return label
    }
    
    private func createButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change Theme", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        button.theme_setTitleColor(.primaryBgColor, for: .normal)
        button.theme_setBackgroundColor(.badgeColor, for: .normal)
        return button
    }
    private func createNetworkButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Test Network", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(clickNetworkButton(_:)), for: .touchUpInside)
        button.theme_setTitleColor(.primaryBgColor, for: .normal)
        button.theme_setBackgroundColor(.badgeColor, for: .normal)
        return button
    }
    
    @objc func clickButton(_ sender: UIButton) {
        let theme = AppSettings.shared.getTheme()
        let skinPath = Bundle.main.path(forResource: "ThemeSkin", ofType: "plist")
        theme.setTheme(fromPlist: skinPath)
        
//        sender.updateTheme()
//        label.updateTheme()

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "themeDidChange"), object: nil)
    }
    
    @objc func clickNetworkButton(_ sender: UIButton) {
        let re = ProjectRequest.shared
        re.onRegisterFinish = {
            let handler = MapServiceHandler()
            var registerSuccess = false

            let semaphore = DispatchSemaphore(value: 0)
            handler.register(apiKey: "bc635fc131d04e4fb541ab9e26924976", secret: "738fa012aeb0422189eccfb353d05698") { error in
                if error == nil {
                    registerSuccess = true
                }
                semaphore.signal() // 结束阻塞
            }
            semaphore.wait()
            return registerSuccess
        }
        
        re.request(withInterface: APIPathProvider.shoplusQuestionPois, parameters: nil, method: .get) { result in
            switch result {
            case .success(let data):
                print("*** data = \(data)")
                break
            case .failure(let task, let error):
                print("*** error = \(error)")
                break
            }
        }
        
    }
    
}

enum APIPathProvider: APIPathProviderProtocol {
    case shoplusQuestionPois // 示例：现有的 API 路径

    func getPath() -> String {
        switch self {
        case .shoplusQuestionPois:
            return ServerConfig.mapApiHost.serverHost() + "/api/v3/shoplus/question/pois"
        }
    }
}
