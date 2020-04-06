//
//  DateUtils.swift
//  TranslateApp
//
//  Created by Nik on 05.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation

class DateUtils {
    static public func dateFormatterTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: DateUtils.clearSeconds(date))
    }

    static public func clearSeconds(_ date: Date) -> Date {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return Calendar.current.date(from: dateComponents)!
    }
    
    static public func getReadableDate(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Сегодня " + setDateToFormat(date, toFormat: "HH:mm")!
        } else if Calendar.current.isDateInYesterday(date) {
            return "Вчера " + setDateToFormat(date, toFormat: "HH:mm")!
        } else {
            let dateYear = DateUtils.getParametersCount(date).year!
            let todayYear = DateUtils.getParametersCount(Date()).year!
            let format = dateYear == todayYear ? "MMM d HH:mm" : "MMM d HH:mm, yyyy"
            
            return setDateToFormat(date, toFormat: format)!
        }
    }
    
    static public func setDateToFormat(_ date: Date, toFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: toFormat, options: 0, locale:  NSLocale.current)
        dateFormatter.timeZone = NSTimeZone.system
        
        return dateFormatter.string(from: date)
    }
    
    static public func getTimeString(_ time: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: time)!
    }
    
    static public func getParametersCount(_ date: Date) -> DateComponents {
        return Calendar.current.dateComponents([.day, .month, .year, .weekOfYear, .hour, .minute, .second, .nanosecond], from: date)
    }
}


