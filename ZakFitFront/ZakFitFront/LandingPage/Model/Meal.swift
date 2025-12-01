//
//  Meal.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 30/11/2025.
//

import Foundation

struct Meal: Codable, Identifiable, Equatable {
    let id: UUID
    let user: UUID
    let type: String
    let date: Date
    let totalCal: Int
    let totalProt: Int
    let totalCarb: Int
    let totalLip: Int
}
