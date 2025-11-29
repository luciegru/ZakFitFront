//
//  CustomAPObjectivePicker.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 28/11/2025.
//

import SwiftUI

struct CustomAPObjectivePicker: View {
    
    @Binding var selectedAPObjective: String
    @Binding var selectedAPTime: Int
    @Binding var selectedAPSport: String
    @Binding var selectedAPStep: Int
    @Binding var selectedAPInterval: String
    @Binding var selectedCals: Int
    @Binding var selectedAPNumbers: Int

    var body: some View {
        VStack {
            
            HStack{
                Text("Je veux")
                
                CustomDropdownMenu(selectedOption: $selectedAPObjective, options: ["Faire (minutes)", "Augmenter", "Brûler", "Faire (séances)"])
            }
            
            if selectedAPObjective == "Faire (minutes)"{
                HStack{
                    CustomStepper(selectedOption: Binding(
                        get: { Double(selectedAPTime) },
                        set: { selectedAPTime = Int($0) }
                    ))
                    
                    Text("minutes de")
                }
                
                HStack{
                    CustomDropdownMenu(selectedOption: $selectedAPSport, options: ["sport", "marche", "course", "natation", "sport collectif", "musculation", "vélo", "autre"])
                    
                    Text("par")
                    
                    CustomDropdownMenu(selectedOption: $selectedAPInterval, options: ["jours", "mois" , "semaines"])
                }
            } else if selectedAPObjective == "Augmenter"{
                HStack{
                    Text("de")
                    
                    CustomStepper(selectedOption: Binding(
                        get: { Double(selectedAPTime) },
                        set: { selectedAPTime = Int($0) }
                    ))
                    
                    Text("minutes mes ")
                    
                }
                
                HStack{
                    Text("séances de")
                    
                    CustomDropdownMenu(selectedOption: $selectedAPSport, options: ["sport", "marche", "course", "natation", "sport collectif", "musculation", "vélo", "autre"])

                }
                
                HStack{
                    Text("chaque")
                    
                    CustomDropdownMenu(selectedOption: $selectedAPInterval, options: ["jours", "mois" , "semaines"])
                    
                }.padding(5)
            } else if selectedAPObjective == "Brûler"{
                HStack{
                    CustomStepper(selectedOption:  Binding(
                        get: { Double(selectedCals) },
                        set: { selectedCals = Int($0) }
                    ))
                    
                    Text("calories")
                }
                
                HStack{
                    Text("par")
                    
                    CustomDropdownMenu(selectedOption: $selectedAPInterval, options: ["jours", "mois" , "semaines"])
                    
                }
            } else if selectedAPObjective == "Faire (séances)"{
                HStack{
                    CustomStepper(selectedOption:  Binding(
                        get: { Double(selectedAPNumbers) },
                        set: { selectedAPNumbers = Int($0) }
                    ))
                    
                    Text("séances de")
                }
                
                HStack{
                    CustomDropdownMenu(selectedOption: $selectedAPSport, options: ["sport", "marche", "course", "natation", "sport collectif", "musculation", "vélo", "autre"])

                    
                    Text("par")
                    
                    CustomDropdownMenu(selectedOption: $selectedAPInterval, options: ["jours", "mois" , "semaines"])
                    
                }

            }
            
        }.padding(.vertical, 10)
            .padding(.horizontal, 10)
        .frame(width: 290)
            .background(Color.customBlue)
            .cornerRadius(20)
        


    }
}

#Preview {
//    CustomAPObjectivePicker()
}
