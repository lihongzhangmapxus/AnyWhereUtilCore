//
//  String+Extesion.swift
//  DropInUISDK
//
//  Created by mapxus on 2023/6/7.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit
import Foundation

public extension String {
    /// 正则匹配
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - text: 原字符
    /// - Returns: 匹配后的数组字符串
    func matchesForRegexInText(regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = self as NSString
            let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            return results.map {
                nsString.substring(with: $0.range(at: 0))
            }
        } catch {
            return []
        }
    }

    /// 日期字符串转化为Date类型
    ///
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - dateFormat: 格式化样式，默认为“yyyy-MM-dd HH:mm:ss”
    /// - Returns: Date类型
    func stringConvertDate(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter.init()
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        return date
    }

    func convertLocaleIdentifierToMonth(with monthNumber: Int, monthFormat: String = "MMM") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: self)
        dateFormatter.dateFormat = monthFormat
        let dateComponents = DateComponents(month: monthNumber)
        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else {
            return nil
        }
        return dateFormatter.string(from: date)
    }
 

}

public extension String {
    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.height)
    }

    func widthForComment(font: UIFont, height: CGFloat = 15) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }

    // 只设置linespace
    func getAttributed(lineSpacing: CGFloat) -> NSMutableAttributedString? {
        
        let rang = NSRange.init(location: 0, length: self.count)
        let attributedString = NSMutableAttributedString(string: self)
        
        attributedString.addParagraphStyle(lineSpacing: lineSpacing, range: rang)
        return attributedString
    }

    func calculateTextMaxHeight(font: UIFont, maxWidth: CGFloat, maxNumberOfLines: Int) -> CGFloat {
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let boundingRect = self.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude), options: options, context: nil)

        let numberOfLines = Int(ceil(boundingRect.height / font.lineHeight))
        let actualNumberOfLines = min(numberOfLines, maxNumberOfLines)
        let truncatedHeight = CGFloat(actualNumberOfLines) * font.lineHeight

        return truncatedHeight
    }
}

public extension String {
    // remove tags
    func stripHtmlTags() -> String {
        let htmlTagPattern = "<[^>]+>"
        let regex = try? NSRegularExpression(pattern: htmlTagPattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: self.utf16.count)
        let htmlLessString = regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
        return htmlLessString ?? self
    }

    /// 处理<p> 标签 行距
    /// - Parameter lineSpacing: 普通标签行距
    /// - Parameter pTagLineSpacing: p 标签行距
    /// - Returns:
    func htmlPTagsToAttributedString(lineSpacing: CGFloat = 40.0, pTagLineSpacing: CGFloat = 10.0) -> NSAttributedString? {
        let htmlstring = addLineHeightToParagraphTag(in: self, lineSpacing: pTagLineSpacing)
        let modifiedFont = String(format: "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(15); line-height: %fpx;\">%@</span>", lineSpacing, htmlstring)

        guard let data = modifiedFont.data(using: .utf8) else {
            return nil
        }
        let attributedString: NSMutableAttributedString
        do {
            attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error)
            return nil
        }
        return attributedString
    }

    /// 利用正则给 p 标签添加行距
    /// - Parameter html: html
    /// - Returns:
    func addLineHeightToParagraphTag(in html: String, lineSpacing: CGFloat = 10.0) -> String {
        do {
            let style = String(format: "$1 style=\"line-height: %fpx;\"$2$3$4", lineSpacing)
            let regex = try NSRegularExpression(pattern: "(<p[^>]*)(>)(.*?)(</p>)", options: .caseInsensitive)
            let modifiedHtml = regex.stringByReplacingMatches(in: html, options: [], range: NSRange(location: 0, length: html.count), withTemplate: style)
            return modifiedHtml
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
            return html
        }
    }
}

public extension String {
    /// "yyyy-M-d" -> "d MMM yyy"
    func convertDateFormat(dateFormat: String = "yyyy-MM-dd", newdateFormat: String = "yyyy/MM/dd") -> String {
        let oldDateFormat = DateFormatter()
        oldDateFormat.dateFormat = dateFormat
        guard let oldDate = oldDateFormat.date(from: self) else {
            return ""
        }

        let newDateFormat = DateFormatter()
        newDateFormat.dateFormat = newdateFormat
        return newDateFormat.string(from: oldDate)
    }

    /// 将 "HH:mm:ss" 格式的字符串转换为 "HH:mm" 或 "HH:mm:ss" 格式
    ///
    /// - Returns: 转换后的字符串
    func convertTimeFormat() -> String {
        let components = self.split(separator: ":")
        guard components.count == 3 else {
            return self
        }

        // 如果秒数为 "00"，则返回 "HH:mm" 格式的字符串
        if components[2] == "00" {
            return "\(components[0]):\(components[1])"
        }

        return self
    }
}


public extension String {
    func parsingToken() -> [String: Any]? {
        let textArr = self.components(separatedBy: ".")
        if textArr.count > 2 {
            var claims = textArr[1]

            // JWT is not padded with =, pad it if necessary
            let paddedLength = claims.count + (4 - (claims.count % 4)) % 4
            claims = claims.padding(toLength: paddedLength, withPad: "=", startingAt: 0)

            if let claimsData = Data(base64Encoded: claims, options: .ignoreUnknownCharacters) {
                do {
                    let json = try JSONSerialization.jsonObject(with: claimsData, options: []) as? [String: Any]
                    if let json = json {
                        return json
                    }
                } catch {
                    return nil
                }
            }
        }
        return nil
    }

    func decodeNumberFromDic(_ dic: [String: Any], key: String) -> NSNumber? {
        if let temp = dic[key] {
            if let tempString = temp as? String {
                return NSNumber(value: Double(tempString) ?? 0.0)
            } else if let tempNumber = temp as? NSNumber {
                return tempNumber
            }
        }
        return nil
    }
}

public extension String {
    
    static var projectName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    var asURL: URL? {
        URL(string: self)
    }

}

public extension String {
    /*
     let str = "abc_abc"
     if let firstChar = str.first {
         let modifiedStr = String(firstChar).uppercased() + str.dropFirst()
         print(modifiedStr) // 输出 "Abc_abc"
     }
     */
    var formatPOICategory: String {
        let components = self.components(separatedBy: ".")
        // 处理Unspecified的情况
        if self.contains("unspecified") {
            return components.first?.capitalized ?? ""
        }
        // 处理3级类别的情况
        if components.count >= 3 {
            let secondLevel = components[1].capitalized
            let firstLevel = components[2].capitalized
            return "\(secondLevel)・\(firstLevel)"
        }
        // 处理2个或以上类别的情况
        if components.count >= 2 {
            let firstCategory = components[0].capitalized
            var secondLevel = components[1]
            if let firstChar = secondLevel.first {
                let modifiedStr = String(firstChar).uppercased() + secondLevel.dropFirst()
                secondLevel = modifiedStr
            }
            var otherCategories = ""

            if components.count > 2 {
                otherCategories = components[2..<components.count].map { $0.capitalized }.joined(separator: " ")
            }
            if otherCategories.isEmpty {
                return "\(secondLevel)・\(firstCategory)"
            } else {
                return "\(secondLevel)・\(firstCategory) \(otherCategories)"
            }
        }
        return self
    }
}

public extension String {
    /// Convert a time zone identifier (e.g., "Asia/Hong_Kong") to a time zone abbreviation (e.g., "HKT").
    func toTimeZoneAbbreviation() -> String? {
        guard let timeZone = TimeZone(identifier: self) else {
            return nil
        }
        return timeZone.abbreviation(for: Date())
    }

    func toTimeZoneAbbreviationUTC() -> String? {
        guard let timeZone = TimeZone(identifier: self) else {
            return nil
        }
        // 获取当前时区的秒偏移量，并转换为小时数
        let secondsFromGMT = timeZone.secondsFromGMT(for: Date())
        let hours = secondsFromGMT / 3600
        
        let sign = hours >= 0 ? "+" : "-"
        let formattedHours = String(format: "%d", abs(hours))

        // 如果分钟部分为 00 则省略分钟显示
        return "UTC\(sign)\(formattedHours)"
    }

    /// Find the time zone abbreviation (e.g., "HKT") for a given time zone identifier (e.g., "Asia/Hong_Kong")
    func findTimeZoneAbbreviation() -> String? {
        // Get the abbreviation dictionary: [abbreviation: timeZoneIdentifier]
        let abbreviationDict = TimeZone.abbreviationDictionary
        for (abbreviation, identifier) in abbreviationDict {
            if identifier == self {
                return abbreviation
            }
        }
        return nil
    }
}
