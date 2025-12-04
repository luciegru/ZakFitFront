//
//  EatenVSBurnedCalWeek.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 02/12/2025.
//

import SwiftUI

struct EatenVSBurnedCalYear: View {
    @Environment(UserAPViewModel.self) var userAPVM
    @Environment(MealViewModel.self) var userMealVM
    var selectedDay: Date
    
    
    
    var body: some View {
        
        let APNeeded = userAPVM.APs.filter { $0.date.isInSameYear(as: selectedDay) }
        let CalNeeded = userMealVM.mealList.filter { $0.date.isInSameYear(as: selectedDay) }

        
        let APCal = APNeeded.reduce(0) { $0 + $1.burnedCal }
        let mealCal = CalNeeded.reduce(0) { $0 + $1.totalCal }
        
        let progress = mealCal > 0 ? min(CGFloat(APCal) / CGFloat(mealCal) * 0.5, 0.5) : 0

        VStack{
            
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .stroke(Color.lightGrey, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .frame(width: 115)
                    .rotationEffect(.degrees(-180))
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(Color.customPink, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .frame(width: 115)
                    .rotationEffect(.degrees(-180))
                


                
                VStack {
                    Spacer()
                    HStack {
                        Text("Calories brûlées")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 10))
                        Spacer()
                        Text("Calories consommées")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 10))
                    }
                    .frame(width: 200)
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                }
                
            }.padding(.top, 20)
            
        }
    }
}

#Preview {
//    EatenVSBurnedCalYear()
}
