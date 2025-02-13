//
//  NewEntryViewModel.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 13.1.25.
//

import SwiftUI

@Observable
class NewEntryViewModel {
    let dataService: DataServiceProtocol
    let user: Int
    
    var name: String = ""
    var caloriesString: String = ""
    var proteinString: String = ""
    var carbsString: String = ""
    var fatString: String = ""
    var servingSizeString: String = ""
    var numberOfServingsString: String = ""
    var time: Date = Date()
    
    var namePlaceholder: String = "Name"
    var caloriesPlaceholder: String = "Calories"
    var proteinPlaceholder: String = "Protein"
    var carbsPlaceholder: String = "Carbs"
    var fatPlaceholder: String = "Fat"
    var servingSizePlaceholder: String = "Serving Size"
    var numberOfServingsPlaceholder: String = "Number of servings"
    
    var nameShakeTrigger: Bool = false
    var caloriesShakeTrigger: Bool = false
    var proteinShakeTrigger: Bool = false
    var carbsShakeTrigger: Bool = false
    var fatShakeTrigger: Bool = false
    var servingSizeShakeTrigger: Bool = false
    var numberOfServingsShakeTrigger: Bool = false
    
    init(dataService: DataServiceProtocol, user: Int) {
        self.dataService = dataService
        self.user = user
    }
    
    func addEntryButtonTapped() -> Bool {
        guard validateFields() else {
            return false
        }
        // TODO: Validate that numberOfServingsString conforms to NUMERIC(7,3)
        
        let entry = Entry(
            name: name,
            calories: Int(caloriesString)!,
            protein: Int(proteinString)!,
            carbs: Int(carbsString)!,
            fat: Int(fatString)!,
            servingSize: servingSizeString,
            numServings: Double(numberOfServingsString)!,
            time: time,
            userId: user
        )
        
        Task {
            do {
                try await dataService.saveEntry(entry)
            } catch {
                print(error)
            }
        }
        return true
    }
    
    func validateFields() -> Bool {
        guard name.count > 0 else {
            namePlaceholder = "Please enter a name"
            withAnimation {
                nameShakeTrigger.toggle()
            }
            return false
        }
        
        guard caloriesString.count > 0 else {
            caloriesPlaceholder = "Please enter calories"
            withAnimation {
                caloriesShakeTrigger.toggle()
            }
            return false
        }
        
        guard proteinString.count > 0 else {
            proteinPlaceholder = "Please enter protein"
            withAnimation {
                proteinShakeTrigger.toggle()
            }
            return false
        }
        
        guard carbsString.count > 0 else {
            carbsPlaceholder = "Please enter carbs"
            withAnimation {
                carbsShakeTrigger.toggle()
            }
            return false
        }
        
        guard fatString.count > 0 else {
            fatPlaceholder = "Please enter fats"
            withAnimation {
                fatShakeTrigger.toggle()
            }
            return false
        }
        
        guard servingSizeString.count > 0 else {
            servingSizePlaceholder = "Please enter serving size"
            withAnimation {
                servingSizeShakeTrigger.toggle()
            }
            return false
        }
        
        guard numberOfServingsString.count > 0 else {
            numberOfServingsPlaceholder = "Please enter number of servings"
            withAnimation {
                numberOfServingsShakeTrigger.toggle()
            }
            return false
        }
        return true
    }
}
