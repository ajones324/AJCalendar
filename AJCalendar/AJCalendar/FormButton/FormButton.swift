//
//  FormButton.swift
//  AJCalendar
//
//  Created by Andrew Ikenna Jones on 5/22/23.
//

import SwiftUI

struct FormButton: View {
    @Environment(\.isEnabled) private var isEnabled
    @StateObject var viewModel: Self.ViewModel
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            if !isEnabled {
                Text(viewModel.title)
                    .font(Font.system(size: 20, weight: .bold))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)
                    .background(Color(.lightGray))
                    .clipShape(RoundedRectangle(cornerRadius: 35))
            } else {
                Text(viewModel.title)
                    .font(Font.system(size: 20, weight: .bold))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)
                    .background(Color(.black))
                    .clipShape(RoundedRectangle(cornerRadius: 35))

            }
        }
    }
}
