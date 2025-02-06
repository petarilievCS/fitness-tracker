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
    
    private var intake: Intake?
    private var goals: Goals?
    
    var calories: Int {
        return intake?.calories ?? 0
    }
    
    var protein: Int {
        return intake?.protein ?? 0
    }
    
    var carbs: Int {
        return intake?.carbs ?? 0
    }
    
    var fat: Int {
        return intake?.fat ?? 0
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
        return min(Double(fat) / Double(fatsGoal), 1)
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
                self.intake = try await dataService.fetchIntake(for: user)
                self.goals = try await dataService.fetchGoals(for: user)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
