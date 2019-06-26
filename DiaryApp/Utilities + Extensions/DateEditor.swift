//
//  DateEditor.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/11/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import Foundation

/// Class for editing dates correctly to present to user
class DateEditor {
    static let dateFormatter = DateFormatter()
    
    /// Function to return a string in format of June 25th, 2019
    static func monthDayYearFrom(_ date: Date) -> String? {
        dateFormatter.dateFormat = "d"
        let formattedDay = daySuffixFor(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        return [month, " ", formattedDay, ",", " ", year].joined()
    }
    
    /// Function to return a string in format of Tuesday 25th June
    static func weekdayDayMonthFrom(_ date: Date) -> String? {
        dateFormatter.dateFormat = "d"
        let formattedDay = daySuffixFor(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: date)
        return [weekday, " ", formattedDay, " ", month].joined()
    }
    
    /// Function to return a date for the second day of the month passed in
    static func startOfMonthFrom(_ date: Date) -> Date? {
        let calendarComponents = Calendar.current.dateComponents([.year, .month], from: date)
        let firstOfMonth = Calendar.current.date(from: calendarComponents) ?? Date()
        return Calendar.current.date(byAdding: .day, value: 2, to: firstOfMonth)
    }
    
    /// Function to return a string in format of June 2019
    static func monthYearFrom(_ date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    // A function to return the correct calendar suffix for a string Int passed in
    static func daySuffixFor(_ string: String?) -> String {
        guard let string = string, let number = Int(string) else {
            return ""
        }
        switch number {
        case 1, 21, 31:
            return [string, "st"].joined()
        case 2, 22:
            return [string, "nd"].joined()
        case 3, 23:
            return [string, "rd"].joined()
        default:
            return [string, "th"].joined()
        }
    }
}
