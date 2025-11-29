//
//  FoodPreference.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import Foundation

struct FoodPreference: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
}
