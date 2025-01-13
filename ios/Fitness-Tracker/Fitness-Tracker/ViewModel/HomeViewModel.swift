//
//  Untitled.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 4.1.25.
//

import SwiftUI

@Observable
class HomeViewModel {
    private let dataService: DataServiceProtocol
    private let user: Int
    
    private var entries: Entries?
    private var goals: Goals?

    var calories: Int {
        return entries?.todayCalories ?? 0
    }
    
    var protein: Int {
        return entries?.todayProtein ?? 0
    }
    
    var carbs: Int {
        return entries?.todayCarbs ?? 0
    }
    
    var fats: Int {
        return entries?.todayFat ?? 0
    }
    
    var calorieGoal: Int {
        return goals?.caloriesGoal ?? K.defaultCalories
    }
    
    var proteinGoal: Int {
        return goals?.proteinGoal ?? K.defaultProtein
    }
    
    var carbsGoal: Int {
        return goals?.carbsGoal ?? K.defaultCarbs
    }
    
    var fatsGoal: Int {
        return goals?.fatsGoal ?? K.defaultFat
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
        return min(Double(fats) / Double(fatsGoal), 1)
    }
        
    init(user: Int, dataService: DataServiceProtocol) {
        self.user = user
        self.dataService = dataService
        loadData()
    }
    
    func loadData() {
        Task {
            do {
                self.entries = try await dataService.fetchEntries(for: user)
                self.goals = try await dataService.fetchGoals(for: user)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
