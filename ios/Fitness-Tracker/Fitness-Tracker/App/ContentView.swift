//
//  ContentView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 31.12.24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userId") private var userId: Int?
    
    private let dataService = DataService()
    
    var body: some View {
        if let userId = userId {
            TabView {
                NavigationStack {
                    HomeView(viewModel: HomeViewModel(user: userId, dataService: dataService))
                        .navigationTitle("Dashboard")
                }
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                
                NavigationStack {
                    EntriesView(viewModel: EntriesViewModel(user: userId, dataService: dataService))
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
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
