//
//  FormDatePicker.swift
//  AJCalendar
//
//  Created by Andrew Ikenna Jones on 5/22/23.
//

import SwiftUI
import Combine

struct FormDatePicker: View {
    @StateObject var viewModel: Self.ViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("\(viewModel.getSelectedDate())")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .bold))
                
                Spacer()
                
                Button {
                    viewModel.showModel.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .tint(.black)
                }
            }
            .frame(height: 25)
            
            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color.gray)
                .cornerRadius(1, corners: .allCorners)
                .padding(.top, -5)
            
        }
        .frame(maxWidth: .infinity)
        .fullScreenCover(isPresented:  $viewModel.showModel, content: {
            ZStack(alignment: .bottom) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.showModel = false
                    }

                DatePickerView(viewModel: DatePickerView.ViewModel(), showModel: $viewModel.showModel, selectedDate: $viewModel.selectedDate, selectedMonth: $viewModel.selectedMonth, holidays: $viewModel.holidays)
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                   
            }
            .ignoresSafeArea()
            .padding(.bottom, 20)
            .background(TransparentBackground())
        })
    }
}

struct TransparentBackground: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

