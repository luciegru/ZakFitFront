//
//  APTodayGraph.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 02/12/2025.
//

import SwiftUI

struct APTodayGraph: View {
    @Environment(UserAPViewModel.self) var userAPViewModel
    @Environment(MealViewModel.self) var mealVM
    @Environment(LoginViewModel.self) var loginVM

    var selectedDay: Date

    // MARK: - Computed vars réactives
    var APNeeded: [AP] {
        userAPViewModel.APs.filter { $0.date.isInSameDay(as: selectedDay) }
    }

    var top4: [(type: String, total: Int)] {
        let grouped = Dictionary(grouping: APNeeded, by: { $0.type })
        let totals = grouped.map { (type, aps) in
            (type, aps.reduce(0) { $0 + $1.duration })
        }
        return totals
            .filter { $0.1 > 0 }
            .sorted { $0.1 > $1.1 }
            .prefix(4)
            .map { (type: $0.0, total: $0.1) }
    }

    var body: some View {
        VStack{
            HStack {
                ForEach(top4, id: \.type) { item in
                    VStack {
                        Text("\(item.total)")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.customPink)
                        
                        Text("minutes")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.black)
                        
                        Text(item.type)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .padding()
                }
                
            }
            EatenVSBurnedCalGraphDay(selectedDay: selectedDay)
                .environment(userAPViewModel)
                .environment(mealVM)

        }     .background(Color.customLightPurple)
            .cornerRadius(20)

    }
}

#Preview {
    APTodayGraph(selectedDay: Date()).environment(UserAPViewModel()).environment(MealViewModel()).environment(LoginViewModel())
}
