//
//  Untitled.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 4.1.25.
//

import SwiftUI

@Observable
class HomeViewModel {
    private let dataService = DataService()
    
    let user: Int
    
    // Macro variables
    var calories: Double = 0.0
    var calorieGoal: Double = 0.0
    var protein: Double = 0.0
    var proteinGoal: Double = 0.0
    var carbs: Double = 0.0
    var carbsGoal: Double = 0.0
    var fats: Double = 0.0
    var fatsGoal: Double = 0.0
    
    // Comptued variables
    var caloriesProgress: Double {
        return min(calories / calorieGoal, 1)
    }
    
    var proteinProgress: Double {
        return min(protein / proteinGoal, 1)
    }
    
    var carbsProgress: Double {
        return min(carbs / carbsGoal, 1)
    }
    
    var fatsProgress: Double {
        return min(fats / fatsGoal, 1)
    }
    
    var entries: [Entry] = []
    
    // Initializers
    init(user: Int, calories: Double, calorieGoal: Double, protein: Double, proteinGoal: Double, carbs: Double, carbsGoal: Double, fats: Double, fatsGoal: Double, entries: [Entry]) {
        self.user = user
        self.calories = calories
        self.calorieGoal = calorieGoal
        self.protein = protein
        self.proteinGoal = proteinGoal
        self.carbs = carbs
        self.carbsGoal = carbsGoal
        self.fats = fats
        self.fatsGoal = fatsGoal
        self.entries = entries
    }
    
    init(user: Int) {
        self.user = user
        
        Task {
            self.entries = try await dataService.fetchEntries(for: user)
        }
    }
    
    // Mock view model
    static func mock() -> HomeViewModel {
        .init(user:1, calories: 1000, calorieGoal: 1500, protein: 100, proteinGoal: 200, carbs: 100, carbsGoal: 200, fats: 100, fatsGoal: 200, entries: [])
    }
}
