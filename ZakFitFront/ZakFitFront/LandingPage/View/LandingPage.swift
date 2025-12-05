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
    @State private var navigateToWeekFromCalendar = false
    @State private var navigateToWeekFromDropdown = false
    @State private var selectedMonth: Date = Date()
    @State private var dataLoaded = false
    @State private var calendarRefreshID = UUID()

    
    
    @Environment(LoginViewModel.self) private var loginVM
    @Environment(APObjectiveViewModel.self) private var APObjectiveVM
    @Environment(DailyCalObjectiveViewModel.self) var dailyCalObjectiveVM
    @Environment(MealViewModel.self) var mealVM
    @Environment(UserAPViewModel.self) var userAPVM
    @Environment(UserWeightViewModel.self) var userWeightVM
    @Environment(WeightObjectiveViewModel.self) var weightObjectiveVM
    @Environment(FoodViewModel.self) var foodVM
    @Environment(APViewModel.self) var APVM

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
                    
                    // ✅ Affiche le calendrier seulement quand les données sont chargées
                    if dataLoaded {
                        CalendarMonthView(
                            selectedDate: $selectedDate,
                            onDoubleTap: { navigateToWeekFromCalendar = true },
                            onMonthChange: { newMonth in
                                selectedMonth = newMonth
                            }
                        )
                        .environment(mealVM)
                        .environment(userAPVM)
                        .environment(loginVM)
                        .id(dataLoaded)  // ✅ Force le refresh
                    } else {
                        // Loader pendant le chargement
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                            .frame(height: 300)
                    }

                    VStack {
                        ScrollView {
                            DailyTips()
                                .environment(loginVM)
                                .environment(userAPVM)
                                .environment(APObjectiveVM)
                                .environment(dailyCalObjectiveVM)
                                .environment(weightObjectiveVM)
                                .environment(mealVM)
                                .environment(userWeightVM)
                            
                            CalGraph(selectedMonth: selectedMonth)
                                .environment(userAPVM)
                                .environment(APObjectiveVM)
                            
                            Spacer(minLength: 15)
                            
                            VStack {
                                Text("Consommation de macronutriments du mois")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                    
                                CustomMacroProgressView(selectedMonth: selectedMonth)
                                    .environment(mealVM)
                                    .frame(width: 275, height: 20)
                                
                                HStack {
                                    HStack {
                                        Rectangle()
                                            .foregroundStyle(Color.customPurple)
                                            .frame(width: 15, height: 15)
                                            .cornerRadius(100)
                                        Text("Glucides")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundStyle(Color.white)
                                    }
                                    HStack {
                                        Rectangle()
                                            .foregroundStyle(Color.customBlue)
                                            .frame(width: 15, height: 15)
                                            .cornerRadius(100)
                                        Text("Protéines")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundStyle(Color.white)
                                    }
                                    HStack {
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
                            
                            EatenVSBurnedCalGraph(selectedMonth: selectedMonth)
                                .environment(userAPVM)
                                .environment(mealVM)
                            
                            Spacer(minLength: 30)
                            
                            VStack {
                                if userAPVM.APs.count > 0 {
                                    APTimeGraph(selectedMonth: selectedMonth)
                                        .environment(userAPVM)
                                } else {
                                    EmptyView()
                                }
                            }
                            .padding(.bottom, 60)
                        }
                    }
                }
                .padding(.vertical, 50)
            }
            .navigationDestination(isPresented: $navigateToWeekFromCalendar) {
                LandingPageWeek(selectedDate: selectedDate)
                    .environment(mealVM)
                    .environment(userAPVM)
                    .environment(loginVM)
                    .environment(dailyCalObjectiveVM)
                    .environment(APObjectiveVM)
                    .environment(userWeightVM)
                    .environment(weightObjectiveVM)
                    .environment(foodVM)
                    .environment(APVM)
            }
            .navigationDestination(isPresented: $navigateToWeekFromDropdown) {
                LandingPageWeek(selectedDate: Date())
                    .environment(mealVM)
                    .environment(userAPVM)
                    .environment(loginVM)
                    .environment(dailyCalObjectiveVM)
                    .environment(APObjectiveVM)
                    .environment(userWeightVM)
                    .environment(weightObjectiveVM)
                    .environment(foodVM)
                    .environment(APVM)
            }
            .onChange(of: selectedDateInterval) { oldValue, newValue in
                if newValue.lowercased() == "semaine" {
                    navigateToWeekFromDropdown = true
                }
            }
            .navigationBarBackButtonHidden()
            // ✅ Utilise .task au lieu de .onAppear
            .task {
//                print("🔄 Chargement des données...")
                
                await APObjectiveVM.getMyAPObjective()
                try? await dailyCalObjectiveVM.getMyDailyCalObjective()
                try? await weightObjectiveVM.getMyWeightObjective()
                try? await userWeightVM.getMyWeight()
                
                if let userId = loginVM.currentUser?.id {
                    await mealVM.getMyMeal()
                    await userAPVM.getMyAP(userId: userId)
                    
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }
                
                dataLoaded = true
                calendarRefreshID = UUID()
            }
            
            .onDisappear {
                dataLoaded = false
            }
        }
    }}




#Preview {
    LandingPage()
        .environment(LoginViewModel())
        .environment(APObjectiveViewModel())
        .environment(DailyCalObjectiveViewModel())
        .environment(WeightObjectiveViewModel())
        .environment(MealViewModel())
        .environment(UserAPViewModel())
        .environment(MealViewModel())
        .environment(UserWeightViewModel())
        .environment(WeightObjectiveViewModel())
        .environment(FoodViewModel())
        .environment(APViewModel())
}
