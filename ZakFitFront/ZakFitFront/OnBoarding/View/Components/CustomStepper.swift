//
//  CustomStepper.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 27/11/2025.
//

import SwiftUI

struct CustomStepper: View {
    
    @Binding var selectedOption: Double
    
    
    var body: some View {

        HStack{
            Button(action: {
                selectedOption -= 1
            }, label: {
                Text("-")
                    .foregroundStyle(Color.white)
                    .font(Font.system(size: 20))
                    .bold()

            })
            
            
            TextField(selectedOption.description, value: $selectedOption, format: .number)
                .font(Font.system(size: 20))
                .foregroundColor(.white)
                .bold()
                .frame(width: 60)
                .multilineTextAlignment(.center)
            
            
            Button(action: {
                selectedOption += 1
            }, label: {
                Text("+")
                    .foregroundStyle(Color.white)
                    .font(Font.system(size: 20))
                    .bold()
            })
        }.frame(width: 130, height: 50)
            .background(Color.middleGrey)
            .cornerRadius(5)

    }
}

//#Preview {
//    CustomStepper()
//}
