//
//  SignUpView.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 27/11/2025.
//

import SwiftUI

struct SignUpView: View {
    
    @State var name: String = ""
    @State var firstname: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordConfirmation: String = ""
    @State var response: String = ""
    @Environment(LoginViewModel.self) private var loginVM

    var body: some View {
        
        NavigationStack{
            ZStack{
                //Image de fond
                Image(.background1)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Text("NOUVEAU ICI ?")
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    TextFieldCustom(text: "Nom", binding: $name, secure: false)
                    
                    TextFieldCustom(text: "Prénom", binding: $firstname, secure: false)
                    
                    TextFieldCustom(text: "Adresse Mail", binding: $email, secure: false)
                    
                    TextFieldCustom(text: "Mot de passe", binding: $password, secure: true)
                    
                    TextFieldCustom(text: "Confirmation du mot de passe", binding: $passwordConfirmation, secure: true)
                    
                    
                    
                    Text(response)
                        .foregroundStyle(Color.customLightPink)
                        .bold()

                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("J'ai déjà un compte")
                            .foregroundStyle(Color.white)
                            .padding(.vertical, 20)
                    }

                    Button(action:{
                        response = ""
                        if password != passwordConfirmation {
                            response = "Les mots de passe ne correspondent pas"
                        } else if name.isEmpty || firstname.isEmpty || email.isEmpty || password.isEmpty || passwordConfirmation.isEmpty {
                            response = "Veuillez remplir tous les champs"
                        } else if !email.contains("@") && !email.contains(".fr") || !email.contains(".com") {
                            response = "Veuillez entrer une adresse mail valide"
                        } else {
                            Task {
                                
                                try await loginVM.createUser(name: name, firstName: firstname , email: email, password: password, onboardingDone: false)
                                
                                if let error = loginVM.errorMessage {
                                    response = error
                                }
                                
                                
                                if loginVM.isAuthenticated {
                                    print("user créé")
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
                
                Image(.zakFlex)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .offset(x: 125, y: -188)
            }
        }.navigationBarBackButtonHidden()
    }
}


#Preview {
    SignUpView().environment(LoginViewModel())
}
