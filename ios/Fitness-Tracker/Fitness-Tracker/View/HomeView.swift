//
//  HomeView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 2.1.25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel.mock()
    
    var body: some View {
        ScrollView {
            // Macros
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.2))
                    .padding()
                
                VStack(spacing: 30) {
                    // Calories Ring View
                    ZStack {
                        RingProgressView(
                            progress: viewModel.caloriesProgress,
                            lineWidth: 50.0
                        )
                        VStack {
                            Text("\(Int(viewModel.calories))")
                                .fontWeight(.heavy)
                                .font(.system(size: 60))
                                .fontDesign(.rounded)
                            Text("\(Int(viewModel.calorieGoal)) KCAL")
                                .font(.system(size: 22))
                                .foregroundStyle(.secondary)
                                .fontDesign(.rounded)
                        }
                    }
                    
                    // Macros Ring Views
                    HStack(spacing: 20) {
                        MacroRingProgressView(
                            progress: viewModel.proteinProgress,
                            goal: viewModel.proteinGoal,
                            intake: viewModel.protein,
                            title: "Protein",
                            color: .red)
                        MacroRingProgressView(
                            progress: viewModel.carbsProgress,
                            goal: viewModel.carbsGoal,
                            intake: viewModel.carbs,
                            title: "Carbs",
                            color: .green)
                        MacroRingProgressView(
                            progress: viewModel.fatsProgress,
                            goal: viewModel.fatsGoal,
                            intake: viewModel.fats,
                            title: "Fats",
                            color: .yellow)
                    }
                }
                .padding(50)
            }
            
            // Entries
        }
    }
}

#Preview {
    HomeView()
}
