//
//  ContentView.swift
//  AJCalendar
//
//  Created by Andrew Ikenna Jones on 5/22/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var datePickerViewModel = FormDatePicker.ViewModel()

    var body: some View {
        VStack {
            FormDatePicker(viewModel: datePickerViewModel)
        }
        .padding()
        .onAppear {
            Task {
                do {
                    datePickerViewModel.holidays = try await CalendarService.shared.getPublicHolidays(year: "2023")
                } catch {
                    print(error)
                }
            }
        }
    }
}

