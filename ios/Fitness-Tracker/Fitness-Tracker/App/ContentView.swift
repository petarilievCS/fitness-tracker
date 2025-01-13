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
            HomeView(viewModel: HomeViewModel(user: userId, dataService: DataService()))
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
