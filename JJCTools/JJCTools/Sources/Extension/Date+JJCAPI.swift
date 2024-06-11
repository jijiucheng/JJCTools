//
//  Date+JJCAPI.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/11/25.
//

import Foundation

// MARK: - 月份转换格式信息
public struct JJCMonthInfo {
    public var num: String = ""        // 数字样式
    public var enAll: String = ""      // 英文全称
    public var en: String = ""         // 英文简称
    public var cn: String = ""         // 中文样式
}

// MARK: - 时间信息
public struct JJCTimeInfo {
    public var origin: String = ""         // 原始样式时间，未处理时区
    public var timestamp: Double = 0       // 时间戳（秒级）
    public var time: String = ""           // 格式化时间样式时间
    public var year: String = ""           // 年
    public var month = JJCMonthInfo()      // 月
    public var day: String = ""            // 日
    public var hour: String = ""           // 时
    public var minute: String = ""         // 分
    public var second: String = ""         // 秒
}


// MARK: - Date 获取时间信息
extension Date {
    /// Date - 获取时间格式化对象 DateFormatter（默认：yyyy-MM-dd HH:mm:ss）
    public static func jjc_dateFormatter(_ dateFormat: String? = nil) -> DateFormatter {
        let dateFormatter = DateFormatter()
        if let newDateFormat = dateFormat {
            dateFormatter.dateFormat = newDateFormat
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return dateFormatter
    }
    
    /// Date - 获取指定时间时间戳
    public static func jjc_timestamp(_ date: Date? = nil) -> Double {
        return (date ?? Date()).timeIntervalSince1970
    }
    
    /// Date - 获取指定时间字符串
    public static func jjc_timeString(_ date: Date? = nil, dateFormat: String? = nil) -> String {
        let dateFormatter = Date.jjc_dateFormatter(dateFormat)
        return dateFormatter.string(from: date ?? Date())
    }
    
    /// Date - 获取指定时间信息
    public static func jjc_timeInfo(_ date: Date? = nil, dateFormat: String? = nil) -> JJCTimeInfo {
        let tempDate = date ?? Date()
        var timeInfo = JJCTimeInfo()
        timeInfo.origin = "\(tempDate)"
        timeInfo.timestamp = Date.jjc_timestamp(tempDate)
        timeInfo.time = Date.jjc_timeString(tempDate, dateFormat: dateFormat)
        let timeString = timeInfo.time
        timeInfo.year = timeString.jjc_subRange(byStart: 0, 3)
        timeInfo.month = Date.jjc_toMonth(timeString.jjc_subRange(byStart: 5, 6))
        timeInfo.day = timeString.jjc_subRange(byStart: 8, 9)
        timeInfo.hour = timeString.jjc_subRange(byStart: 11, 12)
        timeInfo.minute = timeString.jjc_subRange(byStart: 14, 15)
        timeInfo.second = timeString.jjc_subRange(byStart: 17, 18)
        return timeInfo
    }
    
    /// Date - 获取当前时间戳
    public static func jjc_curTimestamp() -> Double {
        return Date.jjc_timestamp(Date())
    }
    
    /// Date - 获取当前时间（默认：yyyy-MM-dd HH:mm:ss）
    public static func jjc_curTimeString(_ dateFormat: String? = nil) -> String {
        return Date.jjc_timeString(Date(), dateFormat: dateFormat)
    }
    
    /// Date - 获取当前时间信息
    public static func jjc_curTimeInfo(_ dateFormat: String? = nil) -> JJCTimeInfo {
        return Date.jjc_timeInfo(Date(), dateFormat: dateFormat)
    }
}

// MARK: - Date 时间转换
extension Date {
    /// Date - 时间戳转时间字符串
    /// - timestamp：秒级
    /// - dateFormat：格式化样式（默认：yyyy-MM-dd HH:mm:ss）
    public static func jjc_toTimeString(byTimestamp timestamp: Double, dateFormat: String? = nil) -> String {
        var targetString = ""
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = Date.jjc_dateFormatter(dateFormat)
        targetString = dateFormatter.string(from: date)
        return targetString
    }
    
    /// Date - 日期转时间字符串
    /// - dateFormat：格式化样式（默认：yyyy-MM-dd HH:mm:ss）
    public func jjc_toTimeString(_ dateFormat: String? = nil) -> String {
        var targetString = ""
        let dateFormatter = Date.jjc_dateFormatter(dateFormat)
        targetString = dateFormatter.string(from: self)
        return targetString
    }
    
    /// Date - 日期转时间戳
    public func jjc_toTimestamp() -> Double {
        return self.timeIntervalSince1970
    }
    
    /// Date - 月历转数字（英文全、英文简、中文、数字）
    public static func jjc_toMonth(_ month: String) -> JJCMonthInfo {
        var monthInfo = JJCMonthInfo()
        let enAllMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        let enMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let cnMonths = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
        let numMonths = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
        for (index, _) in enAllMonths.enumerated() {
            if month == enAllMonths[index] || month == enMonths[index] || month == cnMonths[index] || Int(month) == Int(numMonths[index]) {
                monthInfo.enAll = enAllMonths[index]
                monthInfo.en = enMonths[index]
                monthInfo.cn = cnMonths[index]
                monthInfo.num = numMonths[index]
                break
            }
        }
        return monthInfo
    }
}
