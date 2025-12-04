//
//  APWeekGraph.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 02/12/2025.
//

import SwiftUI

struct APWeekGraph: View {
    @Environment(UserAPViewModel.self) var userAPViewModel
    @Environment(MealViewModel.self) var mealVM
    @Environment(LoginViewModel.self) var loginVM
    var selectedDay: Date
    
    
    var body: some View {
        
        
        let APNeeded = userAPViewModel.APs.filter { $0.date.isInSameWeek(as: selectedDay) }
        let groupedByType = Dictionary(grouping: APNeeded, by: { $0.type })
        let totalsByType: [(type: String, total: Int)] = groupedByType.map { (type, aps) in
            (type: type, total: aps.reduce(0) { $0 + $1.duration })
        }
        let nonEmptyTypes = totalsByType.filter { $0.total > 0 }
        let sortedTypes = nonEmptyTypes.sorted { $0.total > $1.total }
        let top4 = Array(sortedTypes.prefix(4))
        
        VStack{
            
            HStack{
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
            
            EatenVSBurnedCalWeek(selectedDay: selectedDay)
                .environment(userAPViewModel)
                .environment(mealVM)
            

                
        }.background(Color.customLightPurple)
            .cornerRadius(20)
    }
}

#Preview {
//    APWeekGraph()
}
