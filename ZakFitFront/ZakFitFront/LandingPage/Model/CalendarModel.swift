//
//  CalendarModel.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 30/11/2025.
//

import Foundation
import SwiftUI

enum ActivityType {
    case none
    case meal
    case workout
    case both
    
    var color: Color {
        switch self {
        case .none: return Color.gray.opacity(0.3)
        case .meal: return Color.customLightYellow
        case .workout: return Color.customLightPurple
        case .both: return Color.customLightBlue
        }
    }
}

struct DayActivity: Identifiable {
    let id = UUID()
    let date: Date
    let type: ActivityType
    let calories: Int
    let mealsCount: Int
    let hasWorkout: Bool
}
