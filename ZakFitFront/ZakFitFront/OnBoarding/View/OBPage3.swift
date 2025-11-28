//
//  OBPage3.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 28/11/2025.
//

import SwiftUI

struct OBPage3: View {
    @Environment(LoginViewModel.self) private var loginVM
    
    @State var selectedHealthObjective: String = "Maintient"
    @State var selectedWeight: Double = 0
    @State var selectedInterval: Int = 0
    @State var selectedIntervalUnit: String = "Jours"
    
    @State private var showNext = false
    
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image(.background4)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Text("TES OBJECTIFS")
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                        .padding(.bottom,30)
                    
                    
                    VStack{
                        HStack{
                            Text("Objectif de santé")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                        
                        HStack{
                            
                            CustomDropdownMenu(selectedOption: $selectedHealthObjective, options: ["Prise de masse", "Perte de poids", "Maintient"])
                            Spacer()
                        }.padding(.leading)
                    }.padding(.bottom, 20)
                    
                    
                    VStack{
                        HStack{
                            Text("Objectif de poids")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        
                        if selectedHealthObjective == "Maintient" {
                            EmptyView()
                        } else {
                            CustomWeightObjectivePicker(healthObjective: $selectedHealthObjective, selectedWeight: $selectedWeight, selectedInterval: $selectedInterval, selectedIntervalUnit: $selectedIntervalUnit)
                        }
                    }.padding(.bottom, 20)
                    
                    
                    
                    HStack{
                        Image(.zakClueLess)
                        
                        Text("D'après mes calculs, tu \(WeightTarget(weight:loginVM.currentUser?.weight ?? 0, heightcm: loginVM.currentUser?.height ?? 0)) Après tu fais ce que tu veux hein...")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 15))
                    }
                    
                    
                    
                    VStack{
                        HStack{
                            Text("Date de naissance")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 20)
                                .padding(.bottom,7)
                            Spacer()
                        }
                        
                        HStack{
                            Spacer()
                        }.padding(.leading)
                    }
                    
                    Spacer()
                    
                    
                    Spacer()
                    
                    
                    Button(action: {
                        Task{
                        }
                        showNext = true
                        
                    }, label: {
                        
                        
                        Text("SUIVANT")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                        
                        
                    }).customButton()
                        .padding(.bottom, 60)
                    
                }.frame(width: 310)
                
                VStack{
                    Text("Tadaaa !  Ton IMC en un temps record !")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white)
                        .frame(width: 220)
                        .multilineTextAlignment(.center)
                    
                    Image(.zakPointing)
                }.offset(x: -120, y: 230)
                
            }
            
        }.navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $showNext) {
                OBPage1()
            }
        
        
    }
    
}



#Preview {
    OBPage3().environment(LoginViewModel())
}
