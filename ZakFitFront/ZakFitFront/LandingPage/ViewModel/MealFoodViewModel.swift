//
//  MealFoodViewModel.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 01/12/2025.
//

import Foundation
import Observation

@Observable
class MealFoodViewModel{
    
    var token: String? {
        didSet {
            if let token {
                saveToken(token)
            } else {
                clearToken()
            }
        }
    }
    
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin), name: .didLogin, object: nil)
        self.token = loadToken()
    }

    @objc private func onLogin() {
        
        self.token = loadToken()
    }
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    private func loadToken() -> String? {
        
        UserDefaults.standard.string(forKey: "authToken")
    }
    
    private func clearToken() {
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
    
    var foods: [Food] = []
    var mealFood: [MealFood] = []

    
    func getFoodByMeal(mealId: UUID) async {
        
        
        guard let token = token
        else {
            print("mauvais token")
            
            return }
        
        guard let url = URL(string: "http://localhost:8080/mealFood/mealId/\(mealId)")
        else {
            print("mauvais URL")
            
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
//                            let jsonString = String(data: data, encoding: .utf8)
//                            print(jsonString ?? "No JSON")
                
                do{
                    let decodedFoods = try JSONDecoder.withDateFormatting.decode([Food].self, from: data)
                    DispatchQueue.main.async {
                        self.foods = decodedFoods
                        
//                        print("decoded AP = \(decodedAP)")
                    }
                }
                catch {
                    print("Error decoding: \(error)")
                }
            }
            else if let error {
                print("Error: \(error)")
            }
        }.resume()
        
    }
    
    func fetchFoodsForMeal(mealId: UUID) async throws -> [Food] {
        guard let token = token else { return [] }
        guard let url = URL(string: "http://localhost:8080/mealFood/mealId/\(mealId)") else { return [] }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder.withDateFormatting.decode([Food].self, from: data)
        return decoded
    }

    
    func createMealFood(with fields: [String: Any]) async {
        
        
        guard let token = token
        else {
            print("mauvais token")
            
            return }
        
        guard let url = URL(string: "http://localhost:8080/mealFood/")
        else {
            print("mauvais URL")
            
            return }
        

        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: fields)
        

        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("Erreur update:", error)
                return
            }
            if let data = data {
                
//                            let jsonString = String(data: data, encoding: .utf8)
//                            print(jsonString ?? "No JSON")

                do {
                    
                    let newMealFood = try JSONDecoder.withDateFormatting.decode(MealFood.self, from: data)
                    DispatchQueue.main.async {
                        self.mealFood.append(newMealFood)
                    }
                } catch {
                    print("Erreur décodage update:", error)
                }
            }
        }.resume()

        
        
        
    }
   
}
