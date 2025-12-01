//
//  WeightObjectiveViewModel.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import Foundation
import Observation

@Observable
class WeightObjectiveViewModel{
    
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
    
    var WeightObj: WeightObjective? = nil

    
    func getMyWeightObjective() async {
        
        
        guard let token = token
        else {
            print("mauvais token")
            
            return }
        
        guard let url = URL(string: "http://localhost:8080/weightObjective/user")
        else {
            print("mauvais URL")
            
            return }
//        print("bon token bon url")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
//                            let jsonString = String(data: data, encoding: .utf8)
//                            print(jsonString ?? "No JSON")
                
                do{
                    let decodedWeightObj = try JSONDecoder.withDateFormatting.decode(WeightObjective.self, from: data)
                    
//                    print(decodedWeightObj)
                    
                    DispatchQueue.main.async {
                        self.WeightObj = decodedWeightObj
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
    
    
    func createWeightObjective(with fields: [String: Any]) async {
        
        
        guard let token = token
        else {
            print("mauvais token")
            
            return }
        
        guard let url = URL(string: "http://localhost:8080/weightObjective")
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
//                
//                            let jsonString = String(data: data, encoding: .utf8)
//                            print(jsonString ?? "No JSON")

                do {
                    let decodedWeightObj = try JSONDecoder.withDateFormatting.decode(WeightObjective.self, from: data)  // ✅
                    DispatchQueue.main.async {
                        self.WeightObj = decodedWeightObj
                    }
                
                } catch {
                    print("Erreur décodage update:", error)
                }
            }
        }.resume()

        
        
        
    }
    
    func updateWeightObjectif(with fields: [String: Any], WeightId: UUID) async {
        
        guard let token = token
        else {
            print("mauvais token")
            
            return }
        
        guard let url = URL(string: "http://localhost:8080/WeightObjective/\(WeightId)")
        else {
            print("mauvais URL")
            
            return }

        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("Erreur update:", error)
                return
            }
            if let data = data {
                do {
                    let decodedWeightObj = try JSONDecoder.withDateFormatting.decode(WeightObjective.self, from: data)  // ✅
                    DispatchQueue.main.async {
                        self.WeightObj = decodedWeightObj
                    }
                
                } catch {
                    print("Erreur décodage update:", error)
                }
            }
        }.resume()

        
        
        
    }


   
}
