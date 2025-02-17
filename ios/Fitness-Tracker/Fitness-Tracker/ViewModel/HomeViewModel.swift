//
//  Untitled.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 4.1.25.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case addEntry
    case chat
    
    var id: String {
        switch self {
        case .addEntry: return "addEntry"
        case .chat: return "chat"
        }
    }
}

@Observable
class HomeViewModel {
    private var dataService: DataServiceProtocol
    private let user: Int
    
    var calories: Int {
        return dataService.entries.reduce(0) { $0 + $1.calories }
    }
    
    var protein: Int {
        return dataService.entries.reduce(0) { $0 + $1.protein }
    }
    
    var carbs: Int {
        return dataService.entries.reduce(0) { $0 + $1.carbs }
    }
    
    var fat: Int {
        return dataService.entries.reduce(0) { $0 + $1.fat }
    }
    
    var calorieGoal: Int {
        return dataService.goals?.caloriesGoal ?? K.defaultCalories
    }
    
    var proteinGoal: Int {
        return dataService.goals?.proteinGoal ?? K.defaultProtein
    }
    
    var carbsGoal: Int {
        return dataService.goals?.carbsGoal ?? K.defaultCarbs
    }
    
    var fatsGoal: Int {
        return dataService.goals?.fatsGoal ?? K.defaultFat
    }
    
    var calorieProgress: Double {
        return min(Double(calories) / Double(calorieGoal), 1)
    }
    
    var proteinProgress: Double {
        return min(Double(protein) / Double(proteinGoal), 1)
    }
    
    var carbsProgress: Double {
        return min(Double(carbs) / Double(carbsGoal), 1)
    }
    
    var fatsProgress: Double {
        return min(Double(fat) / Double(fatsGoal), 1)
    }
    
    var activeSheet: ActiveSheet? = nil
        
    init(user: Int, dataService: DataServiceProtocol) {
        self.user = user
        self.dataService = dataService
    }
    
    func loadData() {
        Task {
            do {
                try await dataService.fetchGoals(for: user)
                try await dataService.fetchEntries(for: user)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
