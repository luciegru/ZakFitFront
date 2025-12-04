//
//  LandingPageWeek.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 01/12/2025.
//

import SwiftUI

struct LandingPageWeek: View {
    
    var selectedDate: Date
    @State private var selectedDay: Date
    @Environment(\.dismiss) private var dismiss
    @Environment(MealViewModel.self) private var mealVM
    @Environment(UserAPViewModel.self) private var userAPVM
    @Environment(LoginViewModel.self) var loginVM
    @Environment(DailyCalObjectiveViewModel.self) var dailyCalObjectiveVM
    @Environment(APObjectiveViewModel.self) var APObjectiveVM
    @Environment(UserWeightViewModel.self) var userWeightVM
    @Environment(WeightObjectiveViewModel.self) var weightObjectiveVM
    @Environment(FoodViewModel.self) var foodVM
    @Environment(APViewModel.self) var APVM
    @State var selectedOption = "semaine"
    @State private var navigateToMonth: Bool = false
    @State private var showingMealSheet = false
    @State private var showingAPSheet = false
    @State private var showingWeightSheet = false

    
    @State var mealFoodVM: MealFoodViewModel = MealFoodViewModel()
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        let calendar = Calendar.current
        let normalized = calendar.startOfDay(for: selectedDate)
        self._selectedDay = State(initialValue: normalized)
    }

    // Calcul de la semaine
    private var weekDays: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)) ?? selectedDate
        
        return (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: startOfWeek)
        }
    }
    
    
    // Détermine le type d'activité pour un jour
    private func activityType(for date: Date) -> ActivityType {
        let calendar = Calendar.current
        
        let hasMeals = mealVM.mealList.contains { meal in
            calendar.isDate(meal.date, inSameDayAs: date)
        }
        
        let hasWorkout = userAPVM.APs.contains { ap in
            calendar.isDate(ap.date, inSameDayAs: date)
        }
        
        if hasMeals && hasWorkout {
            return .both
        } else if hasMeals {
            return .meal
        } else if hasWorkout {
            return .workout
        } else {
            return .none
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack {
                Image(.background5)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    HStack{
                        // Sélecteur semaine
                        
                        CustomDropdownMenu(selectedOption: $selectedOption, options: ["mois", "semaine", "année", "custom"])
                        
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
                    .padding(.horizontal, 16)
                    .padding(.top, 60)
                    
                    
                    // Calendrier semaine
                    HStack(spacing: 12) {
                        ForEach(weekDays, id: \.self) { day in
                            DayButton(
                                date: day,
                                isSelected: Calendar.current.isDate(day, inSameDayAs: selectedDay),
                                activityType: activityType(for: day)
                            )
                            .onTapGesture {
                                let calendar = Calendar.current
                                selectedDay = calendar.startOfDay(for: day)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading){
                        
                        ScrollView{
                            
                            HStack{
                                Spacer()
                                
                                Button(action: {
                                    showingMealSheet.toggle()
                                }, label:{
                                    HStack{
                                        Text("Modifier mes repas")
                                            .foregroundStyle(Color(.white))
                                            .font(.system(size: 16, weight: .regular))
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(Color(.white))
                                        
                                    }
                                })
                            }.padding(.trailing, 30)
                                .sheet(isPresented: $showingMealSheet, onDismiss: {
                                    Task {
                                        await mealVM.getMyMeal()
                                        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconde
                                    }
                                }) {
                                    MealSheet()
                                        .environment(mealVM)
                                        .environment(foodVM)
                                        .environment(mealFoodVM)
                                }



                            MealScrollView(selectedDay: selectedDay).environment(mealVM).environment(mealFoodVM)
                            
                            //Daily CalObj
                            VStack{
                                
                                HStack{
                                    Text("Objectif journalier de calories")
                                        .foregroundStyle(Color(.white))
                                        .font(.system(size: 16, weight: .regular))
                                    
                                    Spacer()
                                }
                                
                                let calendar = Calendar.current
                                let todayMeals = mealVM.mealList.filter { meal in
                                    calendar.isDate(meal.date, inSameDayAs: selectedDay)
                                }
                                
                                let actualCal = todayMeals.reduce(0) { $0 + $1.totalCal }
                                
                                
                                CustomProgressView(color: Color(.customYellow), actual: actualCal, target: dailyCalObjectiveVM.dailyCalObj?.cal ?? 2000, width: CGFloat(385))
                                
                                HStack{
                                    Spacer()
                                    Text("\(actualCal)/\(dailyCalObjectiveVM.dailyCalObj?.cal ?? 2000)")
                                        .foregroundStyle(Color(.white))
                                        .font(.system(size: 10, weight: .regular))
                                    
                                }
                                
                            }.padding(.vertical, 10)
                                .padding(.horizontal)
                            
                            //Macroprogress day
                            VStack{
                                
                                HStack{
                                    Text("Répartition des macronutriments par jour")
                                        .foregroundStyle(Color(.white))
                                        .font(.system(size: 16, weight: .regular))
                                    Spacer()
                                }.padding(.horizontal, 20)
                                
                                CustomMacroProgressDay(selectedDay: selectedDay)
                                    .frame(width: 385)
                                
                                HStack{
                                    
                                    Rectangle()
                                        .foregroundStyle(Color.customPink)
                                        .frame(width: 10, height: 10)
                                        .cornerRadius(100)
                                    Text("Glucides")
                                        .foregroundStyle(Color(.white))
                                        .font(.system(size: 10, weight: .regular))
                                    Rectangle()
                                        .foregroundStyle(Color.customPurple)
                                        .frame(width: 10, height: 10)
                                        .cornerRadius(100)
                                    Text("Protéines")
                                        .foregroundStyle(Color(.white))
                                        .font(.system(size: 10, weight: .regular))
                                    Rectangle()
                                        .foregroundStyle(Color.customBlue)
                                        .frame(width: 10, height: 10)
                                        .cornerRadius(100)
                                    Text("Lipides")
                                        .foregroundStyle(Color(.white))
                                        .font(.system(size: 10, weight: .regular))
                                    
                                    
                                    
                                }.padding(.top, 20)
                            }
                            // ZakTacos
                            VStack{
                                Text("Un tacos c'est toujours une bonne idée !")
                                    .foregroundStyle(Color(.white))
                                    .font(.system(size: 16, weight: .regular))
                                    .frame(width: 170)
                                    .multilineTextAlignment(.center)
                                
                                Image(.zakTacos)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                            }.padding()
                            
                            //macroprogress week
                            VStack{
                                
                                HStack{
                                    Text("Répartition des macronutriments par semaine")
                                        .foregroundStyle(Color(.white))
                                        .font(.system(size: 16, weight: .regular))
                                    Spacer()
                                }.padding(.horizontal, 20)
                                
                                CustomMacroProgressWeek(selectedDay: selectedDay)
                                    .frame(width: 385)
                                
                                HStack{
                                    
                                    Rectangle()
                                        .foregroundStyle(Color.customPink)
                                        .frame(width: 10, height: 10)
                                        .cornerRadius(100)
                                    Text("Glucides")
                                        .foregroundStyle(Color(.white))
                                        .font(.system(size: 10, weight: .regular))
                                    Rectangle()
                                        .foregroundStyle(Color.customPurple)
                                        .frame(width: 10, height: 10)
                                        .cornerRadius(100)
                                    Text("Protéines")
                                        .foregroundStyle(Color(.white))
                                        .font(.system(size: 10, weight: .regular))
                                    Rectangle()
                                        .foregroundStyle(Color.customBlue)
                                        .frame(width: 10, height: 10)
                                        .cornerRadius(100)
                                    Text("Lipides")
                                        .foregroundStyle(Color(.white))
                                        .font(.system(size: 10, weight: .regular))
                                    
                                    
                                    
                                }.padding(.top, 20)
                            }
                            
                            //bouton pour modifier les APs
                            HStack{
                                
                                Spacer()
                                
                                Button(action: {
                                    showingAPSheet.toggle()
                                }, label:{
                                    HStack{
                                        Text("Modifier mes activités physiques")
                                            .foregroundStyle(Color(.white))
                                            .font(.system(size: 16, weight: .regular))
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(Color(.white))
                                        
                                    }
                                }).sheet(isPresented: $showingAPSheet, onDismiss: {
                                    Task {
                                        if let userId = loginVM.currentUser?.id {
                                            await userAPVM.getMyAP(userId: userId)
                                            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconde
                                        }
                                    }
                                }) {
                                    APSheet()
                                        .environment(loginVM)
                                        .environment(userAPVM)
                                        .environment(APVM)
                                }

                            }.padding(30)
                            
                            VStack{
                                Text("Aujourd'hui")
                                    .foregroundStyle(Color(.white))
                                    .font(.system(size: 16, weight: .bold))
                                
                                APTodayGraph(selectedDay: selectedDay)
                                    .environment(userAPVM)
                                    .environment(mealVM)
                                    .environment(loginVM)
                                    .id(selectedDay)
                            }.padding(.bottom,20)
                            
                            VStack{
                                Text("Cette semaine")
                                    .foregroundStyle(Color(.white))
                                    .font(.system(size: 16, weight: .bold))
                                
                                APWeekGraph(selectedDay: selectedDay)
                                    .environment(userAPVM)
                                    .environment(mealVM)
                                    .environment(loginVM)
                                    .id(selectedDay)
                            }.padding(.bottom,20)
                            
                            //Graph évolution des cals brûlées dans le mois
                            VStack{
                                
                                HStack{
                                    Text("Évolution des calories brûlées au cours de la semaine")
                                        .foregroundStyle(Color(.white))
                                        .font(.system(size: 16, weight: .regular))
                                        .multilineTextAlignment(.leading)
                                        .frame(width: 380)
                                    
                                    Spacer()
                                    
                                }
                                
                                CalGraphWeek(selectedDay: selectedDay).environment(userAPVM).environment(APObjectiveVM)
                                
                            }.padding(.vertical, 15)
                            
                            //bouton pour modifier le poids
                            HStack{
                                
                                Spacer()
                                
                                Button(action: {
                                    showingWeightSheet.toggle()
                                }, label:{
                                    HStack{
                                        Text("Modifier mon poids")
                                            .foregroundStyle(Color(.white))
                                            .font(.system(size: 16, weight: .regular))
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(Color(.white))
                                        
                                    }
                                }).sheet(isPresented: $showingWeightSheet, onDismiss: {
                                    Task {
                                    }
                                }) {
                                    WeightSheet()
                                        .environment(loginVM)
                                        .environment(userWeightVM)
                                }

                            }.padding(30)
                            
                            //graph de poids
                            WeightGraph().environment(userWeightVM).environment(weightObjectiveVM)
                                .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .task {
                print("🔄 Chargement des données Week...")
                
                try? await dailyCalObjectiveVM.getMyDailyCalObjective()
                try? await weightObjectiveVM.getMyWeightObjective()
                
                if let userId = loginVM.currentUser?.id {
                    await mealVM.getMyMeal()
                    await userAPVM.getMyAP(userId: userId)
                    try? await userWeightVM.getMyWeight()
                    
                    // ✅ ATTENDRE que les requêtes callback finissent
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 seconde
                }
                
                print("✅ Données Week chargées:")
                print("   - Meals:", mealVM.mealList.count)
                print("   - APs:", userAPVM.APs.count)
            }
            .navigationDestination(isPresented: $navigateToMonth) {
                LandingPage()
                    .environment(loginVM)
                    .environment(APObjectiveVM)
                    .environment(dailyCalObjectiveVM)
                    .environment(weightObjectiveVM)
                    .environment(mealVM)
                    .environment(userAPVM)
                    .environment(userWeightVM)
                
                    
            }
            .onChange(of: selectedOption) { oldValue, newValue in
                            if newValue.lowercased() == "mois" {
                                navigateToMonth = true
                            }
                        }
        }
    }
}




#Preview {
    LandingPageWeek(selectedDate: Date())
        .environment(MealViewModel())
        .environment(UserAPViewModel())
        .environment(LoginViewModel())
        .environment(DailyCalObjectiveViewModel())
        .environment(APObjectiveViewModel())
        .environment(UserWeightViewModel())
        .environment(WeightObjectiveViewModel())
        .environment(FoodViewModel())
        .environment(APViewModel())
}
