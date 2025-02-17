//
//  ContentView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 31.12.24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userId") private var userId: Int?
    @Environment(\.dataService) var dataService: DataService
    
    var body: some View {
        if let userId = userId {
            TabView {
                NavigationStack {
                    HomeView(dataService: dataService, userId: userId)
                        .navigationTitle("Dashboard")
                }
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                
                NavigationStack {
                    EntriesView(dataService: dataService, userId: userId)
                        .navigationTitle("Entries")
                }
                .tabItem {
                    Label("Entries", systemImage: "book.fill")
                }
            }
            .onAppear() {
                Task {
                    try await dataService.fetchEntries(for: userId)
                    try await dataService.fetchGoals(for: userId)
                }
            }
        } else {
            LoginView(dataService: dataService)
        }
    }
}

#Preview {
    ContentView()
}
