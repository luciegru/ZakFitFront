//
//  ActivityCount.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 04/12/2025.
//

import Foundation

struct ActivityCount: Identifiable {
    let id = UUID()
    let type: String
    let count: Int
}
