//
//  Weight.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 02/12/2025.
//

import Foundation

struct UserWeight: Codable, Identifiable, Equatable {
    let id: UUID
    let user: UUID
    let weight: Double
    let date: Date
}
