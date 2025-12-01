//
//  CustomMacroProgressView.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 01/12/2025.
//

import SwiftUI

struct CustomMacroProgressView: View {
    @Environment(MealViewModel.self) var mealVM
    var selectedMonth: Date
    
    var body: some View {
        let filtermeal = mealVM.mealList.filter { $0.date.isInSameMonth(as: selectedMonth) }
        let prots = filtermeal.reduce(0) { $0 + $1.totalProt }
        let carbs = filtermeal.reduce(0) { $0 + $1.totalCarb }
        let lips = filtermeal.reduce(0) { $0 + $1.totalLip }
        let tot = max(prots + carbs + lips, 1)

        GeometryReader { geo in
            HStack(spacing: 0) {

                // Carbs
                Rectangle()
                    .fill(Color.customPurple)
                    .frame(width: geo.size.width * CGFloat(carbs) / CGFloat(tot))

                // Prots
                Rectangle()
                    .fill(Color.customBlue)
                    .frame(width: geo.size.width * CGFloat(prots) / CGFloat(tot))

                // Lips
                Rectangle()
                    .fill(Color.customPink)
                    .frame(width: geo.size.width * CGFloat(lips) / CGFloat(tot))
            }
            .frame(height: 20)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .frame(height: 20)
    }
}

#Preview {
//    CustomMacroProgressView().environment(MealViewModel())
}
