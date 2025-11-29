//
//  CustomMacroObjectivePicker.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import SwiftUI

struct CustomMacroObjectivePicker: View {
    
    @Binding var protObjective: Int
    @Binding var carbObjective: Int
    @Binding var lipObjective: Int
    
    
    var body: some View {
        VStack {
            Text("Je me fixe un objectif journalier de")
            
            HStack{
                CustomStepper(selectedOption: Binding(
                    get: { Double(protObjective) },
                    set: { protObjective = Int($0) }
                ))
                Text("g de protéines")
            }
            HStack{
                CustomStepper(selectedOption: Binding(
                    get: { Double(carbObjective) },
                    set: { carbObjective = Int($0) }
                ))
                Text("g de glucides")
            }
            HStack{
                CustomStepper(selectedOption: Binding(
                    get: { Double(lipObjective) },
                    set: { lipObjective = Int($0) }
                ))
                Text("g de lipides")
            }
            
        }.padding(.vertical, 10)
            .padding(.horizontal, 10)
        .frame(width: 290)
            .background(Color.customBlue)
            .cornerRadius(20)
    }
}

#Preview {
//    CustomMacroObjectivePicker()
}
