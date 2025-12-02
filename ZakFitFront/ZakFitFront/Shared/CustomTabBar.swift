//
//  CustomTabBar.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        ZStack {
            Image("tabbar-bg")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(edges: .bottom)
                .frame(width: 360)

            HStack(spacing: 40) {
                tabItem(.calendrier, active: "Calendar_active", inactive: "Calendar_inactive")
                    .offset(x: -25, y: 10)
                tabItem(.dashboard, active: "Dashboard_active", inactive: "Dashboard_inactive")
                    .offset(x: -10, y: 10)
                tabItem(.profil, active: "Profil_active", inactive: "Profil_inactive")
                    .offset(x: 10, y: 10)
                tabItem(.historique, active: "History_active", inactive: "History_inactive")
                    .offset(x: 25, y: 10)
            }
            .padding(.bottom, 20)
        }
        .frame(height: 100)
    }

    @ViewBuilder
    func tabItem(_ tab: Tab, active: String, inactive: String) -> some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        } label: {
            Image(selectedTab == tab ? active : inactive)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.calendrier))
}
