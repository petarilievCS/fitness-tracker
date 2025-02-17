//
//  MealDescription.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 17.2.25.
//

import Foundation

struct MealDescription: Encodable {
    let mealDescription: String
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case mealDescription = "meal_description"
        case userId = "user_id"
    }
}
