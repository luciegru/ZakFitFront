//
//  DayButton.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 01/12/2025.
//

import SwiftUI

// MARK: - Day Button
struct DayButton: View {
    let date: Date
    let isSelected: Bool
    let activityType: ActivityType
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date).capitalized
    }
    
    private var dayNumber: String {
        let calendar = Calendar.current
        return "\(calendar.component(.day, from: date))"
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayName)
                .font(.system(size: 12))
                .foregroundColor(.white)
            
            Text(dayNumber)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(activityType != .none ? .black : .white)
                .frame(width: 45, height: 55)
                .background(activityType.color)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isToday ? Color.customYellow : (isSelected ? Color.white : Color.clear), lineWidth: 3)
                )
        }
    }
}

#Preview {
//    DayButton()
}
