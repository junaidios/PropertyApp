//
//  NSDate.swift
//  TattooPlanet
//
//  Created by Muhammad Rashid on 01/12/2016.
//  Copyright © 2016 3pc. All rights reserved.
//

import Foundation

struct DateFormat {
    static let shortDateFormat = "dd.MM.yyyy"
    static let fullDateFormat  = "HH:mm dd.MM.yyyy"
    static let onlyTimeFormat  = "HH a"
    static let exactTimeFormat = "HH:mm"
    static let onlyDay         = "EEEE"
    static let dayOfMonth      = "dd MMM"
    static let dayOfYear       = "dd MMM, yyyy"
    static let monthOfYear     = "MMMM yyyy"
    static let apiDate         = "yyyy-MM-dd"
    static let fbApiDate       = "MM/dd/yyyy"
    static let apiTime         = "HH:mm:ss"
    static let apiDateTime     = "yyyy-MM-dd HH:mm:ss"
    static let apiPostDateTime = "dd.MM.yyyy HH:mm:ss"
    static let apiDateTimeZone = "yyyy-MM-dd HH:mm:ss ZZZ"
}

public extension Date {
    
    func toLocalTime() -> Date {
        
        let timeZone = NSTimeZone.local
        let seconds : TimeInterval = Double(timeZone.secondsFromGMT(for: self))
        let localDate = Date(timeInterval: seconds, since: self)
        return localDate
    }
    
    func userAge() -> Int {
        
        let units:NSCalendar.Unit = [.year]
        
        let calendar = NSCalendar.current as NSCalendar
        calendar.timeZone = NSTimeZone.default
        calendar.locale = NSLocale.current
        let components = calendar.components(units, from: self, to: Date(), options: NSCalendar.Options.wrapComponents)
        
        let years       = components.year

        return years!;
    }
    
    var currentYear : Int {
        
        let dateFormat = DateFormatter()
        
        dateFormat.dateFormat = "YYYY"
        
        return Int(dateFormat.string(from: self)) ?? 0;
    }
    
    func dateStringOfElapsedTime() -> String {
        
        var timeSatmp = ""
        
        let units:NSCalendar.Unit = [.second, .minute, .hour, .day, .month, .year, .weekday, .weekOfYear]
        
        let calendar = NSCalendar.current as NSCalendar
        calendar.timeZone = NSTimeZone.default
        calendar.locale = NSLocale.current
        let components = calendar.components(units, from: self, to: Date(), options: NSCalendar.Options.wrapComponents)
        
        let years       = components.year
        let months      = components.month
        let weekofYear  = components.weekOfYear
        let days        = components.day
        let hours       = components.hour
        let minutes     = components.minute
        let seconds     = components.second
        
        if let years = years, years >= 1 {
            if years == 1 {
                timeSatmp = "1yr ago"
            }
            else {
                timeSatmp = "\(years)yr ago"
            }
        }
        else if let months = months, months >= 1 {
            if months == 1 {
                timeSatmp = "1mo ago"
            }
            else {
                timeSatmp = "\(months)mo ago"
            }
        }
        else if let weekofYear = weekofYear, weekofYear >= 1 {
            if weekofYear == 1 {
                timeSatmp = "1w ago"
            }
            else {
                timeSatmp = "\(weekofYear)w ago"
            }
        }
        else if let days = days, days >= 1 {
            if days == 1 {
                timeSatmp = "1d ago"
            }
            else {
                timeSatmp = "\(days)d ago"
            }
        }
        else if let hours = hours, hours >= 1 {
            if hours == 1 {
                timeSatmp = "1h ago"
            }
            else {
                timeSatmp = "\(hours)h ago"
            }
        }
        else if let minutes = minutes, minutes >= 1 {
            if minutes == 1 {
                timeSatmp = "1m ago"
            }
            else {
                timeSatmp = "\(minutes)m ago"
            }
        }
        else if let seconds = seconds, seconds > 5 {
            timeSatmp = "\(seconds)s ago"
        }
        else {
            timeSatmp = "Just Now"
        }
        
        return timeSatmp
    }
    
    static func convertFBDateString(dateString: String) -> Date {
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = DateFormat.fbApiDate
        let convertedDate = dateFormatter.date(from: dateString)
        return convertedDate!
    }
    
    static func convertString(dateString: String) -> Date {
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = DateFormat.apiDateTime
        let convertedDate = dateFormatter.date(from: dateString)
        return convertedDate!
    }
    
    func dataStringForExactFormat() -> String {
        
        let dateFormatter = Foundation.DateFormatter()
//        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        dateFormatter.dateFormat = DateFormat.exactTimeFormat
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
    
    var apiDateTime : String {
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        dateFormatter.dateFormat = DateFormat.apiDateTime
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
}


extension DateFormatter {
    
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat =  dateFormat
    }
}

extension Date {
    
    struct Formatter {
        static let dateMMDDYYYY = DateFormatter(dateFormat: "MM/dd/yyyy")
        static let dateYYYYMMDD = DateFormatter(dateFormat: "yyyy-MM-dd")
        static let dateYYYYMMDD_HHMMSS = DateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")
        static let dayOfYear = DateFormatter(dateFormat: DateFormat.dayOfYear)
        static let dateDMMM = DateFormatter(dateFormat: "d/MMM")
        static let timeHmm = DateFormatter(dateFormat: "HH:mm")
        static let timeHHmmss = DateFormatter(dateFormat: "HH:mm:ss")
    }
    
    func tpTimeAfterHours(hours: Double) -> String {
        let date = self.addingTimeInterval(60.0 * 60.0 * hours);
        return Formatter.timeHmm.string(from: date)
    }
    
    var htDateFormate: String {
        return Formatter.dateMMDDYYYY.string(from: self)
    }
    var htDOBFormate: String {
        return Formatter.dateYYYYMMDD.string(from: self)
    }
    
    var beeDateFormate: String {
        return Formatter.dayOfYear.string(from: self)
    }
    
    var htFilterDateFormate: String {
        return Formatter.dateYYYYMMDD_HHMMSS.string(from: self)
    }
    
    var dMMMDateFormate: String {
        return Formatter.dateDMMM.string(from: self)
    }
    
    var htTimeFormate: String {
        return Formatter.timeHmm.string(from: self)
    }
    
    var tpTime_In_HH_MM_SS: String {
        return Formatter.timeHHmmss.string(from: self)
    }
}
