//
//  OBPage1.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 27/11/2025.
//

import SwiftUI

struct OBPage1: View {

    @Environment(LoginViewModel.self) private var loginVM
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image(.background2)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Text("QUI ES-TU ?")
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    Text("Salut, moi c’est Zak, ton coach !\n\nJe vais t’aider à devenir un monstre ! Mais pour ça, il faut déjà que j’apprenne un peu mieux à te connaître. T’as 2 minutes ? ")
                        .frame(width: 260)
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                    
                    Image(.zakStandingStill)
                    
                    Spacer()
                    
                    
                    NavigationLink {
                        OBPage2().environment(loginVM)
                    } label: {
                        Text("GO !")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                    }.customButton()
                        .padding(.bottom, 60)

                }

            }
            
            
        }
    }
}

#Preview {
    OBPage1().environment(LoginViewModel())
}
