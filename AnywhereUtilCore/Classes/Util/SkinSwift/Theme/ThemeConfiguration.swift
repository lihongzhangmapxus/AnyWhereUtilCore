//
//  ThemeConfiguration.swift
//  Shoplus
//
//  Created by Mapxus on 2025/1/14.
//

import Foundation

@objc public enum ThemeColorKey: Int {
    case backgroundColor
    case primaryBgColor
    case primaryBgDisableColor
    case primaryContentColor
    case primaryContentDisableColor
    case secondaryBgColor
    case secondaryContentColor
    case searchBgColor
    case searchContentColor
    // tag
    case tagBgSelected
    case tagBgUnselected
    case tagContentSelected
    case tagContentUnselected
    // floor
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
    // text color
    case commonTextColor
    case titleTextColor
    case subTextColor

    // Line colors
    case outdoorLineColor
    case indoorLineColor
    case dashLineColor

    // Building Selector
    case buildingSelectorTextColor
    case buildingSelectorBgColor
    case buildingSelectorBorderColor
    case buildingSelectorDisableTextColor
    case buildingSelectorDisableBgColor
    case buildingSelectorDisableBorderColor
    
}

@objcMembers public class ThemeColorConfiguration: NSObject {
    // 定义属性，支持默认值
    public var backgroundColor: String = "#ffffff"
    // direction
    public var primaryBgColor: String = "#2073EC"
    public var primaryBgDisableColor: String = "#f5f5f5"
    public var primaryContentColor: String = "#ffffff"
    public var primaryContentDisableColor: String = "#BFBFBF"
    // share
    public var secondaryBgColor: String = "#EDF1FF"
    public var secondaryContentColor: String = "#2073EC"
    // search
    public var searchBgColor: String = "#F0F0F0"
    public var searchContentColor: String = "#8C8C8C"
    // tag
    public var tagBgSelected: String = "#2073ec"
    public var tagBgUnselected: String = "#F5F5F5"
    public var tagContentSelected: String = "#ffffff"
    public var tagContentUnselected: String = "#595959"
    // floor
    public var floorBgSelected: String = "#074769"
    public var floorBgUnselected: String = "#ffffff"
    public var floorContentSelected: String = "#ffffff"
    public var badgeColor: String = "#FF4D4F"
    // input Field
    public var inputFieldPlaceholder: String = "#BFBFBF"
    public var inputFieldTextColor: String = "#1F1F1F"
    public var inputFieldBgColor: String = "#F5F5F5"
    public var inputFieldBorder: String = "#BFBFBF"
    public var inputFieldBorderUnfocused: String = "#F0F0F0"
    // Business Status
    public var openColor: String = "#52C41A"
    public var closeColor: String = "#F5222D"
    public var upcomingColor: String = "#008ACD"
    // text color
    public var commonTextColor: String = "#202123"
    public var titleTextColor: String = "#000000"
    public var subTextColor: String = "#8C8C8C"

    // Line colors
    public var outdoorLineColor: String = ""
    public var indoorLineColor: String = ""
    public var dashLineColor: String = ""

    // Building Selector
    public var buildingSelectorTextColor: String = "#1f1f1f"
    public var buildingSelectorBgColor: String = "#ffffff"
    public var buildingSelectorBorderColor: String = "#d9d9d9"
    public var buildingSelectorDisableTextColor: String = "#8c8c8c"
    public var buildingSelectorDisableBgColor: String = "#f0f0f0"
    public var buildingSelectorDisableBorderColor: String = "#d9d9d9"
    
    public override init() {
        super.init()
    }

    // 支持局部初始化
    public init(overrides: [PartialKeyPath<ThemeColorConfiguration>: String]) {
        for (keyPath, value) in overrides {
            switch keyPath {
            case \.backgroundColor: backgroundColor = value
            case \.primaryBgColor: primaryBgColor = value
            case \.primaryBgDisableColor: primaryBgDisableColor = value
            case \.primaryContentColor: primaryContentColor = value
            case \.primaryContentDisableColor: primaryContentDisableColor = value
            case \.secondaryBgColor: secondaryBgColor = value
            case \.secondaryContentColor: secondaryContentColor = value
            case \.searchBgColor: searchBgColor = value
            case \.searchContentColor: searchContentColor = value
            case \.tagBgSelected: tagBgSelected = value
            case \.tagBgUnselected: tagBgUnselected = value
            case \.tagContentSelected: tagContentSelected = value
            case \.tagContentUnselected: tagContentUnselected = value
            case \.floorBgSelected: floorBgSelected = value
            case \.floorBgUnselected: floorBgUnselected = value
            case \.floorContentSelected: floorContentSelected = value
            case \.badgeColor: badgeColor = value
            case \.inputFieldPlaceholder: inputFieldPlaceholder = value
            case \.inputFieldTextColor: inputFieldTextColor = value
            case \.inputFieldBgColor: inputFieldBgColor = value
            case \.inputFieldBorder: inputFieldBorder = value
            case \.inputFieldBorderUnfocused: inputFieldBorderUnfocused = value
            case \.openColor: openColor = value
            case \.closeColor: closeColor = value
            case \.upcomingColor: upcomingColor = value
            case \.commonTextColor: commonTextColor = value
            case \.titleTextColor: titleTextColor = value
            case \.subTextColor: subTextColor = value
            case \.outdoorLineColor: outdoorLineColor = value
            case \.indoorLineColor: indoorLineColor = value
            case \.dashLineColor: dashLineColor = value
            case \.buildingSelectorTextColor: buildingSelectorTextColor = value
            case \.buildingSelectorBgColor: buildingSelectorBgColor = value
            case \.buildingSelectorBorderColor: buildingSelectorBorderColor = value
            case \.buildingSelectorDisableTextColor: buildingSelectorDisableTextColor = value
            case \.buildingSelectorDisableBgColor: buildingSelectorDisableBgColor = value
            case \.buildingSelectorDisableBorderColor: buildingSelectorDisableBorderColor = value
            default: break
            }
        }
    }
    
    // 支持局部初始化：通过字典传入属性名称和值
    @objc public func setOverrides(with colorValue: [NSNumber: String]) {
        for (key, value) in colorValue {
            switch key.intValue {  // 使用 `intValue` 获取枚举的原始值
            case ThemeColorKey.backgroundColor.rawValue:
                backgroundColor = value
            case ThemeColorKey.primaryBgColor.rawValue:
                primaryBgColor = value
            case ThemeColorKey.primaryBgDisableColor.rawValue:
                primaryBgDisableColor = value
            case ThemeColorKey.primaryContentColor.rawValue:
                primaryContentColor = value
            case ThemeColorKey.primaryContentDisableColor.rawValue:
                primaryContentDisableColor = value
            case ThemeColorKey.secondaryBgColor.rawValue:
                secondaryBgColor = value
            case ThemeColorKey.secondaryContentColor.rawValue:
                secondaryContentColor = value
            case ThemeColorKey.searchBgColor.rawValue:
                searchBgColor = value
            case ThemeColorKey.searchContentColor.rawValue:
                searchContentColor = value
            case ThemeColorKey.tagBgSelected.rawValue:
                tagBgSelected = value
            case ThemeColorKey.tagBgUnselected.rawValue:
                tagBgUnselected = value
            case ThemeColorKey.tagContentSelected.rawValue:
                tagContentSelected = value
            case ThemeColorKey.tagContentUnselected.rawValue:
                tagContentUnselected = value
            case ThemeColorKey.floorBgSelected.rawValue:
                floorBgSelected = value
            case ThemeColorKey.floorBgUnselected.rawValue:
                floorBgUnselected = value
            case ThemeColorKey.floorContentSelected.rawValue:
                floorContentSelected = value
            case ThemeColorKey.badgeColor.rawValue:
                badgeColor = value
            case ThemeColorKey.inputFieldPlaceholder.rawValue:
                inputFieldPlaceholder = value
            case ThemeColorKey.inputFieldTextColor.rawValue:
                inputFieldTextColor = value
            case ThemeColorKey.inputFieldBgColor.rawValue:
                inputFieldBgColor = value
            case ThemeColorKey.inputFieldBorder.rawValue:
                inputFieldBorder = value
            case ThemeColorKey.inputFieldBorderUnfocused.rawValue:
                inputFieldBorderUnfocused = value
            case ThemeColorKey.openColor.rawValue:
                openColor = value
            case ThemeColorKey.closeColor.rawValue:
                closeColor = value
            case ThemeColorKey.upcomingColor.rawValue:
                upcomingColor = value
            case ThemeColorKey.commonTextColor.rawValue:
                commonTextColor = value
            case ThemeColorKey.titleTextColor.rawValue:
                titleTextColor = value
            case ThemeColorKey.subTextColor.rawValue:
                subTextColor = value
            case ThemeColorKey.outdoorLineColor.rawValue:
                outdoorLineColor = value
            case ThemeColorKey.indoorLineColor.rawValue:
                indoorLineColor = value
            case ThemeColorKey.dashLineColor.rawValue:
                dashLineColor = value
            case ThemeColorKey.buildingSelectorTextColor.rawValue:
                buildingSelectorTextColor = value
            case ThemeColorKey.buildingSelectorBgColor.rawValue:
                buildingSelectorBgColor = value
            case ThemeColorKey.buildingSelectorBorderColor.rawValue:
                buildingSelectorBorderColor = value
            case ThemeColorKey.buildingSelectorDisableTextColor.rawValue:
                buildingSelectorDisableTextColor = value
            case ThemeColorKey.buildingSelectorDisableBgColor.rawValue:
                buildingSelectorDisableBgColor = value
            case ThemeColorKey.buildingSelectorDisableBorderColor.rawValue:
                buildingSelectorDisableBorderColor = value
            default: break
            }
        }
    }
}

// 枚举定义
@objc public enum ThemeFontKey: Int {
    case fontHeading1
    case fontHeading2
    case fontBody1
    case fontCaption
    case fontTitleLabel
}

@objcMembers public class ThemeFontConfiguration: NSObject {
    // 定义字体大小属性，支持默认值
    public var fontHeading1: CGFloat = 20
    public var fontHeading2: CGFloat = 15
    public var fontBody1: CGFloat = 13
    public var fontCaption: CGFloat = 13
    public var fontTitleLabel: CGFloat = 17
    
    public override init() {
        super.init()
    }
    
    // 支持局部初始化：用于Swift的版本
    public init(overrides: [PartialKeyPath<ThemeFontConfiguration>: CGFloat]) {
        super.init()
        for (keyPath, value) in overrides {
            switch keyPath {
            case \.fontHeading1: fontHeading1 = value
            case \.fontHeading2: fontHeading2 = value
            case \.fontBody1: fontBody1 = value
            case \.fontCaption: fontCaption = value
            case \.fontTitleLabel: fontTitleLabel = value
            default: break
            }
        }
    }
    
    // 支持局部初始化：通过字典传入属性名称和值
    @objc public func setOverrides(with fontValues: [NSNumber: NSNumber]) {
        for (key, value) in fontValues {
            switch key.intValue {  // 使用 `intValue` 获取枚举的原始值
            case ThemeFontKey.fontHeading1.rawValue:
                fontHeading1 = CGFloat(value.floatValue)
            case ThemeFontKey.fontHeading2.rawValue:
                fontHeading2 = CGFloat(value.floatValue)
            case ThemeFontKey.fontBody1.rawValue:
                fontBody1 = CGFloat(value.floatValue)
            case ThemeFontKey.fontCaption.rawValue:
                fontCaption = CGFloat(value.floatValue)
            case ThemeFontKey.fontTitleLabel.rawValue:
                fontTitleLabel = CGFloat(value.floatValue)
            default:
                break
            }
        }
    }
}


// 枚举定义
@objc public enum ThemeCornerKey: Int {
    case buttonShapeCorner
    case imageShapeCorner
    case searchBarShapeCorner
    case bottomSheetShapeCorner
}
 
@objcMembers public class ThemeCornerConfiguration: NSObject {
    // 定义圆角大小属性，支持默认值
    public var buttonShapeCorner: CGFloat = 8
    public var imageShapeCorner: CGFloat = 4
    public var searchBarShapeCorner: CGFloat = 10
    public var bottomSheetShapeCorner: CGFloat = 10
    
    public override init() {
        super.init()
    }
    
    // 支持局部初始化：用于Swift的版本
    public init(overrides: [PartialKeyPath<ThemeCornerConfiguration>: CGFloat]) {
        super.init()
        for (keyPath, value) in overrides {
            switch keyPath {
            case \.buttonShapeCorner: buttonShapeCorner = value
            case \.imageShapeCorner: imageShapeCorner = value
            case \.searchBarShapeCorner: searchBarShapeCorner = value
            case \.bottomSheetShapeCorner: bottomSheetShapeCorner = value
            default: break
            }
        }
    }
    
    // 支持局部初始化：通过字典传入属性名称和值
    @objc public func setOverrides(with cornerRadiusValues: [NSNumber: NSNumber]) {
        for (key, value) in cornerRadiusValues {
            switch key.intValue {  // 使用 `intValue` 获取枚举的原始值
            case ThemeCornerKey.buttonShapeCorner.rawValue:
                buttonShapeCorner = CGFloat(value.floatValue)
            case ThemeCornerKey.imageShapeCorner.rawValue:
                imageShapeCorner = CGFloat(value.floatValue)
            case ThemeCornerKey.searchBarShapeCorner.rawValue:
                searchBarShapeCorner = CGFloat(value.floatValue)
            case ThemeCornerKey.bottomSheetShapeCorner.rawValue:
                bottomSheetShapeCorner = CGFloat(value.floatValue)
            default:
                break
            }
        }
    }
}
