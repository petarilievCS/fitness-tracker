//
//  Intake.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 6.2.25.
//

import Foundation

struct Intake: Codable {
    var calories: Int
    var protein: Int
    var carbs: Int
    var fat: Int
    
    static func mock() -> Intake {
        return Intake(calories: 1500, protein: 90, carbs: 120, fat: 10)
    }
}
