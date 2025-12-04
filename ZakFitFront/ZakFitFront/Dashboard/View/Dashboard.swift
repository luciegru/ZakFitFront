//
//  Dashboard.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 03/12/2025.
//

import SwiftUI

struct Dashboard: View {
    @Environment(UserAPViewModel.self) var userAPVM
    @Environment(LoginViewModel.self) var loginVM
    @Environment(APObjectiveViewModel.self) var APObjectiveVM
    @Environment(UserWeightViewModel.self) var userWeightVM
    @Environment(WeightObjectiveViewModel.self) var weightObjectiveVM
    @Environment(MealViewModel.self) var mealVM
    
    @State var selectedInterval = "mois"
    var body: some View {
        
        ZStack {
            Image(.background5)
                .ignoresSafeArea()
            
            VStack {
                
                
                Text("DASHBOARD")
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundStyle(Color(.white))
                    .padding(.top, 60)
                
                Spacer()
                
                Text("Tes statistiques générales, ton suivi quotidien et tes objectifs à court terme, tout est ici ! \n Tu me remerciera plus tard")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
                    .frame(width : 200)
                
                Image(.zakMuscles)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                
                Spacer()
                
                ScrollView{
                    
                    APTypeGraph().environment(userAPVM)
                    
                    APDurationGraph().environment(userAPVM)
                        .environment(APObjectiveVM)
                    
                    WeightEvolutionGraph().environment(userWeightVM).environment(weightObjectiveVM)
                    
                    CustomDropdownMenu(selectedOption: $selectedInterval, options: ["mois", "jour", "semaine", "année"])
                        .frame(width: 150)
                    
                    if selectedInterval == "mois"{
                        EatenVSBurnedCalWeek(selectedDay: Date()).environment(userAPVM).environment(mealVM)
                            .frame(width: 300, height: 100)
                            .background(Color.customBlue)
                            .cornerRadius(10)
                    } else if selectedInterval == "jour"{
                        EatenVSBurnedCalGraphDay(selectedDay: Date()).environment(userAPVM).environment(mealVM)
                            .frame(width: 300, height: 100)
                            .background(Color.customBlue)
                            .cornerRadius(10)

                    } else if selectedInterval == "semaine"{
                        EatenVSBurnedCalWeek(selectedDay: Date()).environment(userAPVM).environment(mealVM)
                            .frame(width: 300, height: 100)
                            .background(Color.customBlue)
                            .cornerRadius(10)

                    } else {
                        EatenVSBurnedCalYear(selectedDay: Date()).environment(userAPVM).environment(mealVM)
                            .frame(width: 300, height: 100)
                            .background(Color.customBlue)
                            .cornerRadius(10)

                    }
            
                    
                    Text("Tous tes objectifs sont atteints, reposes-toi champion !")
                        .foregroundStyle(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                    
                    Image(.zakChilling)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(.bottom, 60)
                }
            }.task {
                if let userId = loginVM.currentUser?.id{
                    try? await userAPVM.getMyAP(userId: userId)
                }
                
                try? await userWeightVM.getMyWeight()
                try? await mealVM.getMyMeal()
            }
            
            
            
            
            
        }
    }
}

#Preview {
    Dashboard().environment(UserAPViewModel()).environment(LoginViewModel()).environment(APObjectiveViewModel()).environment(WeightObjectiveViewModel()).environment(UserWeightViewModel())
        .environment(MealViewModel())
    
    
    
}
