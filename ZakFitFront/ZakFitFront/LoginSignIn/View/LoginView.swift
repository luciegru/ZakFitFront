//
//  LoginView.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 27/11/2025.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""

    @State var response: String = ""
    
    @Environment(LoginViewModel.self) private var loginVM
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                //Image de fond
                Image(.background1)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Text("CONNEXION")
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    
                    
                    TextFieldCustom(text: "Adresse mail", binding: $email, secure: false)
                    
                    TextFieldCustom(text: "Mot de passe", binding: $password, secure: true)
                    
                    
                    
                    Spacer()
                    
                    Text(response)
                        .foregroundStyle(Color.customLightPink)
                        .bold()
                    
                    
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Créer un compte")
                            .foregroundStyle(Color.white)
                            .padding(.vertical, 20)
                    }
                    
                    Button(action:{
                        response = ""
                        
                        if email.isEmpty || password.isEmpty {
                            response = "Veuillez remplir tous les champs"
                        }  else {
                            
                            Task{
                                try await loginVM.login(email: email, password: password)
                                
                                if let error = loginVM.errorMessage {
                                    response = error
                                }
                                
                                if loginVM.isAuthenticated {
                                    print("user créé avec succès")
                                    
                                    
                                }
                            }
                        }
                    }, label:{
                        
                        Text("GO !")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                    }).customButton()
                        .padding(.bottom, 70)
                    
                }
                
                Image(.zakFlexShowingOut)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .offset(x: 125, y: -159)
            }
        }.navigationBarBackButtonHidden()
    }
    
}


#Preview {
    LoginView()
}
