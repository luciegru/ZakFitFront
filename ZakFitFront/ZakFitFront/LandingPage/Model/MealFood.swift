//
//  MealFood.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 01/12/2025.
//

import Foundation

struct MealFood: Codable, Identifiable, Equatable {
    let id: UUID
    let food: UUID
    let meal: UUID
    let quantityFood: Int
}
