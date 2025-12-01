//
//  ContentView.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 23/11/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State var loginVM = LoginViewModel()
    @State private var selectedTab: Tab = .calendrier
    @State var dailyCalObjectiveVM = DailyCalObjectiveViewModel()
    @State var weightObjectiveVM = WeightObjectiveViewModel()
    @State var mealVM = MealViewModel()
    @State var userAPVM = UserAPViewModel()
    @State var APObjectiveVM = APObjectiveViewModel()

    
    var body: some View {
        
        if !loginVM.isAuthenticated {
            LoginView().environment(loginVM)
        } else if loginVM.isAuthenticated && loginVM.currentUser?.onboardingDone == true {
            ZStack(alignment: .bottom) {
                
                // Navigation en fonction du tab
                Group {
                    switch selectedTab {
                    case .calendrier:
                        LandingPage()
                    case .dashboard:
                        Button(action: {loginVM.logout()}, label: {Text("logout")})
                    case .profil:
                        Text("Profil")
                    case .historique:
                        Text("Historiquentm")
                    }
                }
                .ignoresSafeArea()
                
                
                VStack{
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab)
                        .frame(height: 100) // ou la hauteur que tu veux
                        .padding(.bottom, 20)
                }
                
            }.environment(loginVM)
                .environment(dailyCalObjectiveVM)
                .environment(weightObjectiveVM)
                .environment(mealVM)
                .environment(userAPVM)
                .environment(APObjectiveVM)
                .navigationBarBackButtonHidden()
        } else {
            OBPage1()
            
        }
       
    }
}



#Preview {
    ContentView()
        .environment(LoginViewModel())
        .environment(DailyCalObjectiveViewModel())
        .environment(WeightObjectiveViewModel())
        .environment(MealViewModel())
        .environment(UserViewModel())
        .environment(APObjectiveViewModel())
}
