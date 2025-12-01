//
//  APTimeGraph.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 01/12/2025.
//

import SwiftUI

struct APTimeGraph: View {
    @Environment(UserAPViewModel.self) var userAPViewModel
    var selectedMonth: Date

    
    var body: some View {
        
        
        let APNeeded = userAPViewModel.APs.filter { $0.date.isInSameMonth(as: selectedMonth) }
        let groupedByType = Dictionary(grouping: APNeeded, by: { $0.type })
        let totalsByType: [(type: String, total: Int)] = groupedByType.map { (type, aps) in
            (type: type, total: aps.reduce(0) { $0 + $1.duration })
        }
        let nonEmptyTypes = totalsByType.filter { $0.total > 0 }
        let sortedTypes = nonEmptyTypes.sorted { $0.total > $1.total }
        let top4 = Array(sortedTypes.prefix(4))


        
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
        }.background(Color.customLightPurple)
            .cornerRadius(20)
            .frame(height: 120)

    }
}

#Preview {
APTimeGraph(selectedMonth: Date()).environment(UserAPViewModel())
}
