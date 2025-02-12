//
//  MockDataService.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 13.1.25.
//

import Foundation

class MockDataService: DataServiceProtocol {
    var entries: [Entry]
    var goals: Goals?
    
    init() {
        entries = mockEntires
        goals = Goals(
            caloriesGoal: K.defaultCalories,
            proteinGoal: K.defaultProtein,
            carbsGoal: K.defaultCarbs,
            fatsGoal: K.defaultFat
        )
    }
    
    func deleteEntry(_ entry: Entry) async throws {
        return 
    }
    
    func fetchEntries(for user: Int) async throws {
        return
    }
    
    func fetchGoals(for user: Int) async throws {
        return
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
    
    func saveEntry(_ entry: Entry) async throws {
        return
    }
}
