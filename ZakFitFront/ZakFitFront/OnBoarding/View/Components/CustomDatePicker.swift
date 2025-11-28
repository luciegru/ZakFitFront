//
//  CustomDatePicker.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 28/11/2025.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var selectedDate: Date

    var body: some View {
        
        HStack(spacing: 5) {
            Text(selectedDate.formatted(.dateTime.day().month().year()))
                .font(.system(size: 15, weight: .semibold))
        
            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .bold))
        }
        .padding(15)
        .foregroundColor(.white)
        .background(RoundedRectangle(cornerRadius: 5, style: .continuous).foregroundColor(.middleGrey))
        .frame(height: 50)

        .overlay {
            DatePicker(selection: $selectedDate, displayedComponents: .date) {}
                .labelsHidden()
                .contentShape(Rectangle())
                .opacity(0.11)             // <<< here
        }

    }
}

