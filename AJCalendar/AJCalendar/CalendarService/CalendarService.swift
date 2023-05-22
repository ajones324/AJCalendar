//
//  CalendarService.swift
//  AJCalendar
//
//  Created by Andrew Ikenna Jones on 5/22/23.
//

import Foundation
import Combine

enum CountryCode {
    static let US: String = "US"
}

enum CalendarAPI  {
    static let base: String = "https://date.nager.at/api/v3"
    enum EndPoints {
        static let publicHolidays = "/publicholidays"
    }
}

protocol CalendarService_Protocol {
    func getPublicHolidays(countryCode: String, year: String) async throws -> [PublicHoliday]
}

final class CalendarService: CalendarService_Protocol {
    static let shared: CalendarService = CalendarService()
    private let jsonDecoder: JSONDecoder
    
    init() {
        self.jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    enum CalendarServiceError: Error {
        case invalidURL
    }
    
    func getPublicHolidays(countryCode: String = CountryCode.US, year: String) async throws -> [PublicHoliday] {
        guard let url = URL(string: String(format: "%@%@/%@/%@", CalendarAPI.base, CalendarAPI.EndPoints.publicHolidays, year, countryCode)) else {
            throw CalendarServiceError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)

        return try self.jsonDecoder.decode([PublicHoliday].self, from: data)
    }
}

