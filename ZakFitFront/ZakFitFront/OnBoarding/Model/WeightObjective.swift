//
//  WeightObjective.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//


import Foundation

struct WeightObjective: Codable, Identifiable, Equatable {
    let id: UUID
    let idUser: UUID
    let targetWeight: Double?
    let startDate: Date?
    var endDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case idUser = "user"  // ✅ Map vers "user"
        case targetWeight, startDate, endDate
    }

}
