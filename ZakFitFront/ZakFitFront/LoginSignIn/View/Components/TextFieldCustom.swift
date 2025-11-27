//
//  TextFieldCustom.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 27/11/2025.
//

import SwiftUI

struct TextFieldCustom: View {
    
    var text: String
    var binding: Binding<String>
    var secure: Bool
    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.darkGrey)
                        .frame(width: 290, height: 40)

                    if !secure {
                        
                        TextField("", text: binding)
                            .frame(width: 260, height: 40)
                            .background(Color.black.opacity(0.00001))
                            .foregroundStyle(Color.white)
                            .textInputAutocapitalization(.never)
                        
                    } else {
                        SecureField("", text: binding)
                            .frame(width: 260, height: 40)
                            .background(Color.black.opacity(0.00001))
                            .foregroundStyle(Color.white)
                            .textInputAutocapitalization(.never)
                    }
                }
            }
        }.padding(.vertical, 15)
    }
}

//#Preview {
//    TextFieldCustom()
//}
