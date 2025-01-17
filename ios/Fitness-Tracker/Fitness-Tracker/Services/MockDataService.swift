//
//  MockDataService.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 13.1.25.
//

import Foundation

class MockDataService: DataServiceProtocol {
    func fetchEntries(for user: Int) async throws -> Entries {
        let todayCalories = mockEntires.reduce(0) { $0 + $1.calories }
        let todayProtein = mockEntires.reduce(0) { $0 + $1.protein }
        let todayCarbs = mockEntires.reduce(0) { $0 + $1.carbs }
        let todayFat = mockEntires.reduce(0) { $0 + $1.fat }
        return .init(
            entries: mockEntires,
            todayCalories: todayCalories,
            todayProtein: todayProtein,
            todayCarbs: todayCarbs,
            todayFat: todayFat
        )
    }
    
    func fetchGoals(for user: Int) async throws -> Goals {
        return Goals(
            caloriesGoal: K.defaultCalories,
            proteinGoal: K.defaultProtein,
            carbsGoal: K.defaultCarbs,
            fatsGoal: K.defaultFat
        )
    }
    
    func loginUser(email: String, password: String) async throws -> User {
        var components = DateComponents()
        components.year = 2002
        components.month = 4
        components.day = 2
        let birthDate = Calendar.current.date(from: components)!
        
        return User(
            id: 1,
            firstName: "Petar",
            lastName: "Iliev",
            email: "petariliev2002@gmail.com",
            gender: "Male",
            birthDate: birthDate,
            weight: 65.0,
            height: 170.0,
            activityLevel: "Moderately Active",
            goal: "Maintain")
    }
}
