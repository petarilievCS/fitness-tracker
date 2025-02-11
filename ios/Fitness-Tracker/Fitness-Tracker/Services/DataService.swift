//
//  DataService.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 3.1.25.
//

import Foundation
import SwiftUI

enum DataServiceError: Error {
    case serverError(String)
    case decodingError(String)
    case unknownError
}

protocol DataServiceProtocol {
    // Variables
    var entries: [Entry] { get }
    var goals: Goals { get }
    
    // Methods
    func fetchEntries(for user: Int) async throws
    func fetchGoals(for user: Int) async throws -> Goals
    func fetchIntake(for user: Int) async throws -> Intake
    func loginUser(email: String, password: String) async throws -> User
    func saveEntry(_ entry: Entry) async throws
    func deleteEntry(_ entry: Entry) async throws
}

@Observable
class DataService: DataServiceProtocol {
    // State
    var entries: [Entry] = []
    var goals: Goals?
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let baseUrlString: String = "https://flask-api-122291004318.us-central1.run.app"
    
    init() {
        encoder.dateEncodingStrategy = .iso8601
    }
    
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
                throw DataServiceError.serverError(errorResponse.error)
            } else {
                throw DataServiceError.decodingError("Error: Unable to decode server error.")
            }
        default:
            throw DataServiceError.unknownError
        }
    }
    
    func fetchEntries(for user: Int) async throws {
        // 1: Define URL
        guard let url = URL(string: "\(baseUrlString)/entries/\(user)") else {
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
            entries = try decoder.decode([Entry].self, from: data)
        case 400..<500:
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw DataServiceError.serverError(errorResponse.error)
            } else {
                throw DataServiceError.decodingError("Error: Unable to decode server error.")
            }
        default:
            throw DataServiceError.unknownError
        }
    }
    
    func fetchIntake(for user: Int) async throws -> Intake {
        // 1: Define URL
        guard let url = URL(string: "\(baseUrlString)/intake/\(user)") else {
            throw URLError(.badURL)
        }
        
        // 2: Send request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 3: Handle response
        guard let httpResonse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpResonse.statusCode {
        case 200:
            let intake = try decoder.decode(Intake.self, from: data)
            return intake
        case 400..<500:
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw DataServiceError.serverError(errorResponse.error)
            } else {
                throw DataServiceError.decodingError("Error: Unable to decode server error")
            }
        default:
            throw DataServiceError.unknownError
        }
    }
    
    func fetchGoals(for user: Int) async throws -> Goals {
        guard let url = URL(string: "\(baseUrlString)/goals/\(user)") else {
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
            let goals = try decoder.decode(Goals.self, from: data)
            return goals
        case 400..<500:
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw DataServiceError.serverError(errorResponse.error)
            } else {
                throw DataServiceError.decodingError("Error: Unable to decode server error.")
            }
        default:
            throw DataServiceError.unknownError
        }
    }
    
    func saveEntry(_ entry: Entry) async throws {
        // Local update
        entries.append(entry)
        
        // Data
        var newEntry = entry
        newEntry.id = "" // Remove temp ID
        let encodedData = try encoder.encode(newEntry)
        
        // Set-up request
        let url = URL(string: "\(baseUrlString)/entry")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedData
        
        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Handle response
        let httpResponse = response as! HTTPURLResponse
        switch httpResponse.statusCode {
        case 201:
            print("Successfully saved entry")
            let serverEntry = try! decoder.decode(Entry.self, from: data)
            if let index = self.entries.firstIndex(where: { $0.id == entry.id }) {
                self.entries[index].id = serverEntry.id // Sync ID with server
            }
            break
        default:
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw DataServiceError.serverError(errorResponse.error)
            } else {
                throw DataServiceError.decodingError("Error: Unable to decode server error.")
            }
        }
    }
    
    func deleteEntry(_ entry: Entry) async throws {
        // Update locally
        entries.removeAll { otherEntry in
            entry.id == otherEntry.id
        }
        
        // Set-up request
        let url = URL(string: "\(baseUrlString)/entry/\(entry.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Handle response
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResonse = response as! HTTPURLResponse
        switch httpResonse.statusCode {
        case 201:
            print("Successfully deleted entry")
            break
        default:
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw DataServiceError.serverError(errorResponse.error)
            } else {
                throw DataServiceError.decodingError("Error: Unable to decode server error.")
            }

        }
    }
}
