//
//  MealCard.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 01/12/2025.
//

import SwiftUI

struct MealCard: View {
    let meal: Meal
    @Environment(MealFoodViewModel.self) var foodVM
    @State private var foods: [Food] = []
    var selectedDay: Date
    
    private var mealTypeText: String {
        switch meal.type {
        case "breakfast": return "Petit \ndéjeuner"
        case "lunch": return "Déjeuner"
        case "snack": return "Goûter"
        case "diner": return "Dîner"
        default: return meal.type
        }
    }
    
    private var mealImage: ImageResource {
        switch meal.type {
        case "breakfast": return .breakfast
        case "lunch": return .lunch
        case "snack": return .snack
        case "diner": return .diner
        default: return .snack
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(mealImage)
                .resizable()
                .scaledToFit()
                .frame(height: 350)
            
            // Contenu
            VStack(alignment: .leading, spacing: 12) {
                // Titre du repas
                Text(mealTypeText)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.black)
                    .padding(.top, 20)
                    .padding(.leading, 10)
                
                // Liste des aliments
                VStack(alignment: .leading, spacing: 6) {
                    if !foods.isEmpty {
                        ForEach(foods) { food in
                            Text(food.name)
                                .font(.system(size: 12))
                                .foregroundStyle(Color.black)
                                .lineLimit(1)
                                .padding(.leading, 10)
                        }
                    } else {
                        EmptyView()
                    }
                }
                
                // Calories totales du repas
                VStack(alignment: .center){
                    Text("\(meal.totalCal)")
                        .font(.system(size: 30, weight: .bold))
                        .multilineTextAlignment(.center)
                    Text("Calories")
                }.frame(width: 140)

                Spacer()
                // Répartition par macroNutriments
                MacroGraph(meal: meal)
                    .frame(height: 100)
                    .padding(.bottom, 20)
                    
                
            }.frame(height: 350)
            
        }
        .cornerRadius(16)
        .shadow(radius: 5)
        .task(id: selectedDay) {
            if let loaded = try? await foodVM.fetchFoodsForMeal(mealId: meal.id) {
                foods = loaded
            } else {
            }
        }
    }
}
#Preview {
    MealCard(meal: Meal(id: UUID(), user: UUID(), type: "lunch", date: Date(), totalCal: 200, totalProt: 32, totalCarb: 64, totalLip: 35), selectedDay: Date()).environment(MealFoodViewModel())
}
