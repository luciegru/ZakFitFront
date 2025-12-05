//
//  AP.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 30/11/2025.
//

import Foundation

struct AP: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date
    let duration: Int
    let intensity: String
    let type: String
    let burnedCal: Int
}

