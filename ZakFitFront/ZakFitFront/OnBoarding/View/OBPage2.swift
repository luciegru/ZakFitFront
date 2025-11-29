//
//  OBPage2.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 27/11/2025.
//


import SwiftUI

struct OBPage2: View {
    @Environment(LoginViewModel.self) private var loginVM
    @State var selectedGenre: String = "Homme"
    @State var selectedWeight: Double = 70.0
    @State var selectedHeight: Int = 180
    @State var selectedDate: Date = Date.now
    @State private var showNext = false
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image(.background3)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Text("QUI ES-TU ?")
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                        .padding(.bottom,30)
                    
                    
                    VStack{
                        HStack{
                            Text("Genre")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                        
                        HStack{
                            CustomDropdownMenu(selectedOption: $selectedGenre, options: ["femme", "homme", "autre"])
                            Spacer()
                        }.padding(.leading)
                    }.padding(.bottom, 20)
                    
                    
                    VStack{
                        HStack{
                            Text("Poids")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        
                        HStack{
                            CustomStepper(selectedOption: $selectedWeight)
                            Spacer()
                        }.padding(.leading)
                    }.padding(.bottom, 20)
                    
                    
                    VStack{
                        HStack{
                            Text("Taille")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        
                        HStack{
                            CustomStepper(selectedOption: Binding(
                                get: { Double(selectedHeight) },
                                set: { selectedHeight = Int($0) }
                            ))
                            
                            Spacer()
                        }.padding(.leading)
                    }.padding(.bottom, 20)
                    
                    VStack{
                        HStack{
                            Text("Date de naissance")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 20)
                                .padding(.bottom,7)
                            Spacer()
                        }
                        
                        HStack{
                            CustomDatePicker(selectedDate: $selectedDate)
                            Spacer()
                        }.padding(.leading)
                    }
                    
                    Spacer()
                    
                    let imc = selectedWeight / pow(Double(selectedHeight) / 100, 2)
                    let status = healthStatusVM(for: imc)
                    
                    Text(imc.formatted(.number.precision(.fractionLength(1))))
                        .font(.system(size: 64, weight: .medium))
                        .foregroundStyle(Color.customBlue)
                    
                    Text(status.rawValue)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.customBlue)
                    
                    Spacer()
                    
                    
                    Button("SUIVANT") {
                        Task {
                            do {
                                try await loginVM.updateCurrentUser(with: [
                                    "genre": selectedGenre,
                                    "weight": selectedWeight,
                                    "height": selectedHeight,
                                    "birthDate": ISO8601DateFormatter().string(from: selectedDate)
                                ])
                                showNext = true
                            } catch {
                                print("Erreur updateUser:", error)
                            }
                        }
                    }
                    .customButton()
                    .padding(.bottom, 60)
                    .foregroundStyle(Color.black)
                    .font(Font.system(size: 16, weight: .bold))
                    
                }
                
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
                OBPage3().environment(loginVM)
                
            }
    }
}

#Preview {
    OBPage2().environment(LoginViewModel())
}
