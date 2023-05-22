//
//  Date+Custom.swift
//  AJCalendar
//
//  Created by Andrew Ikenna Jones on 5/22/23.
//

import Foundation

extension Date {
    func distanceDays(from date: Date, calendar: Calendar = .current) -> Int {
     let days1 = calendar.component(.day, from: self)
     let days2 = calendar.component(.day, from: date)
     return days1 - days2
    }

    func isSameDay(with date: Date) -> Bool {
     distanceDays(from: date) == 0
    }
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    static func numberOfSameDays(from fromDays: [Date],  withDays: [Date]) -> Int {
        if withDays.isEmpty { return 0 }
        var nums = 0
        for withDay in withDays {
            for fromDay in fromDays {
                if fromDay.isSameDay(with: withDay) {
                    nums += 1
                    break
                }
            }
        }
        return nums
    }
 }
