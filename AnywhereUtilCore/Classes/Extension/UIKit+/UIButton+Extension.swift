//
//  UIButton+Extension.swift
//  DropInUISDK
//
//  Created by mapxus on 2023/10/12.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit

/*
枚举 设置 图片的位置
*/
public enum ButtonImagePosition: Int {
    case imageTop = 0
    case imageLeft
    case imageBottom
    case imageRight
}

public extension UIButton {
    /**
     type ：image 的位置
     Space ：图片文字之间的间距
     */
    
    /**
     设置按钮的图片和文字的位置及间距
     
     - Parameters:
     - type: 图片的位置（上、左、下、右）
     - space: 图片和文字之间的间距
     */
    
    func setImagePosition(type: ButtonImagePosition, Space space: CGFloat) {
        guard let imageView = self.imageView, let titleLabel = self.titleLabel else {
            return
        }
        
        self.layoutIfNeeded() // 确保布局已完成
        
        let imageWidth = imageView.frame.width
        let imageHeight = imageView.frame.height
        let labelWidth = titleLabel.intrinsicContentSize.width
        let labelHeight = titleLabel.intrinsicContentSize.height
        
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        switch type {
        case .imageTop:
            imageEdgeInsets = UIEdgeInsets(
                top: -labelHeight - space / 2.0,
                left: 0,
                bottom: 0,
                right: -labelWidth
            )
            labelEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -imageWidth,
                bottom: -imageHeight - space / 2.0,
                right: 0
            )
            
        case .imageLeft:
            imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -space / 2.0,
                bottom: 0,
                right: space / 2.0
            )
            labelEdgeInsets = UIEdgeInsets(
                top: 0,
                left: space / 2.0,
                bottom: 0,
                right: -space / 2.0
            )
            
        case .imageBottom:
            imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: -labelHeight - space / 2.0,
                right: -labelWidth
            )
            labelEdgeInsets = UIEdgeInsets(
                top: -imageHeight - space / 2.0,
                left: -imageWidth,
                bottom: 0,
                right: 0
            )
            
        case .imageRight:
            imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: labelWidth + space / 2.0,
                bottom: 0,
                right: -labelWidth - space / 2.0
            )
            labelEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -imageWidth - space / 2.0,
                bottom: 0,
                right: imageWidth + space / 2.0
            )
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}


public extension UIButton {
    private enum AssociatedKeys {
        static var activityIndicatorView: Void?
        static var activityIndicatorEnabled: Void?
        static var activityIndicatorColor: Void?
    }

    private(set) var activityIndicatorView: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicatorView) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicatorView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    var activityIndicatorEnabled: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicatorEnabled) as? Bool ?? false
        }
        set {
            ensureActivityIndicator()
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicatorEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            toggleActivityIndicator()
        }
    }

    var activityIndicatorColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicatorColor) as? UIColor ?? .white
        }
        set {
            ensureActivityIndicator()
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicatorColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            toggleActivityIndicator()
        }
    }

    private func ensureActivityIndicator() {
        guard activityIndicatorView == nil else { return }

        let activityIndicatorView: UIActivityIndicatorView
        if #available(iOS 13, *) {
            activityIndicatorView = UIActivityIndicatorView(style: .medium)
        } else {
            activityIndicatorView = UIActivityIndicatorView(style: .white)
        }
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .white
        addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicatorView.rightAnchor.constraint(equalTo: titleLabel!.rightAnchor, constant: 25)
        ])

        self.activityIndicatorView = activityIndicatorView
    }

    private func toggleActivityIndicator() {
        isUserInteractionEnabled = !activityIndicatorEnabled
        
        if !activityIndicatorEnabled {
            activityIndicatorView?.stopAnimating()
        }

        if self.activityIndicatorEnabled {
            self.activityIndicatorView?.startAnimating()
            activityIndicatorView?.color = activityIndicatorColor
        }
    }
}
