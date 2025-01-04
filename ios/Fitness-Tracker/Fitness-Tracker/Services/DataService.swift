//
//  DataService.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 3.1.25.
//

import Foundation

struct DataService {
    
    private let baseUrlString: String = "https://flask-api-122291004318.us-central1.run.app"
    
    func loginUser(email: String, password: String) async throws {
        // 1: Define URL
        guard let url = URL(string: "\(baseUrlString)/login") else {
            throw URLError(.badURL)
        }
        
        // 2: Create request (POST, headers, content)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 3: Encode data using JSONEncoder
        let encoder = JSONEncoder()
        let loginData = try encoder.encode(LoginRequest(email: email, password_hash: password))
        request.httpBody = loginData
         
        // 4: Send request via URLSession
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 5: Handle response
        guard let httpResonse = response as? HTTPURLResponse, httpResonse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // 6: Decode response
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: data)
        print(user)
    }
}
