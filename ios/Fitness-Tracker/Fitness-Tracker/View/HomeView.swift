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
        ZStack {
            RingProgressView(
                progress: viewModel.progress,
                lineWidth: 50.0
            )
            VStack {
                Text("1000")
                    .fontWeight(.heavy)
                    .font(.system(size: 60))
                Text("2500 kcal")
                    .font(.system(size: 22))
                    .foregroundStyle(.secondary)
            }
        }

        .padding(.horizontal, 50)
        Button("Increase progress") {
            viewModel.progress += 0.1
        }
    }
}

#Preview {
    HomeView()
}
