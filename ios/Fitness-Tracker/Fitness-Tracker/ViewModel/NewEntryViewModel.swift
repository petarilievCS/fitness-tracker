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
    
    func addEntry() {
        guard name.count > 0 else {
            name = ""
            namePlaceholder = "Please enter a name"
            withAnimation {
                nameShakeTrigger.toggle()
            }
            return
        }
        
        guard let calories = Int(caloriesString) else {
            caloriesString = ""
            caloriesPlaceholder = "Invalid calories"
            withAnimation {
                caloriesShakeTrigger.toggle()
            }
            return
        }
        
        guard let protein = Int(proteinString), protein > 0 else {
            proteinString = ""
            proteinPlaceholder = "Invalid protein"
            withAnimation {
                proteinShakeTrigger.toggle()
            }
            return
        }
        
        guard let carbs = Int(carbsString), carbs > 0 else {
            carbsString = ""
            carbsPlaceholder = "Invalid carbs"
            withAnimation {
                carbsShakeTrigger.toggle()
            }
            return
        }
        
        guard let fat = Int(fatString), fat > 0 else {
            fatString = ""
            fatPlaceholder = "Invalid fat"
            withAnimation {
                fatShakeTrigger.toggle()
            }
            return
        }
        
        // TODO: Validate serving size
        // TODO: Validate number of servings
        // TODO: Validate time
    }
}
