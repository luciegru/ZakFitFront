//
//  MealSheet.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 02/12/2025.
//

import SwiftUI

struct MealSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @State var selectedType: String = "petit déjeûner"
    @State private var foodItems: [FoodItem] = [
        FoodItem(selectedFood: nil, quantity: 1)
    ]
    @Environment(FoodViewModel.self) var foodVM
    @Environment(MealViewModel.self) var mealVM
    @Environment(MealFoodViewModel.self) var mealFoodVM
    
    let mealTypeMapping: [String: String] = [
        "petit déjeûner": "breakfast",
        "déjeûner": "lunch",
        "dîner": "dinner",
        "snack": "snack"
    ]


    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            VStack {
                Text("Type de repas")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.white)
                    .padding(.vertical,20)
                
                CustomDropdownMenu(
                    selectedOption: $selectedType,
                    options: ["petit déjeûner", "dîner", "snack", "déjeûner"]
                )
                .frame(width: 200)
                
                
                Spacer()
                
                VStack(spacing: 20) {
                    // En-têtes
                    HStack {
                        Text("Aliment")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Quantité")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 150)
                        
                        Text("Unité")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 80)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    
                    // Liste des lignes
                    ForEach($foodItems) { $item in
                        HStack {
                            // Dropdown aliment
                            CustomDropdownMenu(
                                selectedOption: Binding(
                                    get: { item.selectedFood?.name ?? "Choisir" },
                                    set: { newName in
                                        item.selectedFood = foodVM.foodList.first { $0.name == newName }
                                    }
                                ),
                                options: foodVM.foodList.map { $0.name }
                            )
                            
                            // Stepper quantité
                            CustomStepper(selectedOption: Binding(
                                get: { Double(item.quantity) },
                                set: { item.quantity = Int($0) }
                            ))
                            
                            // Unité (juste texte)
                            Text(item.selectedFood?.unit ?? "")
                                .foregroundColor(.white)
                                .frame(width: 80, alignment: .leading)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Bouton ajouter ligne
                    Button(action: {
                        foodItems.append(FoodItem(selectedFood: nil, quantity: 1))
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.customPurple)
                            .cornerRadius(20)
                    }
                    Spacer()
                    
                    Button(action: {
                        Task {
                            // Vérifier que tous les aliments sont sélectionnés
                            guard foodItems.allSatisfy({ $0.selectedFood != nil }) else {
                                return
                            }
                            
                            // Calculer les totaux du repas entier
                            var totalCal = 0
                            var totalProt = 0
                            var totalGluc = 0
                            var totalLip = 0

                            for item in foodItems {
                                guard let food = item.selectedFood else { continue }
                                
                                // Déterminer le poids réel en grammes selon l'unité
                                let actualWeight: Double
                                switch food.unit {
                                case "g":
                                    actualWeight = Double(item.quantity) // l'utilisateur a déjà saisi le poids en g
                                default:
                                    // pièce, tranche, portion, etc. → on utilise unitWeightG pour convertir en g
                                    actualWeight = (food.unitWeightG ?? 100) * Double(item.quantity)
                                }

                                // Ajouter les macros proportionnellement au poids
                                totalCal  += Int(Double(food.cal) * actualWeight / 100)
                                totalProt += Int(Double(food.prot) * actualWeight / 100)
                                totalGluc += Int(Double(food.carb) * actualWeight / 100)
                                totalLip  += Int(Double(food.lip) * actualWeight / 100)
                            }


                            // Formatter la date pour le backend
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let dateString = dateFormatter.string(from: Date())

                            
                            // 1. Créer le repas
                            await mealVM.createMeal(with: [
                                "type": mealTypeMapping[selectedType] ?? "snack",
                                "date": dateString,
                                "totalCal": totalCal,
                                "totalCarb": totalGluc,
                                "totalProt": totalProt,
                                "totalLip": totalLip
                            ])
                            
                            // 2. Attendre un peu que le meal soit créé (car dataTask est async)
                            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconde
                            
                            // 3. Vérifier que le meal a bien été créé
                            guard let mealId = mealVM.meal?.id else {
                                return
                            }
                            
                            
                            // 4. Créer les liens meal-food pour chaque aliment
                            for foodItem in foodItems {
                                guard let foodId = foodItem.selectedFood?.id else {
                                    continue
                                }
                                
                                
                                await mealFoodVM.createMealFood(with: [
                                    "meal": mealId.uuidString, // ✅ Convertir UUID en string
                                    "food": foodId.uuidString,  // ✅ Convertir UUID en string
                                    "quantityFood": foodItem.quantity
                                ])
                                
                                // Petit délai entre chaque création
                                try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconde
                            }
                            
                            
                            // 5. Recharger la liste des repas
                            await mealVM.getMyMeal()
                            
                            try? await Task.sleep(nanoseconds: 500_000_000)

                            
                            // 6. Fermer la sheet
                            dismiss()
                        }
                    }, label: {
                        Text("ENREGISTRER")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 30, weight: .bold))
                            .padding(10)
                            .background(Color.customBlue)
                            .cornerRadius(10)
                            
                    })
                }
            }
            .background(Color.black)
        }
        .task {
            try? await foodVM.getAllFood()
        }
    }
}

// Structure simple pour chaque ligne
struct FoodItem: Identifiable {
    let id = UUID()
    var selectedFood: Food?
    var quantity: Int
}


#Preview {
    MealSheet().environment(FoodViewModel()).environment(MealViewModel()).environment(MealFoodViewModel())
}
