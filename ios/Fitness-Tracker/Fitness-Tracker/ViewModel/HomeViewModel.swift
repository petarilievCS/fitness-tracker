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
    
    private var entriesData: Entries?
    private var goals: Goals?
    
    var entries: [Entry] {
        return entriesData?.entries ?? []
    }

    var calories: Int {
        return entriesData?.todayCalories ?? 0
    }
    
    var protein: Int {
        return entriesData?.todayProtein ?? 0
    }
    
    var carbs: Int {
        return entriesData?.todayCarbs ?? 0
    }
    
    var fats: Int {
        return entriesData?.todayFat ?? 0
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
    
    var isShowingSheet: Bool = false
        
    init(user: Int, dataService: DataServiceProtocol) {
        self.user = user
        self.dataService = dataService
        loadData()
    }
    
    func loadData() {
        Task {
            do {
                self.entriesData = try await dataService.fetchEntries(for: user)
                self.goals = try await dataService.fetchGoals(for: user)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
