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

    public enum Color: String {
        // Used to communicate brand elements, and draw attention to critical elements, such as call to action buttons and list items:
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
        case buildingSelectorDisableTextColour
        case buildingSelectorDisableBgColor
        case buildingSelectorDisableBorderColor
    }

    public enum Corner: String {
        case buttonShapeCorner
        case imageShapeCorner
        case searchBarShapeCorner
        case bottomSheetShapeCorner // (only appy to topLeft and topRight corner)

        var defaultValue: CGFloat {
            switch self {
            case .buttonShapeCorner:
                return ThemeCorner(self.rawValue)
            case .imageShapeCorner:
                return ThemeCorner(self.rawValue)
            case .searchBarShapeCorner:
                return ThemeCorner(self.rawValue)
            case .bottomSheetShapeCorner:
                return ThemeCorner(self.rawValue)
            }
        }
    }
    
    public enum Font: String {
        case font_heading_1
        case font_heading_2
        case font_body_1
        case font_caption
        case font_titlelabel
        
        var defaultSize: CGFloat {
            switch self {
            case .font_heading_1:
                let font = ThemeFont(self.rawValue)
                return font?.pointSize ?? 20.0
            case .font_heading_2:
                let font = ThemeFont(self.rawValue)
                return font?.pointSize ?? 15.0
            case .font_body_1:
                let font = ThemeFont(self.rawValue)
                return font?.pointSize ?? 13.0
            case .font_caption:
                let font = ThemeFont(self.rawValue)
                return font?.pointSize ?? 13.0
            case .font_titlelabel:
                let font = ThemeFont(self.rawValue)
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
            buildingSelectorDisableTextColour: colorConfig.buildingSelectorDisableTextColor,
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
                            buildingSelectorDisableTextColour: String,
                            buildingSelectorDisableBgColor: String,
                            buildingSelectorDisableBorderColor: String
    ) {
        colorDict = [
            Theme.Color.backgroundColor.rawValue: backgroundColor,
            Theme.Color.primaryBgColor.rawValue: primaryBgColor,
            Theme.Color.primaryBgDisableColor.rawValue: primaryBgDisableColor,
            Theme.Color.primaryContentColor.rawValue: primaryContentColor,
            Theme.Color.primaryContentDisableColor.rawValue: primaryContentDisableColor,
            
            Theme.Color.secondaryBgColor.rawValue: secondaryBgColor,
            Theme.Color.secondaryContentColor.rawValue: secondaryContentColor,

            Theme.Color.searchBgColor.rawValue: searchBgColor,
            Theme.Color.searchContentColor.rawValue: searchContentColor,

            Theme.Color.tagBgSelected.rawValue: tagBgSelected,
            Theme.Color.tagBgUnselected.rawValue: tagBgUnselected,
            Theme.Color.tagContentSelected.rawValue: tagContentSelected,
            Theme.Color.tagContentUnselected.rawValue: tagContentUnselected,

            Theme.Color.floorBgSelected.rawValue: floorBgSelected,
            Theme.Color.floorBgUnselected.rawValue: floorBgUnselected,
            Theme.Color.floorContentSelected.rawValue: floorContentSelected,
            Theme.Color.badgeColor.rawValue: badgeColor,

            Theme.Color.inputFieldPlaceholder.rawValue: inputFieldPlaceholder,
            Theme.Color.inputFieldTextColor.rawValue: inputFieldTextColor,
            Theme.Color.inputFieldBgColor.rawValue: inputFieldBgColor,
            Theme.Color.inputFieldBorder.rawValue: inputFieldBorder,
            Theme.Color.inputFieldBorderUnfocused.rawValue: inputFieldBorderUnfocused,

            Theme.Color.openColor.rawValue: openColor,
            Theme.Color.closeColor.rawValue: closeColor,
            Theme.Color.upcomingColor.rawValue: upcomingColor,

            Theme.Color.commonTextColor.rawValue: commonTextColor,
            Theme.Color.titleTextColor.rawValue: titleTextColor,
            Theme.Color.subTextColor.rawValue: subTextColor,

            Theme.Color.outdoorLineColor.rawValue: outdoorLineColor,
            Theme.Color.indoorLineColor.rawValue: indoorLineColor,
            Theme.Color.dashLineColor.rawValue: dashLineColor,

            Theme.Color.buildingSelectorTextColor.rawValue: buildingSelectorTextColor,
            Theme.Color.buildingSelectorBgColor.rawValue: buildingSelectorBgColor,
            Theme.Color.buildingSelectorBorderColor.rawValue: buildingSelectorBorderColor,
            Theme.Color.buildingSelectorDisableTextColour.rawValue: buildingSelectorDisableTextColour,
            Theme.Color.buildingSelectorDisableBgColor.rawValue: buildingSelectorDisableBgColor,
            Theme.Color.buildingSelectorDisableBorderColor.rawValue: buildingSelectorDisableBorderColor
        ]
        applyTheme()
    }
    
    // Configure corners
    public func setupCorners(buttonShapeCorner: CGFloat = 8, imageShapeCorner: CGFloat = 4, searchBarShapeCorner: CGFloat = 10, bottomSheetShapeCorner: CGFloat = 10) {
        cornerDict = [
            Theme.Corner.buttonShapeCorner.rawValue: buttonShapeCorner,
            Theme.Corner.imageShapeCorner.rawValue: imageShapeCorner,
            Theme.Corner.searchBarShapeCorner.rawValue: searchBarShapeCorner,
            Theme.Corner.bottomSheetShapeCorner.rawValue: bottomSheetShapeCorner
        ]
        applyTheme()
    }

    // Configure fonts
    public func setupFonts(fontHeading1: CGFloat = 20, fontHeading2: CGFloat = 15, font_body_1: CGFloat = 13, font_caption: CGFloat = 13, font_titlelabel: CGFloat = 17) {
        fontDict = [
            Theme.Font.font_heading_1.rawValue: fontHeading1,
            Theme.Font.font_heading_2.rawValue: fontHeading2,
            Theme.Font.font_body_1.rawValue: font_body_1,
            Theme.Font.font_caption.rawValue: font_caption,
            Theme.Font.font_titlelabel.rawValue: font_titlelabel
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
    
    // Load theme from a plist file
    public func setTheme(fromPlist path: String?, skinName: String = "default") {
        guard let plistPath = path,
              let plistContent = NSDictionary(contentsOfFile: plistPath) as? [String: Any],
              let skinContent = plistContent[skinName] as? [String: Any] else {
            resetToDefault()
            return
        }

        // 加载颜色配置
        if let colorConfig = skinContent[Theme.normal.rawValue] as? [String: String] {
            colorDict = colorConfig
        }

        // 加载圆角配置
        if let cornerConfig = skinContent[Theme.cornerCase.rawValue] as? [String: CGFloat] {
            cornerDict = cornerConfig
        }

        // 加载字体配置
        if let fontConfig = skinContent[Theme.fontCase.rawValue] as? [String: CGFloat] {
            fontDict = fontConfig
        }

        // 应用主题到 SkinManager
        let updatedSkinInfo: [String: Any] = [
            Theme.normal.rawValue: colorDict,
            Theme.cornerCase.rawValue: cornerDict,
            Theme.fontCase.rawValue: fontDict
        ]
        defaultInfo[skinName] = updatedSkinInfo
        SkinManager.shared.replaceSkinInfo(skinName: skinName, skinPlistInfo: defaultInfo)
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
