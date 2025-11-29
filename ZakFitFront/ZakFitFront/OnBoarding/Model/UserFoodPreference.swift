//
//  UserFoodPreference.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import Foundation

struct UserFoodPreference: Codable, Identifiable, Equatable {
    let id: UUID
    let user: UUID
    let foodPreference: UUID
}
