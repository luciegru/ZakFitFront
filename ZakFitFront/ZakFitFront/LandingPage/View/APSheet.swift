//
//  APSheet.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 03/12/2025.
//

import SwiftUI

struct APSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(LoginViewModel.self) var loginVM
    @Environment(APViewModel.self) var APVM
    @Environment(UserAPViewModel.self) var userAPVM
    
    @State var selectedType: String = "course"
    @State var selectedIntensity: String = "moyenne"
    @State var selectedDuration: Int = 100
    @State var selectedCal: Int = 500
    @State var calBurned: Int = 0
    var body: some View {

        ZStack{
            Color.black.ignoresSafeArea()
            
            VStack{
                Text("Type")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.white)
                CustomDropdownMenu(selectedOption: $selectedType, options: ["course", "marche", "vélo", "sport collectif", "yoga", "musculation"])
                    .frame(width: 200)
                
                Spacer()
                
                Text("Intensité")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.white)
                CustomDropdownMenu(selectedOption: $selectedIntensity, options: ["basse", "moyenne", "haute"])
                    .frame(width: 200)
                
                Spacer()
                
                Text("Durée")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.white)
                
                HStack{
                    CustomStepper(selectedOption: Binding(
                        get: { Double(selectedDuration) },
                        set: { selectedDuration = Int($0) }
                    ))
                    Text("minutes")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.white)
                }
                
                Spacer()
                
                Text("Calories brûlées")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.white)

                HStack{
                    CustomStepper(selectedOption: Binding(
                        get: { Double(selectedCal) },
                        set: { selectedCal = Int($0) }
                    ))
                    Text("calories")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.white)
                }
                Button(action: {
                    calBurned = burnedCalCalcul(activity: selectedType, intensity: selectedIntensity, durationMin: Double(selectedDuration), weightKg: loginVM.currentUser?.weight ?? 70)
                }, label:{
                    Text("calcul automatique")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.black)
                        .padding(10)
                        .background(Color.customPurple)
                        .cornerRadius(10)
                        
                })
                
                Spacer()
                Text(calBurned == 0 ? "" : "\(calBurned)")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Color.customPurple)
                
                if calBurned != 0 && calBurned < 300 {
                    VStack{
                        Image(.zakChilling)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)

                        Text("T'aurais pu faire un effort")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.center)
                    }
                } else if calBurned != 0 && calBurned >= 300 {
                    Image(.zakPush)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    Text("Tié un tigre")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.white)
                        .multilineTextAlignment(.center)

                }
                
                Spacer()
                
                
                Button(action: {
                    Task{
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateString = dateFormatter.string(from: Date())
                        
                        var neededCal: Int = 0
                        
                        if calBurned == 0 {
                            neededCal = selectedCal
                        } else {
                            neededCal = calBurned
                        }

                        
                        try await APVM.createAP(with: ["type" : selectedType, "duration" : selectedDuration, "intensity" : selectedIntensity, "burnedCal" : neededCal, "date" : dateString])
                        
                        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconde

                        if let apId = APVM.APhysic?.id {
                            try await userAPVM.createUserAP(with: ["AP" : apId.uuidString])

                        }
                        
                        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconde

                        dismiss()
                        
                    }
                }, label:{
                    Text("ENREGISTRER")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Color.black)
                        .padding(15)
                        .background(Color.customBlue)
                        .cornerRadius(10)
                        
                })

            }
        }
    }
}

#Preview {
    APSheet().environment(LoginViewModel()).environment(APViewModel()).environment(UserAPViewModel())
}
