//
//  UserViewModel.swift
//  ZakFitFront
//
//  Created by Lucie Grunenberger  on 28/11/2025.
//

import Foundation
import Observation

@Observable
class UserViewModel{
    var users: [User] = []
    var user: User? = nil

    var token: String? {
        didSet {
            if let token {
                saveToken(token)
            } else {
                clearToken()
            }
        }
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


    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin), name: .didLogin, object: nil)
        self.token = loadToken()
    }

    @objc private func onLogin() {
        
        self.token = loadToken()
    }

    
    func fetchUsers(token: String){
        guard let url = URL(string: "http://localhost:8080/user/All") else {
            print("mauvais url")
            return }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                print("Raw JSON:", String(data: data, encoding: .utf8) ?? "nil")
                do{
                    let decoder = JSONDecoder()
                    let decodedUsers = try decoder.decode([User].self, from: data)
                    DispatchQueue.main.async {
                        self.users = decodedUsers
                    }
                }
                catch {
                    print("Error decoding: \(error)")
                }
            }
            else if let error {
                print("Error: \(error)")
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
            }
        }
        .resume()
    }
    
    func updateUser(with fields: [String: Any]) {
        
        
        guard let token = token else {
            print("mauvais token")
            return
        }
        guard let url = URL(string: "http://localhost:8080/user/") else {
            print("mauvais url")
            return }
        

        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: fields)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("Erreur update:", error)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
            }
        }.resume()
           
    }

    
}

