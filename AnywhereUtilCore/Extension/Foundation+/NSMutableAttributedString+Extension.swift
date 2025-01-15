//
//  NSAttributedString+Extension.swift
//  MCComponentExtension_Example
//
//  Created by 满聪 on 2019/6/26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public extension NSMutableAttributedString {
    /// 设置字体大小
    func addFont(_ font: UIFont, on range: NSRange) {
        if self.length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.font: font]
        self.addAttributes(attrs, range: range)
    }

    /// 设置字体颜色
    func addForegroundColor(_ color: UIColor, range: NSRange) {
        if self.length < range.location + range.length {
            return
        }

        let attrs = [NSAttributedString.Key.foregroundColor: color]
        self.addAttributes(attrs, range: range)
    }

    /// 设置字体的背景颜色
    func addBackgroundColor(_ color: UIColor, range: NSRange) {
        if self.length < range.location + range.length {
            return
        }

        let attrs = [NSAttributedString.Key.backgroundColor: color]
        self.addAttributes(attrs, range: range)
    }
    
    /// 字符间距的设置 字符间距 正值间距加宽，负值间距变窄
    func addKern(_ kern: Int, range: NSRange) {
        if self.length < range.location + range.length { return }

        let attrs = [NSAttributedString.Key.kern: kern]
        self.addAttributes(attrs, range: range)
    }
 
    /// 设置字体倾斜度，正值右倾，负值左倾
    func addObliqueness(_ obliqueness: CGFloat, range: NSRange) {
        if self.length < range.location + range.length { return }

        let attrs = [NSAttributedString.Key.obliqueness: obliqueness]
        self.addAttributes(attrs, range: range)
    }

    /// 设置上下偏移量 正数上移，负数下移
    func mc_addBaselineOffset(_ offset: CGFloat, range: NSRange) {
        if self.length < range.location + range.length { return }
        let attrs = [NSAttributedString.Key.baselineOffset: offset]
        self.addAttributes(attrs, range: range)
    }

    /// 设置段落样式，如行间距、缩进等
    /// - Parameters:
    ///   - lineSpacing: 行间距，默认值为 0
    ///   - alignment: 文本对齐方式，默认左对齐
    ///   - headIndent: 段落头部缩进，默认无缩进
    ///   - tailIndent: 段落尾部缩进，默认无缩进
    ///   - firstLineHeadIndent: 首行缩进，默认无缩进
    ///   - paragraphSpacing: 段落后间距，默认 0
    ///   - paragraphSpacingBefore: 段落前间距，默认 0
    ///   - range: 应用样式的范围，默认为整个文本
    func addParagraphStyle(
        lineSpacing: CGFloat = 0,
        alignment: NSTextAlignment = .left,
        headIndent: CGFloat = 0,
        tailIndent: CGFloat = 0,
        firstLineHeadIndent: CGFloat = 0,
        paragraphSpacing: CGFloat = 0,
        paragraphSpacingBefore: CGFloat = 0,
        range: NSRange? = nil
    ) {
        let effectiveRange = range ?? NSRange(location: 0, length: self.length)
        guard self.length >= effectiveRange.location + effectiveRange.length else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = tailIndent
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore

        self.addAttribute(.paragraphStyle, value: paragraphStyle, range: effectiveRange)
    }
    
}


public extension NSMutableAttributedString {
    /// 插入富文本图片, 图片前后加入  " "  作为间距
    /// - Parameters:
    ///   - image: 图片
    ///   - imageFrame: 图片 Rect
    ///   - index: 下标
    func addTextAttachment(image: UIImage?, imageFrame: CGRect, atIndex index: Int) {
        let attachment = NSTextAttachment.init()
        attachment.image = image
        attachment.bounds = imageFrame
        // 在图片前后添加间距
        let spaceString = " "
        self.append(NSAttributedString(string: spaceString))
        let att = NSAttributedString(attachment: attachment)
        self.insert(att, at: index + spaceString.count)
        self.append(NSAttributedString(string: spaceString))
    }
    
    /// 计算NSAttributedString的宽度
    func width(forHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(boundingBox.width)
    }
    
    func height(forWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(boundingBox.height)
    }
}
