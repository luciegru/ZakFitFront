//
//  CustomProgressView.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 30/11/2025.
//

import SwiftUI

struct CustomProgressView: View {
    var color: Color = .blue
    var actual: Int = 900
    var target: Int = 1300
    
    var body: some View {
        ZStack(alignment: .leading){
            Rectangle()
                .frame(width: 200, height: 13)
                .foregroundStyle(Color.middleGrey)
                .cornerRadius(20)
            
            HStack{
               
                Rectangle()
                    .frame(width: CGFloat(Double(actual >= target ? target : actual)/Double(target)*200), height: 13)
                    .foregroundStyle(color)
                    .cornerRadius(20)
            }
            
        }.frame(width: 200)

    }
}

#Preview {
    CustomProgressView()
}
