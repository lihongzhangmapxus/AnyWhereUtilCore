//
//  UILabel+AutoFont.swift
//  DropInUISDK
//
//  Created by chenghao guo on 2022/5/17.
//  Copyright © 2022 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel {
    // 只设置linespace
    func setAttributed(_ text: String?, lineSpacing: CGFloat) {
        guard let str = text else {
            self.attributedText = nil
            return
        }

        let rang = NSRange.init(location: 0, length: str.count)
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.addParagraphStyle(lineSpacing: lineSpacing, range: rang)
        self.attributedText = attributedString
    }
}
