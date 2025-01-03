//
//  User.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 3.1.25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let gender: String
    let birthDate: Date
    let weight: Double
    let height: Double
    let activityLevel: String
    let goal: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case gender
        case birthDate = "birth_date"
        case weight
        case height
        case activityLevel = "activity_level"
        case goal
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)
        gender = try container.decode(String.self, forKey: .gender)
        activityLevel = try container.decode(String.self, forKey: .activityLevel)
        goal = try container.decode(String.self, forKey: .goal)
        
        // Decode birthday from string to date
        let dateFormatter = APIDateFormatter()
        let birthDateString = try container.decode(String.self, forKey: .birthDate)
        if let date = dateFormatter.date(from: birthDateString) {
            birthDate = date
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .birthDate,
                in: container,
                debugDescription: "Invalid date format for birth_date"
            )
        }
        
        // Decode weight from string to Double
        let weightString = try container.decode(String.self, forKey: .weight)
        if let weight = Double(weightString) {
            self.weight = weight
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .weight,
                in: container,
                debugDescription: "Invalid weight"
            )
        }
        
        // Decode height from string to Double
        let heightString = try container.decode(String.self, forKey: .height)
        if let height = Double(heightString) {
            self.height = height
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .height,
                in: container,
                debugDescription: "Invalid height"
            )
        }
    }
}

