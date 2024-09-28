//
//  Date+Extensions.swift
//  mango
//
//  Created by Leo on 29.07.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import Foundation

extension Date {
    func time(hour: String) -> Date? {
        guard let hour = Int(hour) else { return nil }
        guard let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian) else { return nil }
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        return gregorianCalendar.date(from: dateComponents)
    }

    var getMonth: String {
        let components = Calendar.current.dateComponents([.month], from: self)
        let month = components.month ?? 0
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]
        if months.count >= month - 2 {
            return months[month - 1]
        } else {
           return months[0]
        }
    }
    
    var getFullMonth: String {
        let components = Calendar.current.dateComponents([.month], from: self)
        let month = components.month ?? 0
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        if months.count >= month - 2 {
            return months[month - 1]
        } else {
           return months[0]
        }
    }

    var getLongDayFromDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMMM"
        return dateFormatter.string(from: self)
    }
    
    var getYearWeekDayMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMMM YYYY"
        return dateFormatter.string(from: self)
    }
    
    var getLongDayAndHourFromDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMMM, h:mm a "
        return dateFormatter.string(from: self)
    }
    
    var getDayFromDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }

    var getDayFromDateWithSuffix: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let day = Int(dateFormatter.string(from: self)) ?? 0
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let dayWithSuffix = formatter.string(from: NSNumber(value: day)) ?? ""
        
        return dayWithSuffix
    }

    var getHourFromDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }
    
    var getWeek: String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        let comp = Calendar.current.component(.weekday, from: self)
        return weekdays[comp - 1]
    }
    
    var getShortWeek: String {
        let weekdays = [
            "Sun.",
            "Mon.",
            "Tue.",
            "Wed.",
            "Thu.",
            "Fri.",
            "Sat."
        ]
        let comp = Calendar.current.component(.weekday, from: self)
        return weekdays[comp - 1]
    }

    var dateComponentLeftFromNow: DateComponents? {
        let component = Calendar
            .current
            .dateComponents([.year,
                             .month,
                             .day,
                             .hour,
                             .minute],
                            from: .now,
                            to: self)
        return component
    }

    var timeLeftIsCritical: (String, Bool) {
        var isCritical = true
        if let component = dateComponentLeftFromNow {
            var left = ""
            if let year = component.year, year > 0 {
                left += "\(year) y\(year > 1 ? "s" : "")"
                isCritical = false
            }
            
            if let month = component.month, month > 0 {
                left += "\(left.isEmpty ? "" : ", ")\(month) m\(month > 1 ? "s" : "")"
                isCritical = false
            }
            
            if let day = component.day, day > 0 {
                left += "\(left.isEmpty ? "" : ", ")\(day) d\(day > 1 ? "s" : "")"
                isCritical = false
            }
            
            if let hour = component.hour, hour > 0 {
                left += "\(left.isEmpty ? "" : ", ")\(hour) h\(hour > 1 ? "s" : "")"
                isCritical = false
            }
            
            if let minute = component.minute, minute > 0 {
                left += "\(left.isEmpty ? "" : ", ")\(minute) min\(minute > 1 ? "s" : "")"
            }
            
            if left.isEmpty {
                return ("Expired", true)
            }
            
            return (left + " \(isCritical ? "left" : "remaining")", isCritical)
        }
        return ("Expired", isCritical)
    }
    
    var expiresInIsCritical: (String, Bool) {
        var isCritical = true
        if let component = dateComponentLeftFromNow {
            var left = ""
            if let year = component.year, year > 0 {
                left += "\(year) y\(year > 1 ? "s" : "")"
                isCritical = false
            }
            
            if let month = component.month, month > 0 {
                left += "\(left.isEmpty ? "" : ", ")\(month) m\(month > 1 ? "s" : "")"
                isCritical = false
            }
            
            if let day = component.day, day > 0 {
                left += "\(left.isEmpty ? "" : ", ")\(day) d\(day > 1 ? "s" : "")"
                isCritical = false
            }
            
            if let hour = component.hour, hour > 0 {
                left += "\(left.isEmpty ? "" : ", ")\(hour) h\(hour > 1 ? "s" : "")"
                isCritical = false
            }
            
            if let minute = component.minute, minute > 0 {
                left += "\(left.isEmpty ? "" : ", ")\(minute) min\(minute > 1 ? "s" : "")"
            }
            
            if left.isEmpty {
                return ("Your request expired", true)
            }
            
            return ("Your request expires in " + left, isCritical)
        }
        return ("Your request expired", isCritical)
    }

    var isDateInToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    func addTimeToDate(hours: Int, minutes: Int, isPM: Bool) -> (date: Date?, reset: Bool) {
        guard let currentDate = self.removeHoursAndMinutes else { return (date: nil, reset: false) }
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        // Define the components to add
        var components = DateComponents()
        components.minute = minutes
        let hours24 = hours == 12 &&  isPM ?   12 :
                      hours == 12 && !isPM ?    0 :
                                     !isPM ? hours : hours + 12
        components.hour = hours24
        guard let newDate = calendar.date(byAdding: components, to: currentDate) else { return (date: nil, reset: false)  }
        guard let approvedDate = Date.now.addMinutesToDate(minutes: 5) else { return (date: nil, reset: false)  }

        if newDate < approvedDate {
            return (date: approvedDate, reset: true)
        }

        return (date: newDate, reset: false)
    }
    
    fileprivate var removeHoursAndMinutes: Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)

        // Set the hour and minute components to zero
        components.hour = 0
        components.minute = 0

        // Get the date without hours and minutes
       return calendar.date(from: components)
    }

    var isValidTroovDate: Bool {
        if let validDate = Date.now.addMinutesToDate(minutes: 5) {
           return self > validDate
        }
        return false
    }

    var validTroovStartTimeDuringCreation: Date {
        if self.isValidTroovDate == true {
            return self
        } else {
            return Date.now.addMinutesToDate(minutes: 5) ?? .now
        }
    }

    func addMinutesToDate(minutes: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)
    }

    func addHoursToDate(hours: Int) -> Date? {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)
    }

    func adding(years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self) ?? .now
    }

    func adding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self) ?? .now
    }

    var age: Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: now)
        let age = ageComponents.year!
        return age
    }

    var removeTime: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        
        
        return calendar.date(from: components)
    }
}
