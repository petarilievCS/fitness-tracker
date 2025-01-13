//
//  UserInfo.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 8.1.25.
//

import Foundation

struct Goals: Codable {
    let caloriesGoal: Int
    let proteinGoal: Int
    let carbsGoal: Int
    let fatsGoal: Int
    
    enum CodingKeys: String, CodingKey {
        case caloriesGoal = "calories_goal"
        case proteinGoal = "protein_goal"
        case carbsGoal = "carbs_goal"
        case fatsGoal = "fats_goal"
    }
}
