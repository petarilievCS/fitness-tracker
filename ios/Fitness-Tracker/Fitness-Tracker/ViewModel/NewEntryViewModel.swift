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
    
    let title: String = "Add New Entry"
    var name: String = ""
    var calories: String = ""
    var protein: String = ""
    var carbs: String = ""
    var fat: String = ""
    var servingSize: String = ""
    var numberOfServings: String = ""
    var time: Date = Date()
    
    init(dataService: DataServiceProtocol, user: Int) {
        self.dataService = dataService
        self.user = user
    }
    
    func addEntry() {
        print("Add Entry Tapped")
    }
}
