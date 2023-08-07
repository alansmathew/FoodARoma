//
//  DateExtenction.swift
//  FoodARoma
//
//  Created by alan on 2023-08-01.
//

import Foundation
extension Date {
    // converting api responce time and date to string formate
    static func convertToDateTimeString(dateStr: String) -> String? {
        if dateStr.isEmpty {return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateStr)!
        var convertedLocalTime = String()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MM-dd-yyyy h:mm aa"
        convertedLocalTime = dateFormatter.string(from: date)
        print("convertedLocalDateandTime--",convertedLocalTime)
        return convertedLocalTime
    }
    // converting api responce time and date to string formate
    static func convertToDateString(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: dateStr) {
            var convertedLocalTime = String()
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = "MMM dd, yyyy"
            convertedLocalTime = dateFormatter.string(from: date)
            print("convertedLocalDateandTime--",convertedLocalTime)
            return convertedLocalTime
        } else {
            return ""
        }
    }
    static func convertToDateStringWithyyyy(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: dateStr) {
            var convertedLocalTime = String()
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            convertedLocalTime = dateFormatter.string(from: date)
            print("convertedLocalDateandTime--",convertedLocalTime)
            return convertedLocalTime
        } else {
            return ""
        }
    }
    static func getTodaysDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter.string(from: Date())
    }
    static func getTodaysDateWithyyyy() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.string(from: Date())
    }
    // converting api responce date string and date to string formate
    static func convertDateToDateString2(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        var convertedLocalTime = String()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MM-dd-yyyy"
        convertedLocalTime = dateFormatter.string(from: date)
        print("convertedLocalDateandTime--",convertedLocalTime)
        return convertedLocalTime
    }
    // converting api responce date string and date to string formate
    static func convertDateToDateString(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        var convertedLocalTime = String()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        convertedLocalTime = dateFormatter.string(from: date)
        print("convertedLocalDateandTime--",convertedLocalTime)
        return convertedLocalTime
    }
    // converting api responce date string and time to string formate
    static func convertDateToTimeString(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        var convertedLocalTime = String()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "HH:mm" // for 12 hour "h:mm aa"
        convertedLocalTime = dateFormatter.string(from: date)
        print("convertedLocalDateandTime--",convertedLocalTime)
        return convertedLocalTime
    }
    static func convertDateToTimeString12Hrs(dateStr: String) -> String? {
        if dateStr.isEmpty {return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateStr)!
        var convertedLocalTime = String()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "h:mm aa"
        convertedLocalTime = dateFormatter.string(from: date)
        print("convertedLocalDateandTime--",convertedLocalTime)
        return convertedLocalTime
    }
    static func convertStringToZFormat(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: dateStr)!
        var convertedLocalTime = String()
        //        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = .current
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        convertedLocalTime = dateFormatter.string(from: date)
        print("convertedLocalDateandTime--",convertedLocalTime)
        return convertedLocalTime
    }
    static func convertZFormatStringToDate(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = .current
        let date = dateFormatter.date(from: dateStr)!
        return date
    }
    static func convertZFormatStringToDateLocale(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone =  NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = .current
        let date = dateFormatter.date(from: dateStr)!
        return date
    }
    func currentTimeInMiliseconds() -> Int! {
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = .current
        let date = dateFormatter.date(from: dateFormatter.string(from: currentDate as Date))
        let nowDouble = date!.timeIntervalSince1970
        return Int(nowDouble*1000)
    }
    // Adding minutes to Date
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        return end - start
    }
    static func intervalDiff(ofComponent comp: Calendar.Component, fromDate date: Date, toDate toD: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: toD) else { return 0 }
        print("####\(start)###\(date)")
        print("%%%%\(end)%%%%\(toD)")
        var diff = 0
        diff = end - start
        return diff
    }
    static func convertSecondsIntoFormattedTime(interval: String) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        let formattedString = formatter.string(from: TimeInterval(interval)!)!
        print(formattedString)
        return formattedString
    }
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func convertTo12HourFormat(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        
        return nil // Return nil if the input date string is invalid
    }
    
}
extension TimeZone { // to get timezone
    func offsetInHours() -> String {
        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tzHr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tzHr
    }
    //    print(TimeZone.current.offsetInHours()) // output is "+05:30"
    func timeZoneOffsetInHours() -> Int {
        let seconds = secondsFromGMT()
        let hours = seconds/3600
        return hours
    }
    func timeZoneOffsetInMinutes() -> Int {
        let seconds = secondsFromGMT()
        let minutes = abs(seconds / 60)
        return minutes
    }
}
