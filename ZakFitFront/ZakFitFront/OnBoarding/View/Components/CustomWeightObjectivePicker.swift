//
//  CustomObjectivePicker.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 28/11/2025.
//

import SwiftUI

struct CustomWeightObjectivePicker: View {
    
    @Binding var healthObjective: String
    @Binding var selectedWeight: Double
    @Binding var selectedInterval: Int
    @Binding var selectedIntervalUnit: String
    
    var body: some View {
        
        VStack {
            Text("Je veux \(healthObjective == "Perte de poids" ? "perdre" : "gagner")")
            
            HStack{
                CustomStepper(selectedOption: $selectedWeight)
                Text("kg")
            }
            
            HStack{
                Text("En")
                CustomStepper(selectedOption: Binding(
                    get: { Double(selectedInterval) },
                    set: { selectedInterval = Int($0) }
                ))
                
                CustomDropdownMenu(selectedOption: $selectedIntervalUnit, options: ["semaines", "mois"])
            }
            
            
            
        }.padding(.vertical, 10)
            .padding(.horizontal, 10)
        .frame(width: 290)
            .background(Color.customBlue)
            .cornerRadius(20)
        
    }
}

#Preview {
//    CustomWeightObjectivePicker()
}
