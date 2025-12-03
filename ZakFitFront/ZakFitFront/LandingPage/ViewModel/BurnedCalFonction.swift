//
//  BurnedCalFonction.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 03/12/2025.
//

import Foundation

func burnedCalCalcul(activity: String, intensity: String, durationMin: Double, weightKg: Double) -> Int {
    let mets: [String: [String: Double]] = [
        "marche": ["basse": 2.5, "moyenne": 3.5, "haute": 5],
        "course": ["basse": 6, "moyenne": 9, "haute": 12],
        "vélo": ["basse": 4, "moyenne": 6, "haute": 10],
        "sport collectif": ["basse": 5, "moyenne": 7, "haute": 10],
        "yoga": ["basse": 2, "moyenne": 3, "haute": 4],
        "musculation": ["basse": 3, "moyenne": 4.5, "haute": 6]
    ]
    
    guard let activityMets = mets[activity.lowercased()],
          let met = activityMets[intensity.lowercased()] else { return 0 }
    
    return Int(met * weightKg * durationMin / 60)
}
