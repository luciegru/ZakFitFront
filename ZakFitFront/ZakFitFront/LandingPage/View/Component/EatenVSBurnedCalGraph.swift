//
//  EatenVSBurnedCalGraph.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 01/12/2025.
//

import SwiftUI

struct EatenVSBurnedCalGraph: View {
    @Environment(UserAPViewModel.self) var userAPVM
    @Environment(MealViewModel.self) var userMealVM
    var selectedMonth: Date

    
    
    var body: some View {
        
        let APNeeded = userAPVM.APs.filter { $0.date.isInSameMonth(as: selectedMonth) }
        let CalNeeded = userMealVM.mealList.filter { $0.date.isInSameMonth(as: selectedMonth) }
        
        let APCal = APNeeded.reduce(0) { $0 + $1.burnedCal }
        let mealCal = CalNeeded.reduce(0) { $0 + $1.totalCal }
        
        let progress = mealCal > 0 ? min(CGFloat(APCal) / CGFloat(mealCal) * 0.5, 0.5) : 0
        VStack{
            
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .stroke(Color.lightGrey, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 144)
                    .rotationEffect(.degrees(-180))
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(Color.customPink, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 144)
                    .rotationEffect(.degrees(-180))
                
                VStack {
                    Spacer()
                    HStack {
                        Text("Calories brûlées")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 10))
                        Spacer()
                        Text("Calories consommées")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 10))
                    }
                    .frame(width: 255)
                }
                .frame(height: 70)
            }
            
        }
    }
}

#Preview {
    EatenVSBurnedCalGraph(selectedMonth: Date()).environment(UserAPViewModel()).environment(MealViewModel())
}
