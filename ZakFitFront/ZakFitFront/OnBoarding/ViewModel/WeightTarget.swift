//
//  WeightTarget.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 28/11/2025.
//

import Foundation

func WeightTarget(weight: Double, heightcm: Int) -> String {
    let height = Double(heightcm) / 100.0   // conversion en mètres
    
    let bmi = weight / (height * height)
    
    let minWeight = 18.5 * height * height
    let maxWeight = 25.0 * height * height
    
    let target = bmi < 18.5 ? minWeight : maxWeight
    
    let diff = target - weight
    let roundedDiff = (diff * 10).rounded() / 10.0

    switch bmi {
    case ..<18.5:
        return "devrais gagner \(abs(roundedDiff)) kg."
        
    case 18.5...24.9:
        return "peux viser le maintien."
        
    case 25...:
        return "devrais perdre \(abs(roundedDiff)) kg."
        
    default:
        return "es au-dessus de ton poids idéal. Objectif raisonnable : -\(abs(roundedDiff)) kg. Pour un suivi personnalisé, n’hésite pas à consulter un professionnel."
    }
}
