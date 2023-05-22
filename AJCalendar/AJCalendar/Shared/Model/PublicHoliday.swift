//
//  PublicHoliday.swift
//  AJCalendar
//
//  Created by Andrew Ikenna Jones on 5/22/23.
//

import Foundation

struct PublicHoliday: Codable {
    let date: Date?
    let name: String?
}

typealias HolidayNames = [Date : String]
