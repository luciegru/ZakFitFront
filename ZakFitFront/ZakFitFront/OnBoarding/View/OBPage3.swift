//
//  OBPage3.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 28/11/2025.
//

import SwiftUI

struct OBPage3: View {
    @Environment(LoginViewModel.self) private var loginVM
    @State var APObjVM: APObjectiveViewModel = APObjectiveViewModel()
    @State var WeightObjVM: WeightObjectiveViewModel = WeightObjectiveViewModel()
    
    @State var selectedHealthObjective: String = "Maintient"
    @State var selectedWeight: Double = 0
    @State var selectedInterval: Int = 0
    @State var selectedIntervalUnit: String = "semaine"
    
    @State private var showNext = false
    @State var isSelected: Bool = false
    
    @State var selectedAPObjective: String = "Brûler"
    @State var selectedAPTime: Int = 0
    @State var selectedAPSport: String = "sport"
    @State var selectedAPInterval: String = "jours"
    @State var selectedCals: Int = 0
    @State var selectedAPNumber: Int = 0
    @State var selectedAPStep: Int = 0
    @State var timeToAdd: Int = 0
    
    
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
                        HStack(alignment: .bottom){
                            
                            Button(action:{
                                isSelected.toggle()
                            }, label:{
                                ZStack {
                                    
                                    if isSelected {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 37, height: 37)
                                            .foregroundStyle(Color.customBlue)
                                    }
                                    
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.white, lineWidth: 2)
                                        .frame(width: 30, height: 30)
                                }
                            })
                            Text("Objectif d'activité physique")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 20)
                                .padding(.bottom,7)
                        }
                        if isSelected{
                            
                            CustomAPObjectivePicker(selectedAPObjective: $selectedAPObjective, selectedAPTime: $selectedAPTime, selectedAPSport: $selectedAPSport, selectedAPStep: $selectedAPStep, selectedAPInterval: $selectedAPInterval, selectedCals: $selectedCals, selectedAPNumbers: $selectedAPNumber)
                            
                            
                        }
                        
                    }
                    
                    Spacer()
                    
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            try await loginVM.updateCurrentUser(with: ["healthObjective": selectedHealthObjective])
                            
                            // ✅ Prépare les données AP
                            let apData = ObjectiveHelper.prepareAPObjectiveData(
                                objective: selectedAPObjective,
                                time: selectedAPTime,
                                number: selectedAPNumber,
                                interval: selectedAPInterval,
                                sport: selectedAPSport,
                                calories: selectedCals
                            )
                            try await APObjVM.createAPObjective(with: apData)
                            
                            // ✅ Prépare les données Weight
                            if let weightData = ObjectiveHelper.prepareWeightObjectiveData(
                                currentWeight: loginVM.currentUser?.weight ?? 0,
                                healthObjective: selectedHealthObjective,
                                weightToChange: selectedWeight,
                                interval: selectedInterval,
                                intervalUnit: selectedIntervalUnit
                            ) {
                                try await WeightObjVM.createWeightObjective(with: weightData)
                            }
                        }
                        showNext = true

                    }, label: {
                        
                        
                        Text("SUIVANT")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                        
                        
                    }).customButton()
                        .padding(.bottom, 60)
                    
                }.frame(width: 310)
                
            }
            
        }.navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $showNext) {
                OBPage4()
            }
        
        
    }
    
}



#Preview {
    OBPage3().environment(LoginViewModel())
}
