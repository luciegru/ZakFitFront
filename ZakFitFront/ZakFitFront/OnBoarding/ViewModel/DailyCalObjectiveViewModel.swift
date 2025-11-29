//
//  CalObjectiveViewModel.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 29/11/2025.
//

import Foundation
import Observation

@Observable
class DailyCalObjectiveViewModel{
    
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
    
    var dailyCalObj: DailyCalObjective? = nil

    
    func getMyDailyCalObjective() async {
        
        
        guard let token = token
        else {
            print("mauvais token")
            
            return }
        
        guard let url = URL(string: "http://localhost:8080/dailyCalObjective/user")
        else {
            print("mauvais URL")
            
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                //            let jsonString = String(data: data, encoding: .utf8)
                //            print(jsonString ?? "No JSON")
                
                do{
                    let decodedDailyCalObj = try JSONDecoder.withDateFormatting.decode(DailyCalObjective.self, from: data)
                    DispatchQueue.main.async {
                        self.dailyCalObj = decodedDailyCalObj
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
    
    
    func createDailyCalObjective(with fields: [String: Any]) async {
        
        
        guard let token = token
        else {
            print("mauvais token")
            
            return }
        
        guard let url = URL(string: "http://localhost:8080/DailyCalObjective")
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
                
//                let jsonString = String(data: data, encoding: .utf8)
//                print(jsonString ?? "No JSON")

                do {
                    
                    let newDailyCalObj = try JSONDecoder.withDateFormatting.decode(DailyCalObjective.self, from: data)  // ✅
                    DispatchQueue.main.async {
                        self.dailyCalObj = newDailyCalObj
                        
                        print(newDailyCalObj)
                    }
                } catch {
                    print("Erreur décodage update:", error)
                }
            }
        }.resume()

        
        
        
    }
    
    func updateDailyCalObjective(with fields: [String: Any], DailyCalObjId: UUID) async {
        
        guard let token = token
        else {
            print("mauvais token")
            
            return }
        
        guard let url = URL(string: "http://localhost:8080/DailyCalObjective/\(DailyCalObjId)")
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
                    let updatedDailyCalObj = try JSONDecoder().decode(DailyCalObjective.self, from: data)
                    DispatchQueue.main.async {
                        self.dailyCalObj = updatedDailyCalObj
                    }
                } catch {
                    print("Erreur décodage update:", error)
                }
            }
        }.resume()

        
        
        
    }


   
}
