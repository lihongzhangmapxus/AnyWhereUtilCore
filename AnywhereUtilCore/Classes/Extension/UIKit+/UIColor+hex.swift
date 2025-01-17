//
//  UIColor+hex.swift
//  vip
//
//  Created by chenghao guo on 2021/12/30.
//

import UIKit

/**
 *  设置16进制颜色:
 *  可识别类型
 *  1:有#
 *  2:没有#
 *  3:含有0X
 */
public extension UIColor {
    class func hexColor(_ hexadecimal: String) -> UIColor {
        var cstr = hexadecimal.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if cstr.length < 6 {
            return UIColor.clear
        }
        if cstr.hasPrefix("0x") {
            cstr = cstr.substring(from: 2) as NSString
        }
        if cstr.hasPrefix("#") {
            cstr = cstr.substring(from: 1) as NSString
        }
        if cstr.length != 6 {
            return UIColor.clear
        }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        // r
        let rStr = cstr.substring(with: range)
        // g
        range.location = 2
        let gStr = cstr.substring(with: range)
        // b
        range.location = 4
        let bStr = cstr.substring(with: range)
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rStr).scanHexInt32(&r)
        Scanner.init(string: gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)
        return UIColor.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }

    /// UIColor 转 UIImage
    /// - Parameter size: size
    /// - Returns: UIColor 转 UIImage
    func asImage(_ size: CGSize) -> UIImage? {
        var resultImage: UIImage?
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)

        guard let context = UIGraphicsGetCurrentContext() else {
            return resultImage
        }

        context.setFillColor(self.cgColor)
        context.fill(rect)
        resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    class func color(gradientColors colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint, endPoint: CGPoint, frame: CGRect) -> UIColor? {
        let layer = self.colorGradient(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint, frame: frame)
        UIGraphicsBeginImageContext(layer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            return UIColor(patternImage: image)
        }
        return nil
    }
    
    class func colorGradient(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint, endPoint: CGPoint, frame: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        var refreshColors: [CGColor] = []
        layer.frame = frame
        if let l = locations {
            layer.locations = l
        }
        colors.forEach { c in
            refreshColors.append(c.cgColor)
        }
        layer.colors = refreshColors
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        return layer
    }
}
