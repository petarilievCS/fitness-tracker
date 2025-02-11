//
//  Entry.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 7.1.25.
//

import Foundation

struct Entry: Codable {
    var id: String
    let name: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
    let servingSize: String
    let numServings: Double
    let time: Date
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case calories
        case protein
        case carbs
        case fat
        case servingSize = "serving_size"
        case numServings = "num_servings"
        case time
        case userId = "user_id"
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        calories = try container.decode(Int.self, forKey: .calories)
        protein = try container.decode(Int.self, forKey: .protein)
        carbs = try container.decode(Int.self, forKey: .carbs)
        fat = try container.decode(Int.self, forKey: .fat)
        servingSize = try container.decode(String.self, forKey: .servingSize)
        userId = try container.decode(Int.self, forKey: .userId)
        
        let idInt = try container.decode(Int.self, forKey: .id)
        id = String(idInt)
        
        let numServingsString = try container.decode(String.self, forKey: .numServings)
        if let numServingsDouble = Double(numServingsString) {
            numServings = numServingsDouble
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .numServings,
                in: container,
                debugDescription: "Invalid num_servings"
            )
        }
        
        let timeString = try container.decode(String.self, forKey: .time)
        print(timeString)
        if let formattedTime = APITimeFormatter.shared.date(from: timeString) {
            time = formattedTime
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .time,
                in: container,
                debugDescription: "Invalid date format for time"
            )
        }
    }
    
    init(name: String, calories: Int, protein: Int, carbs: Int, fat: Int, servingSize: String, numServings: Double, time: Date, userId: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.servingSize = servingSize
        self.numServings = numServings
        self.time = time
        self.userId = userId
    }
    
    static func mock() -> Entry {
        return Entry(
            name: "Banana",
            calories: 100,
            protein: 10,
            carbs: 10,
            fat: 10,
            servingSize: "1 oz",
            numServings: 1.0,
            time: Date(),
            userId: 1
        )
    }
}
