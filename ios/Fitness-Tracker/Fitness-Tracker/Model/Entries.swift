//
//  Entries.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 12.1.25.
//

import Foundation

struct Entries: Decodable {
    let entries: [Entry]
    let todayCalories: Int
    let todayProtein: Int
    let todayCarbs: Int
    let todayFat: Int
    
    enum CodingKeys: String, CodingKey {
        case entries
        case todayCalories = "today_calories"
        case todayProtein = "today_protein"
        case todayCarbs = "today_carbs"
        case todayFat = "today_fat"
    }
}
