//
//  CustomMacroProgressDay.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 02/12/2025.
//

import SwiftUI

struct CustomMacroProgressDay: View {
    
    @Environment(MealViewModel.self) var mealVM
    
    var selectedDay: Date
    
    var body: some View {
        let filtermeal = mealVM.mealList.filter { $0.date.isInSameDay(as: selectedDay) }
        let prots = filtermeal.reduce(0) { $0 + $1.totalProt }
        let carbs = filtermeal.reduce(0) { $0 + $1.totalCarb }
        let lips = filtermeal.reduce(0) { $0 + $1.totalLip }
        let tot = max(prots + carbs + lips, 1)

        GeometryReader { geo in
            
            ZStack{
                
                Rectangle()
                    .fill(Color.middleGrey)
                    .frame(width: 385)
                    .cornerRadius(200)

                HStack(spacing: 0) {
                    
                    
                    
                    // Carbs
                    Rectangle()
                        .fill(Color.customPink)
                        .frame(width: geo.size.width * CGFloat(carbs) / CGFloat(tot))
                    
                    // Prots
                    Rectangle()
                        .fill(Color.customPurple)
                        .frame(width: geo.size.width * CGFloat(prots) / CGFloat(tot))
                    
                    // Lips
                    Rectangle()
                        .fill(Color.customBlue)
                        .frame(width: geo.size.width * CGFloat(lips) / CGFloat(tot))
                }
                .frame(height: 20)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .frame(height: 20)
        }
    }
}

#Preview {
//    CustomMacroProgressView().environment(MealViewModel())
}
