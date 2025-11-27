//
//  CustomButton.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 27/11/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func customButton(
        cornerRadius: CGFloat = 10,
        color: Color = .customBlue,
        frameWidth: CGFloat? = 174,
        frameHeight: CGFloat? = 50

    ) -> some View {
        
            self
            .frame(width: frameWidth, height: frameHeight)
            .background(color)
            .cornerRadius(cornerRadius)

    }
}
