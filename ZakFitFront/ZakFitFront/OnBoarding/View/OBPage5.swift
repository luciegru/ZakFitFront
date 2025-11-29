//
//  OBPage5.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import SwiftUI

struct OBPage5: View {
    
    @Environment(LoginViewModel.self) private var loginVM
    @State var foodPreferenceVM: FoodPreferenceViewModel = FoodPreferenceViewModel()
    @State var userFoodPreferenceVM: UserFoodPreferenceViewModel = UserFoodPreferenceViewModel()
    
    @State var selectedFoodPreferences: [FoodPreference] = []
    @State private var showNext = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image(.background4)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Text("MIAM")
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                        .padding(.bottom,30)
                    
                    
                    Text("Est-ce que tu suis un régime particulier ? ")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        .padding(.bottom,30)
                    
                    
                    
                    Spacer()
                    HStack{
                        ForEach(foodPreferenceVM.foodPrefs.prefix(3)) { index in
                            Button(action:{
                                if selectedFoodPreferences.contains(index){
                                    selectedFoodPreferences.remove(at: selectedFoodPreferences.firstIndex(of: index) ?? 0)
                                } else {
                                    selectedFoodPreferences.append(index)
                                }
                            }, label:{
                                VStack{
                                    Text(index.name)
                                        .fixedSize()
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(selectedFoodPreferences.contains(index) ? Color.black : Color.white)
                                        .padding(10)
                                }.frame(height: 50)
                                    .background(selectedFoodPreferences.contains(index) ? Color.customPink : Color.darkGrey)
                                    .cornerRadius(5)
                            })
                            
                        }
                        
                        
                    }.padding(.horizontal)
                    HStack{
                        ForEach(foodPreferenceVM.foodPrefs.dropFirst(3).prefix(3)) { index in
                            Button(action:{
                                if selectedFoodPreferences.contains(index){
                                    selectedFoodPreferences.remove(at: selectedFoodPreferences.firstIndex(of: index) ?? 0)
                                } else {
                                    selectedFoodPreferences.append(index)
                                }
                            }, label:{
                                VStack{
                                    Text(index.name)
                                        .fixedSize()
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(selectedFoodPreferences.contains(index) ? Color.black : Color.white)
                                        .padding(10)
                                }.frame(height: 50)
                                    .background(selectedFoodPreferences.contains(index) ? Color.customPink : Color.darkGrey)
                                    .cornerRadius(5)
                                    .padding(.horizontal, 6)
                                    .frame(maxWidth: 320)
                            })
                        }
                        
                        
                    }.padding(.horizontal)
                    HStack{
                        ForEach(foodPreferenceVM.foodPrefs.dropFirst(6).prefix(3)) { index in
                            Button(action:{
                                if selectedFoodPreferences.contains(index){
                                    selectedFoodPreferences.remove(at: selectedFoodPreferences.firstIndex(of: index) ?? 0)
                                } else {
                                    selectedFoodPreferences.append(index)
                                }
                            }, label:{
                                VStack{
                                    Text(index.name)
                                        .fixedSize()
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(selectedFoodPreferences.contains(index) ? Color.black : Color.white)
                                        .padding(10)
                                }.frame(height: 50)
                                    .background(selectedFoodPreferences.contains(index) ? Color.customPink : Color.darkGrey)
                                    .cornerRadius(5)
                                    .padding(.horizontal, 3)
                                    .frame(maxWidth: 310)
                            })
                        }
                        
                        
                    }.padding(.horizontal)
                    HStack{
                        ForEach(foodPreferenceVM.foodPrefs.dropFirst(9).prefix(3)) { index in
                            Button(action:{
                                if selectedFoodPreferences.contains(index){
                                    selectedFoodPreferences.remove(at: selectedFoodPreferences.firstIndex(of: index) ?? 0)
                                } else {
                                    selectedFoodPreferences.append(index)
                                }
                            }, label:{
                                VStack{
                                    Text(index.name)
                                        .fixedSize()
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(selectedFoodPreferences.contains(index) ? Color.black : Color.white)
                                        .padding(10)
                                }.frame(height: 50)
                                    .background(selectedFoodPreferences.contains(index) ? Color.customPink : Color.darkGrey)
                                    .cornerRadius(5)
                                //                                    .padding(.horizontal,)
                                    .frame(maxWidth: 310)
                            })
                        }
                        
                        
                    }.padding(.horizontal)
                    HStack{
                        ForEach(foodPreferenceVM.foodPrefs.dropFirst(12).prefix(3)) { index in
                            Button(action:{
                                if selectedFoodPreferences.contains(index){
                                    selectedFoodPreferences.remove(at: selectedFoodPreferences.firstIndex(of: index) ?? 0)
                                } else {
                                    selectedFoodPreferences.append(index)
                                }
                            }, label:{
                                VStack{
                                    Text(index.name)
                                        .fixedSize()
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(selectedFoodPreferences.contains(index) ? Color.black : Color.white)
                                        .padding(10)
                                }.frame(height: 50)
                                    .background(selectedFoodPreferences.contains(index) ? Color.customPink : Color.darkGrey)
                                    .cornerRadius(5)
                                    .padding(.horizontal, -2)
                                    .frame(maxWidth: 200)
                            })
                        }
                        
                        
                    }.padding(.horizontal)
                    HStack{
                        ForEach(foodPreferenceVM.foodPrefs.dropFirst(15).prefix(3)) { index in
                            Button(action:{
                                if selectedFoodPreferences.contains(index){
                                    selectedFoodPreferences.remove(at: selectedFoodPreferences.firstIndex(of: index) ?? 0)
                                } else {
                                    selectedFoodPreferences.append(index)
                                }
                            }, label:{
                                VStack{
                                    Text(index.name)
                                        .fixedSize()
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(selectedFoodPreferences.contains(index) ? Color.black : Color.white)
                                        .padding(10)
                                }.frame(height: 50)
                                    .background(selectedFoodPreferences.contains(index) ? Color.customPink : Color.darkGrey)
                                    .cornerRadius(5)
                                    .padding(.horizontal, 9.99999)
                                    .frame(maxWidth: 200)
                            })
                        }
                        
                        
                    }.padding(.horizontal)
                    HStack{
                        ForEach(foodPreferenceVM.foodPrefs.dropFirst(18).prefix(3)) { index in
                            Button(action:{
                                if selectedFoodPreferences.contains(index){
                                    selectedFoodPreferences.remove(at: selectedFoodPreferences.firstIndex(of: index) ?? 0)
                                } else {
                                    selectedFoodPreferences.append(index)
                                }
                            }, label:{
                                VStack{
                                    Text(index.name)
                                        .fixedSize()
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(selectedFoodPreferences.contains(index) ? Color.black : Color.white)
                                        .padding(10)
                                    
                                }.frame(height: 50)
                                    .background(selectedFoodPreferences.contains(index) ? Color.customPink : Color.darkGrey)
                                    .cornerRadius(5)
                                //                                    .padding(.horizontal, 100)
                                    .frame(maxWidth: 200)
                            })
                            Spacer()
                        }
                        
                        
                    }.padding(.horizontal)
                    
                    
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        
                        Task{
                            for preference in selectedFoodPreferences {
                                await userFoodPreferenceVM.createUserFoodPreference(with: ["foodPreference": preference.id.uuidString])
                            }
                            
                            try await loginVM.updateCurrentUser(with: ["onboardingDone" : true])
                            
                            showNext = true
                            
                        }
                        
                        
                        
                    }, label: {
                        
                        
                        Text("TERMINER")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                        
                        
                    }).customButton()
                        .padding(.bottom, 60)
                    
                }.frame(width: 350)
                
                
                
            }
            
        }.navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $showNext) {
                LandingPage()
            }
            .task{
                await foodPreferenceVM.getAllFoodPreference()
            }
        
        
    }
}

#Preview {
    OBPage5().environment(LoginViewModel())
}
