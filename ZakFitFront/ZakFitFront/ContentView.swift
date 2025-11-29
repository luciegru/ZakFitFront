//
//  ContentView.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 23/11/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State var loginVM = LoginViewModel()

    var body: some View {
        VStack {
            if !loginVM.isAuthenticated {
                LoginView()
            } else if loginVM.isAuthenticated && loginVM.currentUser?.onboardingDone == true {
                LandingPage()

            } else {
                OBPage1()

            }


        }.environment(loginVM)
    }
}

#Preview {
    ContentView()
}
