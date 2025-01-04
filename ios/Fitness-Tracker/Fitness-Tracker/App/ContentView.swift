//
//  ContentView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 31.12.24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userId") private var userId: Int?
    
    var body: some View {
        if userId != nil {
            HomeView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
