//
//  ProfilView.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 04/12/2025.
//

import SwiftUI

struct ProfilView: View {
    
    @Environment(LoginViewModel.self) var loginVM
    @Environment(UserFoodPreferenceViewModel.self) var userFoodPrefVM
    @Environment(FoodPreferenceViewModel.self) var foodPrefVM
    @Environment(UserWeightViewModel.self) var userWeightVM
    @Environment(WeightObjectiveViewModel.self) var weightObjVM
    @Environment(UserAPViewModel.self) var userAPVM
    @Environment(APObjectiveViewModel.self) var APObjVM
    @Environment(DailyCalObjectiveViewModel.self) var dailyCalObjVM
    @Environment(MealViewModel.self) var mealVM
    
    @State var showWeightSheet: Bool = false
    var body: some View {
        
        ZStack{
            Image(.background6)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack{
                
                ScrollView{
                    
                    ZStack{
                        AsyncImage(url: URL(string: loginVM.currentUser?.picture ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 126, height: 126)
                                .cornerRadius(100)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }.padding(.top, 80)
                        
                        Image(.zakFlex)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .position(x:290, y:118)

                    }
                    
                    Text(loginVM.currentUser?.firstName ?? "")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 20))
                    Text(loginVM.currentUser?.name ?? "")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 18))
                    Text(loginVM.currentUser?.email ?? "")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 10))
                    
                    Text("Régime alimentaire :")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 20))
                        .padding(.top, 15)
                    HStack {
                        ForEach(userFoodPrefVM.myUserFoodPrefs) { myUserPref in
                            if let pref = foodPrefVM.foodPrefs.first(where: { $0.id == myUserPref.foodPreference }) {
                                Text(pref.name)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                            }
                        }
                    }
                    
                    
                    Button(action: {}, label:{
                        HStack(alignment: .center){
                            Spacer()
                            Text("Modifier mes informations")
                                .foregroundStyle(Color.white)
                                .font(.system(size: 20))
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.white)
                                .padding(20)
                            
                            
                        }})
                    
                    HStack {
                        
                        ZStack{
                            Image(.zakWeight)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                            
                            Text(String(format: "%.1f", loginVM.currentUser?.weight ?? 0)
                            )
                            .foregroundStyle(Color.white)
                            .font(.system(size: 20))
                            .position(x:84, y:172)
                            
                        }.frame(height: 200)
                            .padding(.trailing, -50)
                        
                        HStack{
                            Image(.arrowUp)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                            
                            Text("\(loginVM.currentUser?.height ?? 0) centimètres")
                                .foregroundStyle(Color.white)
                                .font(.system(size: 20))
                                .rotationEffect(Angle(degrees: 90))
                                .padding(-60)
                                .padding(.top, 100)
                            
                        }
                        
                        Spacer(minLength: 50)
                        
                        VStack{
                            let imc = (loginVM.currentUser?.weight ?? 0) / pow(Double(loginVM.currentUser?.height ?? 0) / 100, 2)
                            let status = healthStatusVM(for: imc)
                            
                            Text("IMC")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(Color.customYellow)
                            
                            Text(imc.formatted(.number.precision(.fractionLength(1))))
                                .font(.system(size: 64, weight: .medium))
                                .foregroundStyle(Color.white)
                            
                            Text(status.rawValue)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.white)
                            
                            
                        }
                        
                        
                    }
                    //                .padding(20)
                    
                    
                    Button(action: {
                        showWeightSheet.toggle()
                    }, label:{
                        HStack(alignment: .center){
                            Spacer()
                            Text("Modifier mon poids")
                                .foregroundStyle(Color.white)
                                .font(.system(size: 20))
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.white)
                                .padding(20)
                            
                            
                        }}).sheet(isPresented: $showWeightSheet, onDismiss: {
                            Task {
                            }
                        }) {
                            WeightSheet()
                                .environment(loginVM)
                                .environment(userWeightVM)
                        }
                    
                    
                    Text("Mon objectif de santé : ")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.white)
                    Text(loginVM.currentUser?.healthObjective ?? "")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.white)
                    
                    
                    DailyTips()
                        .environment(loginVM)
                        .environment(userAPVM)
                        .environment(APObjVM)
                        .environment(dailyCalObjVM)
                        .environment(weightObjVM)
                        .environment(mealVM)
                        .padding()
                        .background(Color.customPink)
                        .cornerRadius(20)


                    Button(action: {}, label:{
                        HStack(alignment: .center){
                            Spacer()
                            Text("Modifier mes objectifs")
                                .foregroundStyle(Color.white)
                                .font(.system(size: 20))
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.white)
                                .padding(20)
                            
                            
                        }})
                    
                    Button(action: {}, label:{
                        HStack(alignment: .center){
                            Spacer()
                            Text("Gérer mes notifications")
                                .foregroundStyle(Color.white)
                                .font(.system(size: 20))
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.white)
                                .padding(20)
                            
                            
                        }})
                    
                    Button(action: {
                        Task{
                            loginVM.logout()
                        }
                    }, label: {
                        
                        Text("SE DÉCONNECTER")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 30, weight: .bold))
                            .padding(10)
                            .background(Color.customBlue)
                            .cornerRadius(10)
                    })
                    
                
                    Button(action: {}, label: {
                        
                        Text("Supprimer mon compte")
                            .foregroundStyle(Color.customLightPink)
                            .font(.system(size: 20, weight: .bold))
                            .padding(10)
                    }).padding(.bottom, 160)
                    
                }
                
                
                    
                }
                
            
        }.task {
            
            if let userId = loginVM.currentUser?.id {
                try? await userFoodPrefVM.getMyUserFoodPreference(userId: userId)
            }
            try? await foodPrefVM.getAllFoodPreference()
            
            await APObjVM.getMyAPObjective()
            try? await dailyCalObjVM.getMyDailyCalObjective()
            try? await weightObjVM.getMyWeightObjective()
            
            if let userId = loginVM.currentUser?.id {
                await mealVM.getMyMeal()
                await userAPVM.getMyAP(userId: userId)
                
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }


        }
    }
}

#Preview {
    ProfilView().environment(LoginViewModel()).environment(UserFoodPreferenceViewModel())
        .environment(FoodPreferenceViewModel())
        .environment(UserWeightViewModel())
        .environment(WeightObjectiveViewModel())
        .environment(UserAPViewModel())
        .environment(APObjectiveViewModel())
        .environment(DailyCalObjectiveViewModel())
        .environment(MealViewModel())
}
