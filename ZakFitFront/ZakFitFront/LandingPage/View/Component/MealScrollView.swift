//
//  MealScrollView.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 01/12/2025.
//

import SwiftUI

struct MealScrollView: View {
    var selectedDay: Date
    @Environment(MealViewModel.self) var mealVM
    @Environment(MealFoodViewModel.self) var mealFoodVM
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(mealVM.mealList) { meal in
                    if Calendar.current.isDate(meal.date, inSameDayAs: selectedDay) {
                        MealCard(meal: meal, selectedDay: selectedDay)
                            .environment(mealFoodVM)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    MealScrollView(selectedDay: Date()).environment(MealViewModel()).environment(MealFoodViewModel())
}
