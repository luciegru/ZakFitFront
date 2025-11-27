//
//  User.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 27/11/2025.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let firstName: String
    let email: String
    var height: Int?
    var weight: Double?  
    let genre: String?
    var inscriptionDate: Date?
    var picture: String?
    var birthDate: Date?
    var healthObjective: String?
    var onboardingDone:Bool
}
