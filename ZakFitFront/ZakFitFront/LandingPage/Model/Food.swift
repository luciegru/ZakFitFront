//
//  Food.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 01/12/2025.
//

import Foundation

struct Food: Codable, Identifiable, Equatable {
    let id: UUID
    let foodCategory: UUID
    let name: String
    let cal: Int
    let carb: Int
    let lip: Int
    let prot: Int
    let unit: String
    let unitWeightG: Int?
}
