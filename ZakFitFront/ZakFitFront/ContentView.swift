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
                LoginView().environment(loginVM)
            } else if loginVM.isAuthenticated && loginVM.currentUser?.onboardingDone == true {
                //LandingPageView()

            } else {
                OBPage1().environment(loginVM)

            }


        }
        .environment(loginVM)
    }
}

#Preview {
    ContentView()
}
