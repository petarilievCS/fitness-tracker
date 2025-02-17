//
//  Fitness_TrackerApp.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 31.12.24.
//

import SwiftUI
import SwiftData

@main
struct Fitness_TrackerApp: App {
    @State private var dataService = DataService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.dataService, dataService)
        }
    }
}
