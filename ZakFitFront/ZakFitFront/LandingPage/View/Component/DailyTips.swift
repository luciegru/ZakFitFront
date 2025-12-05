//
//  DailyTips.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 30/11/2025.
//

import SwiftUI

struct DailyTips: View {
    @Environment(APObjectiveViewModel.self) var APObjVM
    @Environment(UserAPViewModel.self) var userAPVM
    @Environment(LoginViewModel.self) var loginVM
    @Environment(DailyCalObjectiveViewModel.self) var calObjVM
    @Environment(WeightObjectiveViewModel.self) var weightObjVM
    @Environment(MealViewModel.self) var mealVM
    @Environment(UserWeightViewModel.self) var weightVM
    
    // MARK: - Objectif AP (calories brûlées)
    private var apProgress: (actual: Int, target: Int, text: String, show: Bool) {
        guard let objective = APObjVM.APObj else {
            return (0, 0, "Fixe un objectif d'activité", false)
        }
        
        let calendar = Calendar.current
        let today = Date()
        
        let startDate: Date
        let intervalText: String
        
        switch objective.interval {
        case 1:
            startDate = calendar.startOfDay(for: today)
            intervalText = "aujourd'hui"
        case 7:
            startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) ?? today
            intervalText = "cette semaine"
        case 30:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) ?? today
            intervalText = "ce mois-ci"
        default:
            startDate = today
            intervalText = ""
        }
        
        let relevantAPs = userAPVM.APs.filter { ap in
            ap.date >= startDate && ap.date <= today
        }
        
        var actualValue = 0
        var targetValue = 0
        var objectiveText = ""
        
        if objective.burnedCal != 0 {
            actualValue = relevantAPs.reduce(0) { $0 + $1.burnedCal }
            targetValue = objective.burnedCal!
            objectiveText = "Brûler \(targetValue) Cal \(intervalText)"
        } else if objective.APNumber != 0 {
            actualValue = relevantAPs.count
            targetValue = objective.APNumber!
            objectiveText = "\(targetValue) séances \(intervalText)"
        } else if objective.APTime != 0 {
            actualValue = relevantAPs.reduce(0) { $0 + $1.duration }
            targetValue = objective.APTime!
            objectiveText = "\(targetValue) min d'activité \(intervalText)"
        }
        
        return (actualValue, targetValue, objectiveText, true)
    }
    
    private var calProgress: (actual: Int, target: Int, text: String, show: Bool) {
        guard let calObj = calObjVM.dailyCalObj else {
            return (0, 2000, "Consommer 2000 Cal aujourd'hui", true)
        }
        
        // ⭐ Unwrap l'optionnel
        let targetCal = calObj.cal ?? 2000
        
        let calendar = Calendar.current
        let todayMeals = mealVM.mealList.filter { meal in
            calendar.isDate(meal.date, inSameDayAs: Date())
        }
        
        let actualCal = todayMeals.reduce(0) { $0 + $1.totalCal }
        
        return (actualCal, targetCal, "Consommer \(targetCal) Cal aujourd'hui", true)
    }

    // MARK: - Objectif Poids
    private var weightProgress: (actual: Double, target: Double, text: String, show: Bool) {
        guard let user = loginVM.currentUser,
              user.healthObjective?.lowercased() != "maintien",
              let weightObj = weightObjVM.WeightObj,
              let currentWeight = user.weight,
              let targetWeight = weightObj.targetWeight,
              let endDate = weightObj.endDate
        else {
            return (0, 0, "", false)
        }
        
        // Ou le premier poids chronologiquement
        let sortedWeights = weightVM.weightList.sorted { $0.date < $1.date }
        let startWeight = sortedWeights.first?.weight ?? currentWeight
        
        // Calcul de la progression
        let totalToLose = abs(startWeight - targetWeight)
        let alreadyLost = abs(startWeight - currentWeight)
        
        // Détermine si c'est perte ou prise
        let action = targetWeight < startWeight ? "Perdre" : "Prendre"
        
        // Calcul du temps restant
        let calendar = Calendar.current
        let daysRemaining = max(0, calendar.dateComponents([.day], from: Date(), to: endDate).day ?? 0)
        let timeText: String
        if daysRemaining == 0 {
            timeText = "terminé"
        } else if daysRemaining > 30 {
            timeText = "en \(daysRemaining / 30) mois"
        } else {
            timeText = "en \(daysRemaining) jours"
        }
        
        let text = "\(action) \(String(format: "%.1f", totalToLose))kg en \(timeText)"
        
        return (alreadyLost, totalToLose, text, true)
    }
    
    
    
    
    // MARK: - Message Zak
    private var messageZak: String {
        let apPercentage = apProgress.target > 0 ? Double(apProgress.actual) / Double(apProgress.target) * 100 : 0
        
        if apProgress.actual >= apProgress.target {
            return "🎉 Félicitations !"
        } else if apPercentage >= 75 {
            return "💪 Encore un petit effort !"
        } else if apPercentage >= 50 {
            return "⚡ Continue comme ça !"
        } else if apPercentage >= 25 {
            return "🔥 Tu y es presque !"
        } else {
            return "🚀 Allez, on y va !"
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(messageZak)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                
                Image(.zakSport)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 118)
            }
            .frame(width: 130)
            
            VStack(alignment: .leading, spacing: 12) {
                // 1. Objectif AP (en premier maintenant)
                if apProgress.show {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(apProgress.text)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16))
                            .lineLimit(1)
                        CustomProgressView(
                            color: .customLightPurple,
                            actual: apProgress.actual,
                            target: apProgress.target
                        )
                    }
                }
                
                // 2. Objectif Calories
                if calProgress.show {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(calProgress.text)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16))
                            .lineLimit(1)
                        CustomProgressView(
                            color: .customLightPink,
                            actual: calProgress.actual,
                            target: calProgress.target
                        )
                    }
                }
                
                // 3. Objectif Poids (seulement si pas "maintien")
                if weightProgress.show {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(weightProgress.text)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16))
                            .lineLimit(1)
                        CustomProgressView(
                            color: .customLightYellow,
                            actual: Int(weightProgress.actual * 100), // Convertit en Int pour la progress bar
                            target: Int(weightProgress.target * 100)
                        )
                    }
                }
            }
        }
        .frame(height: 150)
    }
}

#Preview {
    DailyTips()
        .environment(APObjectiveViewModel())
        .environment(UserAPViewModel())
        .environment(LoginViewModel())
        .environment(DailyCalObjectiveViewModel())
        .environment(WeightObjectiveViewModel())
        .environment(MealViewModel())
        .environment(UserWeightViewModel())
}
