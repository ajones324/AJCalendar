//
//  FormDatePicker+ViewModel.swift
//  AJCalendar
//
//  Created by Andrew Ikenna Jones on 5/22/23.
//
import SwiftUI
import Combine

extension FormDatePicker {
    @MainActor class ViewModel: ObservableObject {
        @Published var showModel: Bool = false
        @Published var selectedDate: Date? = Date()
        @Published var selectedMonth = Date()
        let dateFormatter = getDateFormaterWith(format: "MMMM dd, yyyy")
        
        @Published var holidays: [PublicHoliday]?

        init(showModel: Bool = false, selectedDate: Date? = nil, selectedMonth: Date = Date(), holidays: [PublicHoliday] = []) {
             self.showModel = showModel
             self.selectedDate = selectedDate
             self.selectedMonth = selectedMonth
             self.holidays = holidays
        }
        
        func getSelectedDate() -> String {
            return dateFormatter.string(from: selectedDate ?? Date())
        }
    }
}

func getDateFormaterWith(format: String = "MM/dd/yyyy") -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter
}
