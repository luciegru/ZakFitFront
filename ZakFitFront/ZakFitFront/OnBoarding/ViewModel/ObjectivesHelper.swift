//
//  ObjectivesHelper.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import Foundation

struct ObjectiveHelper {
    
    // MARK: - AP Objective Data Preparation
    
    static func prepareAPObjectiveData(
        objective: String,
        time: Int,
        number: Int,
        interval: String,
        sport: String,  // ✅ Ajouté
        calories: Int
    ) -> [String: Any] {
        
        var apTime = 0
        var apNumber = 0
        var burnedCal = 0
        var step = 0
        var timeToAdd = 0
        var intervalValue = 1
        var sportValue: String? = nil  // ✅ Ajouté
        
        switch objective {
        case "Augmenter":
            timeToAdd = time
            step = calculateIntervalDays(interval)
            intervalValue = step
            sportValue = sport  // ✅ Ajouté
            
        case "Brûler":
            burnedCal = calories
            intervalValue = calculateIntervalDays(interval)
            
        case "Faire (minutes)":
            apTime = time
            intervalValue = calculateIntervalDays(interval)
            sportValue = sport  // ✅ Ajouté
            
        case "Faire (séances)":
            apNumber = number
            intervalValue = calculateIntervalDays(interval)
            sportValue = sport  // ✅ Ajouté
            
        default:
            break
        }
        
        let startDate = Date.now
        let endDate = calculateEndDate(from: startDate, interval: interval)
        
        var data: [String: Any] = [
            "APTime": apTime,
            "APNumber": apNumber,
            "burnedCal": burnedCal,
            "startDate": DateFormatter.apiDateFormatter.string(from: startDate),
            "endDate": DateFormatter.apiDateFormatter.string(from: endDate),
            "interval": intervalValue,
            "step": step,
            "timeToAdd": timeToAdd
        ]
        
        // ✅ Ajoute sport seulement s'il est défini
        if let sportValue = sportValue {
            data["sport"] = sportValue
        }
        
        return data
    }

    // MARK: - Weight Objective Data Preparation
    
    static func prepareWeightObjectiveData(
        currentWeight: Double,
        healthObjective: String,
        weightToChange: Double,
        interval: Int,
        intervalUnit: String
    ) -> [String: Any]? {
        
        guard currentWeight > 0 else { return nil }
        
        var targetWeight = currentWeight
        
        switch healthObjective {
        case "Perte de poids":
            targetWeight -= weightToChange
        case "Prise de masse":
            targetWeight += weightToChange
        case "Maintient":
            break
        default:
            break
        }
        
        let startDate = Date.now
        let endDate = calculateWeightEndDate(from: startDate, interval: interval, unit: intervalUnit)
        
        return [
            "targetWeight": targetWeight,
            "startDate": DateFormatter.apiDateFormatter.string(from: startDate),
            "endDate": DateFormatter.apiDateFormatter.string(from: endDate)
        ]
    }
    
    // MARK: - Helper Methods
    
    private static func calculateIntervalDays(_ interval: String) -> Int {
        switch interval {
        case "jours": return 1
        case "semaines": return 7
        case "mois": return 30
        default: return 1
        }
    }
    
    private static func calculateEndDate(from startDate: Date, interval: String) -> Date {
        let calendar = Calendar.current
        switch interval {
        case "jours":
            return calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        case "semaines":
            return calendar.date(byAdding: .weekOfYear, value: 1, to: startDate) ?? startDate
        case "mois":
            return calendar.date(byAdding: .month, value: 1, to: startDate) ?? startDate
        default:
            return startDate
        }
    }
    
    private static func calculateWeightEndDate(from startDate: Date, interval: Int, unit: String) -> Date {
        let calendar = Calendar.current
        switch unit {
        case "semaines":
            return calendar.date(byAdding: .weekOfYear, value: interval, to: startDate) ?? startDate
        case "mois":
            return calendar.date(byAdding: .month, value: interval, to: startDate) ?? startDate
        default:
            return startDate
        }
    }
}
