//
//  Entry.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 7.1.25.
//

import Foundation

struct Entry: Codable, Identifiable {
    let id: Int
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
}
