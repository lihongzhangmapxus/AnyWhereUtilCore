//
//  Date+Extension.swift
//  DropInUISDK
//
//  Created by mapxus on 2023/2/28.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit
import Foundation

enum Weekday: Int, CaseIterable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    var description: String {
        switch self {
        case .monday: return "星期一"
        case .tuesday: return "星期二"
        case .wednesday: return "星期三"
        case .thursday: return "星期四"
        case .friday: return "星期五"
        case .saturday: return "星期六"
        case .sunday: return "星期日"
        }
    }

    static func fromAbbreviation(_ abbreviation: String) -> Weekday? {
        switch abbreviation {
        case "Mo": return .monday
        case "Tu": return .tuesday
        case "We": return .wednesday
        case "Th": return .thursday
        case "Fr": return .friday
        case "Sa": return .saturday
        case "Su": return .sunday
        default: return nil
        }
    }
}

public extension Date {
    
    // Date格式化
    func toLocaleString(_ localeIdentifier: String = "en-US") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.dateFormat = "M/dd/yyyy, hh:mm:ss a"
        return formatter.string(from: self)
    }
    
    // Date 格式转换 -> String
    func toString(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取当前时间戳
    var timeStampInterval: TimeInterval {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return timeInterval
    }

    ///  判断 startDate, endDate 的时间是否在当前时间内 并日期是否过期
    /// - Parameters:
    ///   - startDate: 开始时间
    ///   - endDate: 结束时间
    /// - Returns:
    func isBetween(startDate: Date, endDate: Date) -> Bool {
        let calendar = Calendar.current
        // 判断时分秒是否在当前时间内
        let currentComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        let startComponents = calendar.dateComponents([.hour, .minute, .second], from: startDate)
        let endComponents = calendar.dateComponents([.hour, .minute, .second], from: endDate)

        if let currentHour = currentComponents.hour, let currentMinute = currentComponents.minute,
           let startHour = startComponents.hour, let startMinute = startComponents.minute,
           let endHour = endComponents.hour, let endMinute = endComponents.minute {
            if currentHour < startHour || (currentHour == startHour && currentMinute < startMinute) || (currentHour == startHour && currentMinute == startMinute) {
                return false
            }
            if currentHour > endHour || (currentHour == endHour && currentMinute > endMinute) || (currentHour == endHour && currentMinute == endMinute) {
                return false
            }
        }
        // 判断日期是否过期
        let currentDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: self))
        let startDateWithoutTime = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: startDate))
        let endDateWithoutTime = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: endDate))

        if let currentDate = currentDate, let startDateWithoutTime = startDateWithoutTime, let endDateWithoutTime = endDateWithoutTime {
            if currentDate < startDateWithoutTime {
                return false
            }
            if currentDate > endDateWithoutTime {
                return false
            }
        }
        return true
    }

    // 获取Date的年月日
    func getYearMonthDayFromDate() -> (Int, Int, Int) {
        let calendar = Calendar.current
        let dateComponets = calendar.dateComponents([Calendar.Component.year,
                                                     Calendar.Component.month,
                                                     Calendar.Component.day], from: self)
        if let y = dateComponets.year, let m = dateComponets.month, let d = dateComponets.day {
            return (y, m, d)
        }
        return (0, 0, 0)
    }

    /// 这个函数用于比较两个日期之间的分钟差是否大于给定的分钟数。
    ///
    /// - Parameters:
    ///   - minutes: 给定的分钟数，用于比较两个日期之间的分钟差。
    ///   - compareData: 需要与当前日期进行比较的日期。
    ///
    /// - Returns: 如果两个日期之间的分钟差大于给定的分钟数，则返回 true，否则返回 false。
    func isMoreThanApart(_ minutes: CGFloat, compareData: Date) -> Bool {
        let date1 = self
        let date2 = compareData

        // 计算两个日期之间的分钟差
        let differenceInMinutes = Calendar.current.dateComponents([.minute], from: date1, to: date2).minute

        // 如果分钟差的绝对值大于给定的分钟数，则返回 true，否则返回 false
        return CGFloat(abs(differenceInMinutes ?? 0)) > minutes
    }

    /// startDate endDate hours 是否在当前时间内
    /// - Parameters:
    ///   - hours: hh:ss
    ///   - startDate: yyyy-mm-dd
    ///   - endDate: yyyy-mm-dd
    /// - Returns: 
    func isWithinHours(hours: String, startDate: String, endDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let start = dateFormatter.date(from: startDate),
              let end = dateFormatter.date(from: endDate) else {
            return false
        }
        let calendar = Calendar.current
        let now = Date()

        if now >= start && now <= end {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            if let startTime = timeFormatter.date(from: hours.components(separatedBy: "-")[0]),
               let endTime = timeFormatter.date(from: hours.components(separatedBy: "-")[1]) {
                let components = calendar.dateComponents([.hour, .minute], from: now)
                if let hour = components.hour, let minute = components.minute,
                   let startHour = calendar.dateComponents([.hour], from: startTime).hour,
                   let endHour = calendar.dateComponents([.hour], from: endTime).hour {
                    if (hour > startHour || (hour == startHour && minute >= 0)) &&
                       (hour < endHour || (hour == endHour && minute <= 0)) {
                        return true
                    }
                }
            }
        }
        return false
    }

    /// 判断当前时间是否在一周7天的某几天固定时间段内
    /// - Parameters:
    ///   - startTime: 开始时间
    ///   - expireTime: 结束时间
    /// - Returns: 是否再内
    func validateWithStartTime(_ startTime: String, expireTime: String) -> Bool {
        let re = isCurrentTimeInRange(startStr: startTime, endStr: expireTime, onDays: ["星期一,星期二,星期三,星期四,星期五,星期六,星期日"])
        return re
    }

    // 判断当前时间是否在某个时间段内
    func judgeDateByStartAndEnd(startStr: String, endStr: String, dateDay: String) -> Bool {
        var today = self

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")   // local属性设置为24小时制

        let todayStr = dateFormatter.string(from: today)

        today = dateFormatter.date(from: todayStr)!  // as Date
        let tempStart = dateFormatter.date(from: startStr)
        let tempEnd = dateFormatter.date(from: endStr)

        // 00:00-24:00
        if startStr == "00:00", endStr == "24:00" {
            return true
        }

        guard let start = tempStart, let end = tempEnd else {
            return false
        }

        let todayDay = getweekDayWithDate()
        if dateDay.contains(todayDay) {
            let orderResult = (start.compare(end))
            switch orderResult {
            case .orderedAscending:// end未过24点
                if ((today.compare(start) == .orderedDescending) && (today.compare(end) == .orderedAscending)) || // 开始时间<当前时间<结束时间
                    ((today.compare(start) == .orderedDescending) && (today.compare(end) == .orderedSame)) || // 开始时间=当前时间<结束时间
                    ((today.compare(start) == .orderedSame) && (today.compare(end) == .orderedAscending)) {
                    return true
                } else {
                    return false
                }
            case .orderedDescending:// end过24点
                if ((today.compare(start) == .orderedDescending) && (today.compare(end) == .orderedDescending)) || // 开始时间<当前时间>结束时间----例如：start 18:00  now 23：00 end 7：00
                    ((today.compare(start) == .orderedAscending) && (today.compare(end) == .orderedAscending)) || // 开始时间>当前时间<结束时间----例如：start 18:00  now 2：00 end 7：00
                    ((today.compare(start) == .orderedSame) && (today.compare(end) == .orderedDescending)) || // 开始时间=当前时间>结束时间----例如：start 18:00  now 18：00 end 7：00
                    ((today.compare(start) == .orderedAscending) && (today.compare(end) == .orderedSame)) {
                    return true
                } else {
                    return false
                }
            default:
                return false
            }
        } else {
            return false
        }
    }

    // 判断当前时间是否在某个时间段内
    func isCurrentTimeInRange(startStr: String, endStr: String, onDays days: [String]) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 设置为24小时制

        // 获取当前时间的字符串表示
        let now = Date()
        let nowStr = dateFormatter.string(from: now)
        guard let nowDate = dateFormatter.date(from: nowStr),
              let start = dateFormatter.date(from: startStr),
              let end = dateFormatter.date(from: endStr) else {
            return false
        }

        // 处理24小时全覆盖的情况
        if startStr == "00:00" && endStr == "24:00" {
            return true
        }

        // 判断时间范围
        if start <= end { // 未跨越午夜
            return (start <= nowDate && nowDate < end)
        } else { // 跨越午夜
            return (nowDate >= start || nowDate < end)
        }
    }

    /// 根据日期获取是星期几
    /// - Parameter date: 日期
    /// - Returns: 星期x
    func getweekDayWithDate() -> String {
        let weekdayIndex = getCurrentWeekDay()
        if let weekday = Weekday(rawValue: weekdayIndex) {
            return weekday.description
        }
        return Weekday(rawValue: 1)!.description
    }

    /// 根据week 英文缩写转换  星期
    /// - Parameter week: week 英文缩写 "Mo", "Tu", "We", "Th" "Fr" ...
    /// - Returns: 星期 Int
    static func getWeekDay(week from: String) -> Int {
        return Weekday.fromAbbreviation(from)?.rawValue ?? Weekday.sunday.rawValue
    }

    /// 根据当前是星期几返回 week缩写
    /// - Returns: week 英文缩写 "Mo", "Tu", "We", "Th" "Fr" ...
    static func getCurrentDay() -> String? {
        let weekdays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        let weekdayIndex = Calendar.current.component(.weekday, from: Date()) - 1
        return weekdays[safe: weekdayIndex]
    }

    /// 获取当前 weekday
    /// - Returns: weekday Int
    func getCurrentWeekDay() -> Int {
        if let weekday = Calendar.current.dateComponents([.weekday], from: self).weekday {
            return (weekday + 5) % 7 + 1
        }
        return 1 // Default to Monday if there is an issue
    }
}
