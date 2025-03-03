//
//  UIView+Extension.swift
//  DropInUISDK
//
//  Created by Mapxus on 2023/12/1.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit

public extension UIView {
    func setCornerRadius(_ radius: CGFloat, maskedCorners: CACornerMask) {
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
    }

    func addShadow(shadowColor: UIColor, shadowOpacity: CGFloat, shadowRadius: CGFloat, shadowOffset: CGSize) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = Float(shadowOpacity)
    }
    
    /// 为视图顶部添加阴影，并设置顶部两个角的圆角
    func addTopShadowAndCorners(shadowColor: UIColor,
                                shadowOpacity: CGFloat,
                                shadowRadius: CGFloat,
                                shadowOffset: CGSize,
                                cornerRadius: CGFloat,
                                roundedRect: CGRect = .zero,
                                byRoundingCorners corners: UIRectCorner = [.topLeft, .topRight]) {
        layer.sublayers?.filter { $0.name == "topShadowLayer" }.forEach { $0.removeFromSuperlayer() }
        
        // 创建 CAShapeLayer 作为阴影图层
        let shadowLayer = CAShapeLayer()
        shadowLayer.name = "topShadowLayer"
        shadowLayer.fillColor = UIColor.white.cgColor // 背景颜色
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOpacity = Float(shadowOpacity)
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.shadowOffset = shadowOffset
        
        // 创建圆角路径，只为 .topLeft 和 .topRight 设置圆角
        let roundedPath = UIBezierPath(
            roundedRect: roundedRect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        shadowLayer.path = roundedPath.cgPath
        
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.width, height: 10))
        shadowLayer.shadowPath = shadowPath.cgPath
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    /// 根据锚点设置视图的位置并支持偏移
    /// - Parameters:
    ///   - anchorPoint: 锚点位置，例如 `[0, 1]` 表示左下角，`[1, 0]` 表示右上角
    ///   - size: 视图的宽高
    ///   - offset: 偏移量，基于锚点计算后的偏移
    func setPosition(withAnchorPoint anchorPoint: CGPoint, size: CGSize, offset: CGPoint = .zero) {
        guard let superview = self.superview else {
            assertionFailure("View must have a superview")
            return
        }
        
        // 设置 frame
        self.frame = CGRect(origin: .zero, size: size)
        
        // 根据锚点和偏移量计算中心点
        let xPosition = superview.bounds.width * anchorPoint.x - size.width * anchorPoint.x + offset.x
        let yPosition = superview.bounds.height * anchorPoint.y - size.height * anchorPoint.y + offset.y
        
        self.center = CGPoint(x: xPosition, y: yPosition)
    }
}

public extension UIView {
    func addSmoothFloatingAnimation(duration: CFTimeInterval = 2.0, amplitude: CGFloat = 10) {
        if layer.animation(forKey: "smoothFloat") != nil { return }
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = center.y - amplitude
        animation.toValue = center.y + amplitude
        animation.duration = duration
        animation.autoreverses = true
        animation.repeatCount = .greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(animation, forKey: "smoothFloat")
    }
    
    func removeSmoothFloatingAnimation() {
        layer.removeAnimation(forKey: "smoothFloat")
    }
}
