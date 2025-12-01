//
//  UserAP.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 30/11/2025.
//

import Foundation

struct UserAP: Codable, Identifiable, Equatable {
    let id: UUID
    let user: UUID
    let AP: UUID
    let date: Date
}
