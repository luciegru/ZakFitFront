//
//  APObjective.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import Foundation

struct APObjective: Codable, Identifiable, Equatable {
    let id: UUID
    let user: UUID 
    let APTime: Int?
    let APNumber: Int?
    var burnedCal: Int?
    var startDate: Date?
    let endDate: Date?
    var interval: Int?
    var step: Int
    var sport: String?
    var timeToAdd: Int?
    
}
