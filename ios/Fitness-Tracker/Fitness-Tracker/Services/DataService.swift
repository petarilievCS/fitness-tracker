//
//  DataService.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 3.1.25.
//

import Foundation

enum LoginError: Error {
    case serverError(String)
    case decodingError(String)
    case unknownError
}

struct DataService {
    private let decoder: JSONDecoder = JSONDecoder()
    private let baseUrlString: String = "https://flask-api-122291004318.us-central1.run.app"
    
    func loginUser(email: String, password: String) async throws -> User {
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
        guard let httpResonse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        
        // 6: Handle response
        switch httpResonse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: data)
            return user
        case 400..<500:
            print("Client Side Error")
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw LoginError.serverError(errorResponse.error)
            } else {
                throw LoginError.decodingError("Error: Unable to decode server error.")
            }
        default:
            throw LoginError.unknownError
        }
    }
    
    func fetchEntries(for user: Int) async throws -> [Entry] {
        // 1: Define URL
        guard let url = URL(string: "\(baseUrlString)/entries?user_id=\(user)") else {
            throw URLError(.badURL)
        }

        // 2: Send request via URLSession
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 3: Handle response
        guard let httpResonse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        
        switch httpResonse.statusCode {
        case 200:
            let user = try decoder.decode([Entry].self, from: data)
            return user
        case 400..<500:
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw LoginError.serverError(errorResponse.error)
            } else {
                throw LoginError.decodingError("Error: Unable to decode server error.")
            }
        default:
            throw LoginError.unknownError
        }
    }
    
    func fetchGoals(for user: Int) async throws -> [Goals] {
        guard let url = URL(string: "\(baseUrlString)/goals?user_id=\(user)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpResponse.statusCode {
        case 200:
            let goals = try decoder.decode([Goals].self, from: data)
            return goals
        case 400..<500:
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw LoginError.serverError(errorResponse.error)
            } else {
                throw LoginError.decodingError("Error: Unable to decode server error.")
            }
        default:
            throw LoginError.unknownError
        }
    }
}
