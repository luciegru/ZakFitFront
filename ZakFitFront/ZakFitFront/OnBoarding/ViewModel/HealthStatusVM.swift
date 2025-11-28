//
//  HealthStatusVM.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 28/11/2025.
//

func healthStatusVM(for bmi: Double) -> HealthStatus {
    switch bmi {
    case ..<18.5:
        return .underweight
    case 18.5..<25:
        return .normal
    case 25..<30:
        return .overweight
    case 30..<35:
        return .obesity1
    case 35..<40:
        return .obesity2
    default:
        return .obesity3
    }
}
