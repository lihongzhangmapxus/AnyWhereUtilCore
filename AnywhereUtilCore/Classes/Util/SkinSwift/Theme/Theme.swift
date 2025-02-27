//
//  Theme.swift
//  vip
//
//  Created by mapxus on 2022/7/5.
//

import Foundation
import UIKit

public enum Theme: String {
    case normal = "Normal" // 普通模式
    case cornerCase = "Corner"
    case fontCase = "Font"

    @objc public enum Color: Int {
        case backgroundColor
        // direction
        case primaryBgColor
        case primaryBgDisableColor
        case primaryContentColor
        case primaryContentDisableColor
        // share
        case secondaryBgColor
        case secondaryContentColor
        // search
        case searchBgColor
        case searchContentColor
        // tag
        case tagBgSelected
        case tagBgUnselected
        case tagContentSelected
        case tagContentUnselected
        // Floor Selector
        case floorBgSelected
        case floorBgUnselected
        case floorContentSelected
        case badgeColor
        // input Field
        case inputFieldPlaceholder
        case inputFieldTextColor
        case inputFieldBgColor
        case inputFieldBorder
        case inputFieldBorderUnfocused
        // Business Status
        case openColor
        case closeColor
        case upcomingColor
        // Text
        case commonTextColor
        case titleTextColor
        case subTextColor

        case outdoorLineColor   // Outdoor line segment colour
        case indoorLineColor    // Indoor line segment colour
        case dashLineColor      // dash line segment colour

        // building selecotr
        case buildingSelectorTextColor
        case buildingSelectorBgColor
        case buildingSelectorBorderColor
        case buildingSelectorDisableTextColor
        case buildingSelectorDisableBgColor
        case buildingSelectorDisableBorderColor
        
        public var stringValue: String {
            switch self {
            case .backgroundColor: return "backgroundColor"
            case .primaryBgColor: return "primaryBgColor"
            case .primaryBgDisableColor: return "primaryBgDisableColor"
            case .primaryContentColor: return "primaryContentColor"
            case .primaryContentDisableColor: return "primaryContentDisableColor"
            case .secondaryBgColor: return "secondaryBgColor"
            case .secondaryContentColor: return "secondaryContentColor"
            case .searchBgColor: return "searchBgColor"
            case .searchContentColor: return "searchContentColor"
            case .tagBgSelected: return "tagBgSelected"
            case .tagBgUnselected: return "tagBgUnselected"
            case .tagContentSelected: return "tagContentSelected"
            case .tagContentUnselected: return "tagContentUnselected"
            case .floorBgSelected: return "floorBgSelected"
            case .floorBgUnselected: return "floorBgUnselected"
            case .floorContentSelected: return "floorContentSelected"
            case .badgeColor: return "badgeColor"
            case .inputFieldPlaceholder: return "inputFieldPlaceholder"
            case .inputFieldTextColor: return "inputFieldTextColor"
            case .inputFieldBgColor: return "inputFieldBgColor"
            case .inputFieldBorder: return "inputFieldBorder"
            case .inputFieldBorderUnfocused: return "inputFieldBorderUnfocused"
            case .openColor: return "openColor"
            case .closeColor: return "closeColor"
            case .upcomingColor: return "upcomingColor"
            case .commonTextColor: return "commonTextColor"
            case .titleTextColor: return "titleTextColor"
            case .subTextColor: return "subTextColor"
            case .outdoorLineColor: return "outdoorLineColor"
            case .indoorLineColor: return "indoorLineColor"
            case .dashLineColor: return "dashLineColor"
            case .buildingSelectorTextColor: return "buildingSelectorTextColor"
            case .buildingSelectorBgColor: return "buildingSelectorBgColor"
            case .buildingSelectorBorderColor: return "buildingSelectorBorderColor"
            case .buildingSelectorDisableTextColor: return "buildingSelectorDisableTextColor"
            case .buildingSelectorDisableBgColor: return "buildingSelectorDisableBgColor"
            case .buildingSelectorDisableBorderColor: return "buildingSelectorDisableBorderColor"
            }
        }
    }

    @objc public enum Corner: Int {
        case buttonShapeCorner
        case imageShapeCorner
        case searchBarShapeCorner
        case bottomSheetShapeCorner // (only appy to topLeft and topRight corner)

        public var code: String {
            switch self {
            case .buttonShapeCorner:
                return "buttonShapeCorner"
            case .imageShapeCorner:
                return "imageShapeCorner"
            case .searchBarShapeCorner:
                return "searchBarShapeCorner"
            case .bottomSheetShapeCorner:
                return "bottomSheetShapeCorner"
            }
        }
        
        var defaultValue: CGFloat {
            switch self {
            case .buttonShapeCorner:
                return ThemeCorner(self.code)
            case .imageShapeCorner:
                return ThemeCorner(self.code)
            case .searchBarShapeCorner:
                return ThemeCorner(self.code)
            case .bottomSheetShapeCorner:
                return ThemeCorner(self.code)
            }
        }
    }
    
    @objc public enum Font: Int {
        case font_heading_1
        case font_heading_2
        case font_body_1
        case font_caption
        case font_titlelabel
        
        public var code: String {
            switch self {
            case .font_heading_1:
                return "font_heading_1"
            case .font_heading_2:
                return "font_heading_2"
            case .font_body_1:
                return "font_body_1"
            case .font_caption:
                return "font_caption"
            case .font_titlelabel:
                return "font_titlelabel"
            }
        }
        
        public var defaultSize: CGFloat {
            switch self {
            case .font_heading_1:
                let font = ThemeFont(self.code)
                return font?.pointSize ?? 20.0
            case .font_heading_2:
                let font = ThemeFont(self.code)
                return font?.pointSize ?? 15.0
            case .font_body_1:
                let font = ThemeFont(self.code)
                return font?.pointSize ?? 13.0
            case .font_caption:
                let font = ThemeFont(self.code)
                return font?.pointSize ?? 13.0
            case .font_titlelabel:
                let font = ThemeFont(self.code)
                return font?.pointSize ?? 17.0
            }
        }
    }
}

@objcMembers public class ThemeStruct: NSObject {

    // Colors
    private var colorDict: [String: String] = [:]
    // Corners
    private var cornerDict: [String: CGFloat] = [:]
    // Fonts
    private var fontDict: [String: CGFloat] = [:]

    private var defaultInfo: [String: Any] = [
        "default": [:]
    ]
    
    public var colorConfig: ThemeColorConfiguration
    public var fontConfig: ThemeFontConfiguration
    public var cornerConfig: ThemeCornerConfiguration

    @objc public init(
        colorConfiguration: ThemeColorConfiguration = ThemeColorConfiguration(),
        fontConfiguration: ThemeFontConfiguration = ThemeFontConfiguration(),
        cornerConfiguration: ThemeCornerConfiguration = ThemeCornerConfiguration()
    ) {
        self.colorConfig = colorConfiguration
        self.fontConfig = fontConfiguration
        self.cornerConfig = cornerConfiguration
        super.init()
        
        resetToDefault()
    }
    
    // Set default theme values
    public func resetToDefault() {
        setupColors(
            backgroundColor: colorConfig.backgroundColor,
            primaryBgColor: colorConfig.primaryBgColor,
            primaryBgDisableColor: colorConfig.primaryBgDisableColor,
            primaryContentColor: colorConfig.primaryContentColor,
            primaryContentDisableColor: colorConfig.primaryContentDisableColor,
            
            secondaryBgColor: colorConfig.secondaryBgColor,
            secondaryContentColor: colorConfig.secondaryContentColor,
            searchBgColor: colorConfig.searchBgColor,
            searchContentColor: colorConfig.searchContentColor,
            
            tagBgSelected: colorConfig.tagBgSelected,
            tagBgUnselected: colorConfig.tagBgUnselected,
            tagContentSelected: colorConfig.tagContentSelected,
            tagContentUnselected: colorConfig.tagContentUnselected,
            
            floorBgSelected: colorConfig.floorBgSelected,
            floorBgUnselected: colorConfig.floorBgUnselected,
            floorContentSelected: colorConfig.floorContentSelected,
            
            badgeColor: colorConfig.badgeColor,
            
            inputFieldPlaceholder: colorConfig.inputFieldPlaceholder,
            inputFieldTextColor: colorConfig.inputFieldTextColor,
            inputFieldBgColor: colorConfig.inputFieldBgColor,
            inputFieldBorder: colorConfig.inputFieldBorder,
            inputFieldBorderUnfocused: colorConfig.inputFieldBorderUnfocused,
            
            openColor: colorConfig.openColor,
            closeColor: colorConfig.closeColor,
            upcomingColor: colorConfig.upcomingColor,
            
            commonTextColor: colorConfig.commonTextColor,
            titleTextColor: colorConfig.titleTextColor,
            subTextColor: colorConfig.subTextColor,
            indoorLineColor: colorConfig.indoorLineColor,
            outdoorLineColor: colorConfig.outdoorLineColor,
            dashLineColor: colorConfig.dashLineColor,
            
            buildingSelectorTextColor: colorConfig.buildingSelectorTextColor,
            buildingSelectorBgColor: colorConfig.buildingSelectorBgColor,
            buildingSelectorBorderColor: colorConfig.buildingSelectorBorderColor,
            buildingSelectorDisableTextColor: colorConfig.buildingSelectorDisableTextColor,
            buildingSelectorDisableBgColor: colorConfig.buildingSelectorDisableBgColor,
            buildingSelectorDisableBorderColor: colorConfig.buildingSelectorDisableBorderColor
        )
        setupCorners(
            buttonShapeCorner: cornerConfig.buttonShapeCorner,
            imageShapeCorner: cornerConfig.imageShapeCorner,
            searchBarShapeCorner: cornerConfig.searchBarShapeCorner,
            bottomSheetShapeCorner: cornerConfig.bottomSheetShapeCorner
        )
        setupFonts(
            fontHeading1: fontConfig.fontHeading1,
            fontHeading2: fontConfig.fontHeading2,
            font_body_1: fontConfig.fontBody1,
            font_caption: fontConfig.fontCaption,
            font_titlelabel: fontConfig.fontTitleLabel
        )
    }
    
    
    // Configure colors
    public func setupColors(backgroundColor: String,
                            primaryBgColor: String,
                            primaryBgDisableColor: String,
                            primaryContentColor: String,
                            primaryContentDisableColor: String,
                            
                            // share
                            secondaryBgColor: String,
                            secondaryContentColor: String,
                            // search
                            searchBgColor: String,
                            searchContentColor: String,
                            // tag
                            tagBgSelected: String,
                            tagBgUnselected: String,
                            tagContentSelected: String,
                            tagContentUnselected: String,
                            // floor
                            floorBgSelected: String,
                            floorBgUnselected: String,
                            floorContentSelected: String,
                            badgeColor: String,
                            // input Field
                            inputFieldPlaceholder: String,
                            inputFieldTextColor: String,
                            inputFieldBgColor: String,
                            inputFieldBorder: String,
                            inputFieldBorderUnfocused: String,
                            // Business Status
                            openColor: String,
                            closeColor: String,
                            upcomingColor: String,

                            commonTextColor: String,
                            titleTextColor: String,
                            subTextColor: String,

                            indoorLineColor: String,
                            outdoorLineColor: String,
                            dashLineColor: String,

                            buildingSelectorTextColor: String,
                            buildingSelectorBgColor: String,
                            buildingSelectorBorderColor: String,
                            buildingSelectorDisableTextColor: String,
                            buildingSelectorDisableBgColor: String,
                            buildingSelectorDisableBorderColor: String
    ) {
        colorDict = [
            Theme.Color.backgroundColor.stringValue: backgroundColor,
            Theme.Color.primaryBgColor.stringValue: primaryBgColor,
            Theme.Color.primaryBgDisableColor.stringValue: primaryBgDisableColor,
            Theme.Color.primaryContentColor.stringValue: primaryContentColor,
            Theme.Color.primaryContentDisableColor.stringValue: primaryContentDisableColor,
            
            Theme.Color.secondaryBgColor.stringValue: secondaryBgColor,
            Theme.Color.secondaryContentColor.stringValue: secondaryContentColor,

            Theme.Color.searchBgColor.stringValue: searchBgColor,
            Theme.Color.searchContentColor.stringValue: searchContentColor,

            Theme.Color.tagBgSelected.stringValue: tagBgSelected,
            Theme.Color.tagBgUnselected.stringValue: tagBgUnselected,
            Theme.Color.tagContentSelected.stringValue: tagContentSelected,
            Theme.Color.tagContentUnselected.stringValue: tagContentUnselected,

            Theme.Color.floorBgSelected.stringValue: floorBgSelected,
            Theme.Color.floorBgUnselected.stringValue: floorBgUnselected,
            Theme.Color.floorContentSelected.stringValue: floorContentSelected,
            Theme.Color.badgeColor.stringValue: badgeColor,

            Theme.Color.inputFieldPlaceholder.stringValue: inputFieldPlaceholder,
            Theme.Color.inputFieldTextColor.stringValue: inputFieldTextColor,
            Theme.Color.inputFieldBgColor.stringValue: inputFieldBgColor,
            Theme.Color.inputFieldBorder.stringValue: inputFieldBorder,
            Theme.Color.inputFieldBorderUnfocused.stringValue: inputFieldBorderUnfocused,

            Theme.Color.openColor.stringValue: openColor,
            Theme.Color.closeColor.stringValue: closeColor,
            Theme.Color.upcomingColor.stringValue: upcomingColor,

            Theme.Color.commonTextColor.stringValue: commonTextColor,
            Theme.Color.titleTextColor.stringValue: titleTextColor,
            Theme.Color.subTextColor.stringValue: subTextColor,

            Theme.Color.outdoorLineColor.stringValue: outdoorLineColor,
            Theme.Color.indoorLineColor.stringValue: indoorLineColor,
            Theme.Color.dashLineColor.stringValue: dashLineColor,

            Theme.Color.buildingSelectorTextColor.stringValue: buildingSelectorTextColor,
            Theme.Color.buildingSelectorBgColor.stringValue: buildingSelectorBgColor,
            Theme.Color.buildingSelectorBorderColor.stringValue: buildingSelectorBorderColor,
            Theme.Color.buildingSelectorDisableTextColor.stringValue: buildingSelectorDisableTextColor,
            Theme.Color.buildingSelectorDisableBgColor.stringValue: buildingSelectorDisableBgColor,
            Theme.Color.buildingSelectorDisableBorderColor.stringValue: buildingSelectorDisableBorderColor
        ]
        applyTheme()
    }
    
    // Configure corners
    public func setupCorners(buttonShapeCorner: CGFloat = 8, imageShapeCorner: CGFloat = 4, searchBarShapeCorner: CGFloat = 10, bottomSheetShapeCorner: CGFloat = 10) {
        cornerDict = [
            Theme.Corner.buttonShapeCorner.code: buttonShapeCorner,
            Theme.Corner.imageShapeCorner.code: imageShapeCorner,
            Theme.Corner.searchBarShapeCorner.code: searchBarShapeCorner,
            Theme.Corner.bottomSheetShapeCorner.code: bottomSheetShapeCorner
        ]
        applyTheme()
    }

    // Configure fonts
    public func setupFonts(fontHeading1: CGFloat = 20, fontHeading2: CGFloat = 15, font_body_1: CGFloat = 13, font_caption: CGFloat = 13, font_titlelabel: CGFloat = 17) {
        fontDict = [
            Theme.Font.font_heading_1.code: fontHeading1,
            Theme.Font.font_heading_2.code: fontHeading2,
            Theme.Font.font_body_1.code: font_body_1,
            Theme.Font.font_caption.code: font_caption,
            Theme.Font.font_titlelabel.code: font_titlelabel
        ]
        applyTheme()
    }
    
    // Apply the theme to the skin manager
    private func applyTheme() {
        let updatedInfo: [String: Any] = [
            Theme.normal.rawValue: colorDict,
            Theme.fontCase.rawValue: fontDict,
            Theme.cornerCase.rawValue: cornerDict
        ]
        defaultInfo["default"] = updatedInfo
        SkinManager.shared.replaceSkinInfo(skinName: "default", skinPlistInfo: defaultInfo)
    }
    
    /// Configures the app theme by loading settings from a specified plist file.
    /// - Parameters:
    ///   - path: The file path to the plist containing theme configurations. If `nil` or invalid, the theme is reset to the default settings.
    ///   - skinName: The name of the theme (skin) to apply. Defaults to "default".
    ///
    /// The method performs the following operations:
    /// - Loads color, corner radius, and font configurations for the specified theme.
    /// - Updates internal dictionaries (`colorDict`, `cornerDict`, and `fontDict`) with the parsed values.
    /// - Applies the parsed theme configuration to the `SkinManager`, ensuring the app reflects the updated theme settings.
    ///
    /// **Behavior**:
    /// - If the `path` is `nil` or the plist file cannot be parsed correctly, the method resets the theme to default settings.
    /// - Only the specified `skinName` is applied; other configurations in the plist are ignored.
    ///
    /// This method allows the app to dynamically switch between themes and customize the user interface appearance.
    public func setTheme(fromPlist path: String?, skinName: String? = nil) {
        guard let plistPath = path,
              let plistContent = NSDictionary(contentsOfFile: plistPath) as? [String: Any] else {
            resetToDefault()
            return
        }
        
        // 如果 skinName 为 nil，则直接使用 plistContent，否则使用指定的 skinName 内容
        let skinContent = skinName != nil ? plistContent[skinName!] as? [String: Any] : plistContent

        guard let skinContent = skinContent else {
            resetToDefault()
            return
        }
        let key = skinName ?? "default"
        let content = skinContent[key] as? [String : Any]

        // 加载颜色配置
        if let tmp = content, let colorConfig = tmp[Theme.normal.rawValue] as? [String: String] {
            colorDict = colorConfig
        }

        // 加载圆角配置
        if let tmp = content, let cornerConfig = tmp[Theme.cornerCase.rawValue] as? [String: CGFloat] {
            cornerDict = cornerConfig
        }

        // 加载字体配置
        if let tmp = content, let fontConfig = tmp[Theme.fontCase.rawValue] as? [String: CGFloat] {
            fontDict = fontConfig
        }

        // 应用主题到 SkinManager
        let updatedSkinInfo: [String: Any] = [
            Theme.normal.rawValue: colorDict,
            Theme.cornerCase.rawValue: cornerDict,
            Theme.fontCase.rawValue: fontDict
        ]
        defaultInfo[key] = updatedSkinInfo
        SkinManager.shared.replaceSkinInfo(skinName: skinName ?? "default", skinPlistInfo: defaultInfo)
    }
 
    
    /// Configures the font resources for the theme.
    ///
    /// - Parameters:
    ///   - name: The name of the regular font.
    ///   - regularPath: The file path to the regular font resource.
    ///   - nameBold: The name of the bold font.
    ///   - boldPath: The file path to the bold font resource.
    public func setupFontResources(withRegular name: String?, regularPath: String?, bold nameBold: String?, boldPath: String?) {
        SkinManager.shared.regularName = name
        SkinManager.shared.regularPath = regularPath
         
        SkinManager.shared.boldName = nameBold
        SkinManager.shared.boldPath = boldPath
    }

}
