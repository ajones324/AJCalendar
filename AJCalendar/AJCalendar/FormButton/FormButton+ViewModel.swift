//
//  FormButton+ViewModel.swift
//  AJCalendar
//
//  Created by Andrew Ikenna Jones on 5/22/23.
//

import Combine
import SwiftUI

extension FormButton {
    @MainActor class ViewModel: ObservableObject {
        @Published var title: String

        init(title: String) {
            self.title = title
        }
    }
}
