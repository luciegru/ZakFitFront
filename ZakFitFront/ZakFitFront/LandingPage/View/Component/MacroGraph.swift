//
//  MacroGraph.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 02/12/2025.
//

import SwiftUI

import SwiftUI

struct MacroGraph: View {
    var meal: Meal

    
    
    var body: some View {
        
        let total = CGFloat(meal.totalCarb + meal.totalLip + meal.totalProt)

        let carbRatio = CGFloat(meal.totalCarb) / total
        let protRatio = CGFloat(meal.totalProt) / total
        let lipRatio  = CGFloat(meal.totalLip) / total
        
        let endCarb = carbRatio * 0.5
        let endProt = (carbRatio + protRatio) * 0.5
        let endLip  = min((carbRatio + protRatio + lipRatio) * 0.5, 0.5)


        
        VStack{
            
            ZStack {
                Circle()
                    .trim(from: 0, to: endCarb)
                    .stroke(Color.customPink, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 144)
                    .rotationEffect(.degrees(-180))
                Circle()
                    .trim(from: endCarb, to: endProt)
                    .stroke(Color.customPurple, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 144)
                    .rotationEffect(.degrees(-180))
                Circle()
                    .trim(from: endProt, to: endLip)
                    .stroke(Color.customBlue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 144)
                    .rotationEffect(.degrees(-180))
                
                VStack(alignment: .leading){
                    HStack{
                        Rectangle()
                            .foregroundStyle(Color.customPink)
                            .frame(width: 10, height: 10)
                            .cornerRadius(110)
                        
                        Text("Glucides")
                    }
                    HStack{
                        Rectangle()
                            .foregroundStyle(Color.customPurple)
                            .frame(width: 10, height: 10)
                            .cornerRadius(110)
                        
                        Text("Protéines")
                    }
                    HStack{
                        Rectangle()
                            .foregroundStyle(Color.customBlue)
                            .frame(width: 10, height: 10)
                            .cornerRadius(110)
                        
                        Text("Lipides")
                    }
                }.padding(.top, 30)
                
            }
            
            
            
            
        }
    }
}

#Preview {
    MacroGraph(meal: Meal(id: UUID(), user: UUID(), type: "String", date: Date(), totalCal: 100, totalProt: 50, totalCarb: 50, totalLip: 50))
}
