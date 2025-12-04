//
//  WeigtSheet.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 04/12/2025.
//

import SwiftUI

struct WeightSheet: View {
    
    @State var selectedWeight: Double = 0
    @Environment(LoginViewModel.self) var loginVM
    @Environment(UserWeightViewModel.self) var userWeightVM
    @Environment(\.dismiss) var dismiss
    
    var body: some View {

        ZStack{
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .center){
                Text("C'est l'heure de te peser !")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.white)
                    .padding(.top, 40)
                
                Spacer()
                
                ZStack{
                    
                    Image(.zakWeight)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    
                    Text(String(format: "%.1f", loginVM.currentUser?.weight ?? 0)
)
                        .foregroundStyle(Color.white)
                        .font(.system(size: 20))
                        .position(x:187, y:172)

                }.frame(height: 200)
                
                Spacer()
                
                HStack{
                    CustomStepper(selectedOption: $selectedWeight)
                    Text("Kilogrammes")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.white)

                }
                
                Spacer()
                
                Button(action:{
                    
                    Task{
                        try await loginVM.updateCurrentUser(with: ["weight" : selectedWeight])
                        try await userWeightVM.createWeight(with: ["weight" : selectedWeight])
                        
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        
                        dismiss()
                    }
                    
                }, label:{
                    Text("ENREGISTRER")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Color.black)
                        .padding(10)
                        .background(Color.customBlue)
                        .cornerRadius(10)

                    
                })
            }
            
        }.task {
            selectedWeight = loginVM.currentUser?.weight ?? 0
        }
    }
}

#Preview {
    WeightSheet().environment(LoginViewModel()).environment(UserWeightViewModel())
}
