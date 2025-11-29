//
//  CalObjective.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import Foundation

struct DailyCalObjective: Codable, Identifiable, Equatable {
    let id: UUID
    let user: UUID
    let cal: Int?
    let prot: Int?
    var carb: Int?
    var lip: Int?
}
