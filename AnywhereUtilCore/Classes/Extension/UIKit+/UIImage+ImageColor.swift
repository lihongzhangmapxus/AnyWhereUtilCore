//
//  UIImage+ImageColor.swift
//  DropInUISDK
//
//  Created by mapxus on 2023/1/9.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit
import AFNetworking

public extension UIImage {
    /// 实例方法 转换UIImage 颜色
    /// - Parameters:
    ///   - tintColor: 转换的颜色
    /// - Returns: 被转换颜色的Image
    func imageWith(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // 生成两边半圆中间矩形的图片
    static func roundedRectImage(with color: UIColor = .white,
                                 text: String,
                                 textColor: UIColor = .black,
                                 triangleColor: UIColor = .blue,
                                 font: UIFont = .systemFont(ofSize: 16),
                                 padding: CGFloat = 10,
                                 borderWidth: CGFloat = 3,
                                 gradientBorderColors: [UIColor]) -> UIImage? {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        let textSize = text.size(withAttributes: attributes)
        
        // 计算图片的高度和宽度，确保两端半圆和中间矩形部分，以及倒三角形显示
        let triangleHeight: CGFloat = 5  // 三角形的高度
        let imageHeight = textSize.height + padding
        let imageWidth = textSize.width + imageHeight
        let gradientWidth = imageWidth + borderWidth
        let gradientHeight = imageHeight + borderWidth

        // 绘制渐变背景
        let cornerRadius = gradientHeight / 2
        UIGraphicsBeginImageContextWithOptions(CGSize(width: gradientWidth, height: gradientHeight + triangleHeight), false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // 使用嵌套的渐变绘制方法
        if let gradientImage = gradientImageWithHalfCirclesAndRectangle(size: CGSize(width: gradientWidth, height: gradientHeight),
                                                                        colors: gradientBorderColors,
                                                                        cornerRadius: cornerRadius) {
            // 将渐变背景绘制到上下文中
            context.draw(gradientImage.cgImage!, in: CGRect(x: 0, y: 0, width: gradientWidth, height: gradientHeight))
        }

        // 绘制内部填充矩形区域
        let rectPath = UIBezierPath(roundedRect: CGRect(x: borderWidth, y: borderWidth, width: imageWidth - borderWidth, height: imageHeight - borderWidth),
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        context.setFillColor(color.cgColor)
        rectPath.fill()

        // 绘制倒三角形
        let triangleWidth: CGFloat = triangleHeight * 2 // 三角形的宽度
        let triangleOriginX = (gradientWidth - triangleWidth) / 2  // 确保三角形在中心
        let triangleOriginY = gradientHeight // 起始点从 gradientHeight 开始

        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: triangleOriginX, y: triangleOriginY)) // 三角形左顶点
        trianglePath.addLine(to: CGPoint(x: triangleOriginX + triangleWidth, y: triangleOriginY)) // 三角形右顶点
        trianglePath.addLine(to: CGPoint(x: triangleOriginX + triangleWidth / 2, y: gradientHeight + triangleHeight)) // 三角形底边中点
        trianglePath.close()

        context.setFillColor(triangleColor.cgColor) // 使用传入的三角形颜色
        trianglePath.fill()

        // 绘制文本
        let textRect = CGRect(
            x: (imageWidth - textSize.width) / 2,
            y: (gradientHeight - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor
        ]
        text.draw(in: textRect, withAttributes: textAttributes)
        
        // 获取合成图片
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage
    }

    /// 生成带有渐变色的左右两边为半圆，中间为矩形的 UIImage，底部中心有倒三角形
    /// - Parameters:
    ///   - size: 生成图片的尺寸
    ///   - colors: 渐变的颜色数组
    ///   - cornerRadius: 半圆的半径（决定左右半圆的大小）
    ///   - triangleColor: 倒三角形的颜色
    ///   - triangleHeight: 倒三角形的高度
    /// - Returns: 带有渐变效果的 UIImage
    static func gradientImageWithHalfCirclesAndRectangle(size: CGSize, colors: [UIColor], cornerRadius: CGFloat) -> UIImage? {
        // 开始图形上下文
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // 定义路径
        let path = UIBezierPath()
        // 左半圆
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: size.height / 2),
                    radius: cornerRadius,
                    startAngle: .pi / 2,
                    endAngle: .pi * 1.5,
                    clockwise: true)
        
        // 上边的矩形部分
        path.addLine(to: CGPoint(x: size.width - cornerRadius, y: 0))
        // 右半圆
        path.addArc(withCenter: CGPoint(x: size.width - cornerRadius, y: size.height / 2),
                    radius: cornerRadius,
                    startAngle: .pi * 1.5,
                    endAngle: .pi / 2,
                    clockwise: true)
        
        // 下边的矩形部分
        path.addLine(to: CGPoint(x: cornerRadius, y: size.height))
        path.close()
        
        // 剪切上下文，限制绘制范围
        context.addPath(path.cgPath)
        context.clip()
        
        // 创建渐变
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map { $0.cgColor } as CFArray
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: nil) else { return nil }
        
        let startPoint = CGPoint(x: 0, y: size.height / 2)
        let endPoint = CGPoint(x: size.width, y: size.height / 2)
        // 绘制渐变
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage
    }

    /// 两个UIImage 合成
    /// - Parameters:
    ///   - topImage: 顶层Image
    ///   - bottomImageRect: 底层Image Rect
    ///   - topImageRect: 顶层 Image Rect
    /// - Returns: 合成后的UIImage
    func combine(topImage: UIImage, bottomImageRect: CGRect, topImageRect: CGRect, text: String? = nil, attributes: [NSAttributedString.Key: Any]? = nil, textRect: CGRect? = nil) -> UIImage? {
        let size = CGSize(width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContext(size)
        var drawSize = bottomImageRect
        if let r = textRect {
            var ld_frame: CGRect = drawSize
            ld_frame.size.width = r.origin.x + r.size.width + 30
            drawSize = ld_frame
        }
        self.draw(in: drawSize)

        if let str = text, let rect = textRect {
            let string = NSString(string: str)
            string.draw(in: rect, withAttributes: attributes)
        }
        topImage.draw(in: topImageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    // 组合两个UIImage：上下居中合并，宽度取决于最宽的图片
    static func combineImage(topImage: UIImage, bottomImage: UIImage) -> UIImage {
        // 计算最终合成图片的高度
        let totalHeight = topImage.size.height + bottomImage.size.height
        
        // 取最宽的图片作为合成后的宽度
        let width = max(topImage.size.width, bottomImage.size.width)
        
        // 开始一个新的图形上下文
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: totalHeight), false, 0.0)
        
        // 将 topImage 绘制到上下文的顶部
        topImage.draw(in: CGRect(x: (width - topImage.size.width) / 2, y: 0, width: topImage.size.width, height: topImage.size.height))
        
        // 将 bottomImage 绘制到上下文的底部
        bottomImage.draw(in: CGRect(x: (width - bottomImage.size.width) / 2, y: topImage.size.height, width: bottomImage.size.width, height: bottomImage.size.height))
        
        // 从当前上下文获取合成后的新图片
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束图形上下文
        UIGraphicsEndImageContext()
        
        return combinedImage ?? UIImage()
    }

    /// UIImage 设置圆角
    /// - Parameters:
    ///   - byRoundingCorners: 方位
    ///   - cornerRadi: 圆角
    /// - Returns: 设置圆角的UIImage
    func roundImage(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadi: CGFloat) -> UIImage? {
        return roundImage(byRoundingCorners: byRoundingCorners, cornerRadii: CGSize(width: cornerRadi, height: cornerRadi))
    }
    func roundImage(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadii: CGSize) -> UIImage? {
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        context?.setShouldAntialias(true)
        let bezierPath = UIBezierPath(roundedRect: imageRect,
                                      byRoundingCorners: byRoundingCorners,
                                      cornerRadii: cornerRadii)
        bezierPath.close()
        bezierPath.addClip()
        self.draw(in: imageRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func scaledToSize(_ newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func merge(withText text: String, font: UIFont, textColor: UIColor, textOrigin: CGPoint) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero)
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let textSize = text.size(withAttributes: attributes)
        // 计算文本的起始位置
        let textRect = CGRect(
            x: size.width * textOrigin.x - textSize.width / 2,
            y: size.height * textOrigin.y - textSize.height / 2,
            width: textSize.width,
            height: textSize.height
        )
        text.draw(in: textRect, withAttributes: attributes)
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return mergedImage
    }
    
    static var imageCache = NSCache<NSString, UIImage>()
    static func image(from text: String, font: UIFont = UIFont.systemFont(ofSize: 14), maxWidth: CGFloat = 140, numberOfLines: Int = 3) -> UIImage?
    {
        // 检查是否已经缓存该图像
        if let cachedImage = imageCache.object(forKey: text as NSString) {
            return cachedImage
        }
        // 创建一个初步的 label
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.font = font
        label.text = text
        label.textAlignment = .center
        
        // 设置最大宽度
        label.frame.size.width = maxWidth
        label.sizeToFit()
        
        // 如果文本的高度超出，限制为指定的最大行数
        let maxHeight = font.lineHeight * CGFloat(numberOfLines)
        let adjustedHeight = min(label.frame.size.height, maxHeight)
        label.frame.size.height = adjustedHeight
        
        // 使用 UIGraphics开始绘图
        UIGraphicsBeginImageContextWithOptions(label.frame.size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        // 绘制背景色
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(CGRect(origin: .zero, size: label.frame.size))
        
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: font,
//            .foregroundColor: UIColor.black,  // 文本颜色
//            .strokeColor: UIColor.white,  // 描边颜色
//            .strokeWidth: 2.0  // 描边宽度，负值表示描边在外侧
//        ]
//        let attributedString = NSAttributedString(string: text, attributes: attributes)
//        // 绘制带有描边的文本
//        attributedString.draw(in: label.bounds)
        
        // 绘制文本
        label.layer.render(in: context)
        
        // 获取图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 缓存图像
        if let image = image {
            imageCache.setObject(image, forKey: text as NSString)
        }
        return image
    }

    class func getSdkImage(named: String, in bundle: Bundle? = .main) -> UIImage? {
        return UIImage(named: named, in: bundle, compatibleWith: nil)
    }
}

public extension UIImage {
    func applyGaussianBlur(with blurAmount: Double, cacheKey: String, complete: ((UIImage?) -> Void)?) {
        guard let url = cacheKey.asURL else {
            complete?(self)
            return
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let downloader = AFImageDownloader.defaultInstance()
        downloader.sessionManager.responseSerializer.acceptableContentTypes = ["image/jpeg", "image/jpg", "image/png"]
        downloader.downloadImage(for: request) { req, resp, image in
            guard let ciImage = CIImage(image: self) else {
                complete?(self)
                return
            }
            let filter = CIFilter(name: "CIGaussianBlur")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
            
            guard let outputImage = filter?.outputImage else {
                complete?(self)
                return
            }
            let context = CIContext(options: nil)
            guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else {
                complete?(self)
                return
            }
            let blurredImage = UIImage(cgImage: cgImage)
            complete?(blurredImage)
        } failure: { req, resp, error in
            complete?(self)
        }
    }
}

extension UIImage {
    struct SaveTimeStruct {
        static var time: Void?
    }
    
    var time: Date? {
        set {
            objc_setAssociatedObject(self, &SaveTimeStruct.time, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &SaveTimeStruct.time) as? Date
        }
    }
    
}
