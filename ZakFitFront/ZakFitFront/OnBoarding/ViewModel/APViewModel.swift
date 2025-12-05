//
//  APViewModel.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 03/12/2025.
//

import Foundation
import Observation

@Observable
class APViewModel{
    
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
    
    var APhysic: AP? = nil
    var APList: [AP] = []

    
    func getAPById(APId: UUID) async {
        
        
        guard let token = token
        else {
            print("mauvais token")
            
            return }
        
        guard let url = URL(string: "http://localhost:8080/AP/\(APId)")
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
                    let decodedAP = try JSONDecoder.withDateFormatting.decode(AP.self, from: data)
                    DispatchQueue.main.async {
                        self.APhysic = decodedAP
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
    
    func getAPByIdWithReturn(APId: UUID) async throws -> AP {
        guard let token = token else { throw URLError(.userAuthenticationRequired) }
        guard let url = URL(string: "http://localhost:8080/AP/\(APId)") else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedAP = try JSONDecoder.withDateFormatting.decode(AP.self, from: data)
        return decodedAP
    }

    func createAP(with fields: [String: Any]) async {
        
//        print("je rentre dans la fonction")
        
        guard let token = token
        else {
            print("mauvais token")
            
            return }
        
        guard let url = URL(string: "http://localhost:8080/AP")
        else {
            print("mauvais URL")
            
            return }
        
//        print("bon token bon url")

        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: fields)
        

//        print("decode")
        
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
                    
                    let newAP = try JSONDecoder.withDateFormatting.decode(AP.self, from: data)
                    DispatchQueue.main.async {
                        self.APhysic = newAP
                        
                        print(newAP)
                    }
                } catch {
                    print("Erreur décodage update:", error)
                }
            }
        }.resume()

        
        
        
    }
    


   
}
