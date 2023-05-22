//
//  DatePickerView.swift
//  AJCalendar
//
//  Created by Andrew Ikenna Jones on 5/22/23.
//

import SwiftUI
import Combine

struct DatePickerView: View {
    @StateObject var viewModel: Self.ViewModel
    @Binding var showModel: Bool
    @Binding var selectedDate: Date?
    @Binding var selectedMonth: Date
    @Binding var holidays: [PublicHoliday]?
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .frame(width: 25, height: 4)
                .cornerRadius(2)
                .padding(.top, -10)

                
            
            HStack {
                Button {
                    self.selectedMonth = viewModel.calendar.date(byAdding: .month, value: -1, to: self.selectedMonth)!
                } label: {
                    Image(systemName: "backward")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fit)
                        .tint(.black)
                }
                
                Spacer()
                
                Text(viewModel.dateFormatter.string(from: selectedMonth))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    self.selectedMonth = viewModel.calendar.date(byAdding: .month, value: 1, to: self.selectedMonth)!
                }) {
                    Image(systemName: "forward")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fit)
                        .tint(.black)
                }
            }
            .padding(.horizontal , 20)
            
            CalendarView(selectedDate: $selectedDate, selectedMonth: selectedMonth, holidays: $holidays)
            
            
            FormButton(viewModel: viewModel.saveFormButton) {
                showModel.toggle()
                
            }
            .disabled(selectedDate == nil)
        }
        .padding()
    }
}

extension DatePickerView {
    @MainActor class ViewModel: ObservableObject {
        let calendar = Calendar.current
        let dateFormatter = getDateFormaterWith(format: "MMMM yyyy")
        let saveFormButton = FormButton.ViewModel(title: "Save")
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date?
    let selectedMonth: Date
    private let calendar = Calendar.current
    private let dateFormatter = getDateFormaterWith(format: "yyyy-MM-dd")

    @Binding var holidays: [PublicHoliday]?
    
    var body: some View {
        VStack {
            
            calenderWeekDays
            
            calenderDates
            
        }
    }
    
    var calenderWeekDays: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0, alignment: nil), count: 7), spacing: 0) {
            ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                let firstCharacterOfWeekDay: String =  String(weekday.first!)
                Text(firstCharacterOfWeekDay)
                    .font(.system(size: 12, weight: .regular))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
    
    var calenderDates: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: 7), spacing: 10) {
            let weekIndexOfFirstDay = weekIndexOfFirstDayOf(date: selectedMonth)
            let weekIndexOfLastDay = weekIndexOfLastDayOf(date: selectedMonth)
            let numberOfMonthDays = numberOfDaysInMonth(selectedMonth)
            ForEach(1...numberOfMonthDays + weekIndexOfFirstDay + (7 - weekIndexOfLastDay), id: \.self) { dayIndex in
                let displayDay = displayDay(dayIndex: dayIndex, weekIndexOfFirstDay: weekIndexOfFirstDay, weekIndexOfLastDay: weekIndexOfLastDay, numberOfMonthDays: numberOfMonthDays, month: selectedMonth)
                let date = getDateWith(dayIndex: dayIndex, weekIndexOfFirstDay: weekIndexOfFirstDay, numberOfMonthDays: numberOfMonthDays, selectedMonth: selectedMonth)
                let isSelected = selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!)
                let holiday = getHoliday(date: date)
                 
                let displayColor = (holiday != nil) ?  Color.red : Color.black
                VStack {
                    Text(displayDay)
                        .font(Font.system(size: 12, weight: .regular))
                        .foregroundColor(displayColor)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .background(
                            Group {
                                Color(isSelected ? .lightGray : .clear)
                            }
                        )
                        .cornerRadius(isSelected ? 20 : 0, corners: .allCorners)
                        .onTapGesture {
                            self.selectedDate = date
                        }
                    Text(holiday?.name ?? "")
                        .font(Font.system(size: 8, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(displayColor)
                        .opacity(((holiday != nil) && isSelected) ? 1 : 0)
                        .frame(height: 20)
                }
            }
        }
    }
    
    private func getHoliday(date: Date) -> PublicHoliday? {
         guard let holidays = holidays else { return nil }
         for holiday in holidays {
             if holiday.date == date { return holiday}
         }
         return nil
    }
    
    private func isSundayExistingBetween(day1: Date, day2: Date) -> Bool {
        var date = day1
        while date <= day2 {
            date = calendar.date(byAdding: .day, value: 1, to: date)!
            if isSunday(date: date) { return true }
        }
        return false
    }
    
    private func isSunday(date: Date) -> Bool {
        return calendar.component(.weekday, from: date) == 1
    }
}

func isThisMonthDay(dayIndex: Int, weekIndexOfFirstDay: Int, weekIndexOfLastDay: Int, numberOfMonthDays: Int) -> Bool {
    return (dayIndex > weekIndexOfFirstDay) && (dayIndex <= numberOfMonthDays + weekIndexOfFirstDay)
}

func displayDay(dayIndex: Int, weekIndexOfFirstDay: Int, weekIndexOfLastDay: Int, numberOfMonthDays: Int, month: Date) -> String {
    if dayIndex <= weekIndexOfFirstDay {
        return "\(theDayBeforeTheLastDay(before: weekIndexOfFirstDay - dayIndex, month: prevMonth(for: month)))"
    } else if dayIndex > numberOfMonthDays + weekIndexOfFirstDay {
        return "\(dayIndex - numberOfMonthDays - weekIndexOfFirstDay)"
    }
    return "\(dayIndex-weekIndexOfFirstDay)"
}


func numberOfDaysInMonth(_ month: Date) -> Int {
    let calendar = Calendar.current
    guard let range = calendar.range(of: .day, in: .month, for: month) else {
        return 0
    }
    return range.count
}

func getDateWith(dayIndex: Int, weekIndexOfFirstDay: Int, numberOfMonthDays: Int, selectedMonth: Date) -> Date {
    if dayIndex <= weekIndexOfFirstDay {
        let prevMonth = prevMonth(for: selectedMonth)
        let day = theDayBeforeTheLastDay(before: weekIndexOfFirstDay - dayIndex, month: prevMonth)
        return getDateWith(day, in: prevMonth)
        
    } else if dayIndex > numberOfMonthDays + weekIndexOfFirstDay {
        let nextMonth = nextMonth(for: selectedMonth)
        let day = dayIndex - numberOfMonthDays - weekIndexOfFirstDay
        return getDateWith(day, in: nextMonth)
    }
    return getDateWith(dayIndex-weekIndexOfFirstDay, in: selectedMonth)
}

func getDateWith(_ index: Int, in month: Date) -> Date {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day], from: month)
    components.day = index
    return calendar.date(from: components) ?? Date()
}


func weekdayIndex(date: Date) -> Int {
    let calendar = Calendar.current
    return calendar.component(.weekday, from: date)
}

func dayOfMonth(_ date: Date) -> String {
    let calendar = Calendar.current
    return calendar.component(.day, from: date).description
}

func twoDatesMonthAndYearEqual(date1: Date = Date(), date2: Date) -> Bool {
    let calendar = Calendar.current
    let monthAndYear1 = calendar.dateComponents([.month, .year], from: date1)
    let monthAndYear2 = calendar.dateComponents([.month, .year], from: date2)
    return monthAndYear1 == monthAndYear2
}

func theDayBeforeTheLastDay(before: Int, month: Date) -> Int {
    let lastDay = numberOfDaysInMonth(month)
    return lastDay - before
}

func nextMonth(for month: Date) -> Date {
    return Calendar.current.date(byAdding: .month, value: 1, to: month)!
}

func prevMonth(for month: Date) -> Date {
    return Calendar.current.date(byAdding: .month, value: -1, to: month)!
}

func nextDay(for day: Date) -> Date {
    return Calendar.current.date(byAdding: .day, value: 1, to: day)!
}

func prevDay(for day: Date) -> Date {
    return Calendar.current.date(byAdding: .day, value: -1, to: day)!
}

func weekIndexOfFirstDayOf(date: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)
    let firstOfMonth = calendar.date(from: components)!
    let weekDayIndex = calendar.component(.weekday, from: firstOfMonth) - 1
    return weekDayIndex
}

func startOfMonth(month: Date) -> Date {
    return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: month)))!
}

func endOfMonth(month: Date) -> Date {
    return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth(month: month))!
}

func weekIndexOfLastDayOf(date: Date) -> Int {
    let calendar = Calendar.current
    let weekDayIndex = calendar.component(.weekday, from: endOfMonth(month: date))
    return weekDayIndex
}
