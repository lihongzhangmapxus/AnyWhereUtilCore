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
        // 去除空格和换行符并转换为大写
        var cstr = hexadecimal.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // 检查字符串长度
        guard cstr.count >= 6 else { return UIColor.clear }
        
        // 去掉前缀 "0x" 或 "#"
        if cstr.hasPrefix("0X") || cstr.hasPrefix("0x") {
            cstr.removeFirst(2)
        } else if cstr.hasPrefix("#") {
            cstr.removeFirst()
        }
        
        // 确保字符串长度为 6
        guard cstr.count == 6 else { return UIColor.clear }
        
        // 转换为 RGB 值
        let r, g, b: CGFloat
        let scanner = Scanner(string: cstr)
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
            g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
            b = CGFloat(hexNumber & 0x0000FF) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: 1.0)
        }
        
        return UIColor.clear
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
