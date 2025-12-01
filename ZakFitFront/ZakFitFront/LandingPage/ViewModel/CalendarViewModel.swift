//
//  CalendarViewModel.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 30/11/2025.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var currentMonth: Date = Date()
    @Published var activities: [Date: DayActivity] = [:]
    
    private var tapTimer: Timer?
    private var tapCount = 0
    
    // Charge les données depuis tes ViewModels
    func loadActivities(meals: [Meal], userAPs: [AP]) {
        var activitiesDict: [Date: DayActivity] = [:]
        let calendar = Calendar.current
        
        // Group meals par date
        let mealsByDate = Dictionary(grouping: meals) { meal in
            calendar.startOfDay(for: meal.date)
        }

        // Group userAPs par date
        let apsByDate = Dictionary(grouping: userAPs) { ap in
            calendar.startOfDay(for: ap.date) 
        }

        // Combine toutes les dates uniques
        let allDates = Set(mealsByDate.keys).union(Set(apsByDate.keys))
        
        // Pour chaque date, crée un DayActivity
        for date in allDates {
            let hasMeals = mealsByDate[date] != nil
            let hasWorkout = apsByDate[date] != nil
            
            // Détermine le type
            let activityType: ActivityType
            if hasMeals && hasWorkout {
                activityType = .both
            } else if hasMeals {
                activityType = .meal
            } else if hasWorkout {
                activityType = .workout
            } else {
                activityType = .none
            }
            
            // Calcule les calories (total des repas)
            let totalCalories = mealsByDate[date]?.reduce(0) { $0 + $1.totalCal } ?? 0
            let mealsCount = mealsByDate[date]?.count ?? 0
            
            activitiesDict[date] = DayActivity(
                date: date,
                type: activityType,
                calories: totalCalories,
                mealsCount: mealsCount,
                hasWorkout: hasWorkout
            )
        }
        
        self.activities = activitiesDict
    }
    
    func handleDayTap(_ date: Date, onDoubleTap: @escaping () -> Void) {
        tapCount += 1
        
        if tapCount == 1 {
            selectedDate = date
            tapTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
                self?.tapCount = 0
            }
        } else if tapCount == 2 {
            tapTimer?.invalidate()
            tapCount = 0
            onDoubleTap()
        }
    }
    
    func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    func getActivity(for date: Date) -> DayActivity? {
        let normalizedDate = Calendar.current.startOfDay(for: date)
        return activities[normalizedDate]
    }
}

