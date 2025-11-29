//
//  CustomCalObjectivePicker.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import SwiftUI


struct CustomCalObjectivePicker: View {
    
    @Binding var calObjective: Int
    
    var body: some View {
        
        VStack {
            Text("Je me fixe un objectif de")
            
            HStack{
                CustomStepper(selectedOption: Binding(
                    get: { Double(calObjective) },
                    set: { calObjective = Int($0) }
                ))
                Text("Calories par jour")
            }
            
        }.padding(.vertical, 10)
            .padding(.horizontal, 10)
        .frame(width: 290)
            .background(Color.customBlue)
            .cornerRadius(20)
        
    }
}


#Preview {
//    CustomCalObjectivePicker()
}
