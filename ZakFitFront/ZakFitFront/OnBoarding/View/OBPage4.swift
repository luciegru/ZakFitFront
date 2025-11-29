//
//  OBPage4.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import SwiftUI

struct OBPage4: View {
    @State var dailyCalObjectiveVM: DailyCalObjectiveViewModel = DailyCalObjectiveViewModel()
    
    @State private var showNext = false
    @State var isCalSelected: Bool = false
    @State var isMacroSelected: Bool = false
    
    @State var calObjective: Int = 0
    @State var protObjective: Int = 0
    @State var carbObjective: Int = 0
    @State var lipObjective: Int = 0
    
    
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
                    
                    
                    HStack{
                        Image(.zakPointing)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        
                        Text("Mon super algorithme et moi on a une proposition pour toi")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 15))
                    }
                        
                        VStack{
                            HStack(alignment: .bottom){
                                
                                Button(action:{
                                    isCalSelected.toggle()
                                    calObjective = 500
                                }, label:{
                                    ZStack {
                                        
                                        if isCalSelected {
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
                                Text("Objectif calorique journalier")
                                    .foregroundStyle(Color.white)
                                    .padding(.leading, 20)
                                    .padding(.bottom,7)
                                
                                Spacer()
                            }.padding()
                            if isCalSelected{
                                
                                CustomCalObjectivePicker(calObjective: $calObjective)
                                    
                                
                            }
                            
                        }
                        
                    
                    
                        Spacer()
                        
                    VStack(){
                        HStack(alignment: .center){
                            
                            Button(action:{
                                isMacroSelected.toggle()
                                protObjective = 50
                                carbObjective = 50
                                lipObjective = 50
                            }, label:{
                                ZStack {
                                    
                                    if isMacroSelected {
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
                            
                            Text("Objectif journalier macronutriments")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 20)
                                .padding(.bottom,7)
                            
                            Spacer()
                        }.padding()
                        if isMacroSelected{
                            
                            CustomMacroObjectivePicker(protObjective: $protObjective, carbObjective: $carbObjective, lipObjective: $lipObjective)
                            
                        }
                        
                    }

                        Spacer()
                        Spacer()
                        
                        Button(action: {
                            
                            Task{
                                try await dailyCalObjectiveVM.createDailyCalObjective(with: ["cal" : calObjective, "prot" : protObjective, "carb": carbObjective, "lip": lipObjective])
                                
                                showNext = true
                            }
                            
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
                    OBPage5()
                }
            
            
        }
        
    }


#Preview {
    OBPage4()
}
