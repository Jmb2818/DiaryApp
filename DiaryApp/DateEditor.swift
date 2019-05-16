//
//  DateEditor.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/11/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import Foundation

class DateEditor {
    let dateFormatter = DateFormatter()
    
    
    func monthDayYearFrom(_ date: Date) -> String? {
        dateFormatter.dateFormat = "d"
        let formattedDay = daySuffixFor(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        return [month, " ", formattedDay, ",", " ", year].joined()
    }
    
    func weekdayDayMonthFrom(_ date: Date) -> String? {
        dateFormatter.dateFormat = "d"
        let formattedDay = daySuffixFor(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: date)
        return [weekday, " ", formattedDay, " ", month].joined()
    }
    
    
    func daySuffixFor(_ string: String?) -> String {
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
