//
//  History.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 04/12/2025.
//

import SwiftUI

struct History: View {
    
    @Environment(UserAPViewModel.self) var userAPVM
    @Environment(LoginViewModel.self) var loginVM
    @Environment(APViewModel.self) var apVM
    
    @State var color: Color = .white
    
    var body: some View {
        ZStack{
            Image(.background6)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack{
                Text("HISTORIQUE DES ACTIVITÉS")
                    .foregroundStyle(Color(.white))
                    .font(.system(size: 24, weight: .heavy))
                
                ScrollView{
                    ForEach(userAPVM.APs){ ap in
                        VStack{
                            HStack{
                                Text(ap.type)
                                    .font(.system(size: 16, weight: .bold))
                                
                                Spacer()
                                
                                Text(ap.date, format: .dateTime.day().month())
                                    .font(.system(size: 16, weight: .bold))
                            }.padding(.horizontal)
                                .padding(.top)
                            
                            HStack{
                                VStack{
                                    Text("\(ap.duration)")
                                        .font(.system(size: 32, weight: .bold))

                                    Text("MINUTES")
                                        .font(.system(size: 16, weight: .bold))

                                }.padding(.horizontal, 10)
                                VStack{
                                    Text("\(ap.burnedCal)")
                                        .font(.system(size: 32, weight: .bold))

                                    Text("CALORIES")
                                        .font(.system(size: 16, weight: .bold))

                                }.padding(.horizontal, 10)
                            }.padding()
                        }
                        .background(colorForType(ap.type))
                        .cornerRadius(20)
                        .padding(5)
                        
                    }
                    
                }
            }.padding(.top, 60)
        }.task {
            if let userId = loginVM.currentUser?.id {
                try? await userAPVM.getMyAP(userId: userId)
            }
        }
    }
    func colorForType(_ type: String) -> Color {
        switch type {
        case "course": return .customLightBlue
        case "marche": return .customGreen
        case "vélo": return .customLightPurple
        case "sport collectif": return .customLightYellow
        case "yoga": return .lightGrey
        default: return .customLightPink
        }
    }

}

#Preview {
    History().environment(UserAPViewModel())
        .environment(LoginViewModel())
        .environment(APViewModel())
}
