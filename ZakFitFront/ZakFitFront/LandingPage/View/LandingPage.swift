//
//  LandingPage.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import SwiftUI

struct LandingPage: View {
    @State var selectedDateInterval: String = "Mois"
    @State private var selectedDate = Date()
    @State private var navigateToWeek = false
    @State private var selectedMonth: Date = Date()
    
    @Environment(LoginViewModel.self) private var loginVM
    @Environment(APObjectiveViewModel.self) private var APObjectiveVM
    @Environment(DailyCalObjectiveViewModel.self) var dailyCalObjective
    @Environment(WeightObjectiveViewModel.self) var weightObjective
    @Environment(MealViewModel.self) var mealVM
    @Environment(UserAPViewModel.self) var userAPVM

    var body: some View {
        NavigationStack {
            ZStack {
                Image(.background5)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        CustomDropdownMenu(selectedOption: $selectedDateInterval, options: ["semaine", "mois", "année", "custom"])
                        
                        Spacer(minLength: 151)
                        
                        Button(action: {}, label: {
                            
                            AsyncImage(url: URL(string: loginVM.currentUser?.picture ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(100)
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                            }
                        })
                    }
                    .padding(.horizontal, 20)
                                        
                    CalendarMonthView(
                        selectedDate: $selectedDate,
                        onDoubleTap: { navigateToWeek = true },
                        onMonthChange: { newMonth in
                            selectedMonth = newMonth
                        }
                    )
                    .environment(mealVM)
                    .environment(userAPVM)
                    .environment(loginVM)

                    VStack{
                        ScrollView{
                            
                            DailyTips().environment(loginVM).environment(userAPVM).environment(APObjectiveVM).environment(dailyCalObjective).environment(weightObjective).environment(mealVM)
                            
                            CalGraph(selectedMonth: selectedMonth)
                                .environment(userAPVM)
                                .environment(APObjectiveVM)
                            
                            Spacer(minLength: 15)
                            
                            VStack{
                                
                                Text("Consommation de macronutriments du mois")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                    
                                CustomMacroProgressView(selectedMonth: selectedMonth)
                                    .environment(mealVM)
                                    .frame(width: 275, height: 20)
                                
                                HStack{
                                    HStack{
                                        Rectangle()
                                            .foregroundStyle(Color.customPurple)
                                            .frame(width: 15, height: 15)
                                            .cornerRadius(100)
                                        Text("Glucides")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundStyle(Color.white)
                                            
                                    }
                                    HStack{
                                        Rectangle()
                                            .foregroundStyle(Color.customBlue)
                                            .frame(width: 15, height: 15)
                                            .cornerRadius(100)
                                        Text("Protéines")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundStyle(Color.white)
                                            
                                    }
                                    HStack{
                                        Rectangle()
                                            .foregroundStyle(Color.customPink)
                                            .frame(width: 15, height: 15)
                                            .cornerRadius(100)
                                        Text("Lipides")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundStyle(Color.white)
                                            
                                    }
                                }
                            }
                            
                            Spacer(minLength: 30)
                            
                            EatenVSBurnedCalGraph(selectedMonth: selectedMonth).environment(userAPVM).environment(mealVM)
                            
                            Spacer(minLength: 30)
                            
                            VStack{
                                
                                if userAPVM.APs.count > 0{
                                    APTimeGraph(selectedMonth: selectedMonth).environment(userAPVM)
                                    
                                } else {
                                    EmptyView()
                                }
                                
                            }.padding(.bottom, 60)
                        }
                    }
                }
                .padding(.vertical, 50)
            }
            .navigationDestination(isPresented: $navigateToWeek) {
                WeekDetailView(selectedDate: selectedDate)
            }
            .task {
                await APObjectiveVM.getMyAPObjective()
                try? await dailyCalObjective.getMyDailyCalObjective()
                try? await weightObjective.getMyWeightObjective()
                if let userId = loginVM.currentUser?.id{
                    
                try? await userAPVM.getMyAP(userId: userId)
                }

            }
          

            
        }
    }
}




#Preview {
    LandingPage().environment(LoginViewModel()).environment(APObjectiveViewModel()).environment(DailyCalObjectiveViewModel()).environment(WeightObjectiveViewModel()).environment(MealViewModel()).environment(UserAPViewModel())
}
