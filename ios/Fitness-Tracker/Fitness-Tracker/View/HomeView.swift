//
//  HomeView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 2.1.25.
//

import SwiftUI

struct HomeView: View {
   @State private var viewModel = HomeViewModel()
    
    var body: some View {
        RingProgressView(
            progress: viewModel.progress,
            lineWidth: 50.0
        )
        .padding(.horizontal, 50)
        Button("Increase progress") {
            viewModel.progress += 0.1
        }
    }
}

#Preview {
    HomeView()
}
