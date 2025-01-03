//
//  User.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 3.1.25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let first_name: String
    let last_name: String
    let email: String
    let password: String
    let gender: String
    let age: Int
    let weight: Double
    let height: Double
    let activity_level: String
    let goal: String
}
