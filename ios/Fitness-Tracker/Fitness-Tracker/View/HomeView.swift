//
//  HomeView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 2.1.25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @AppStorage("userId") private var userId: Int = 0
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            
            // Macros
            ZStack {
                RoundedRectangle(cornerRadius: K.UI.cornerRadius)
                    .fill(K.UI.backgroundColor)
                
                VStack(spacing: 30) {
                    // Calories Ring View
                    ZStack {
                        RingProgressView(
                            progress: viewModel.calorieProgress,
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
                            intake: viewModel.fat,
                            title: "Fats",
                            color: .yellow)
                    }
                }
                .padding(35)
            }
        }
        .padding(.horizontal)
        .overlay(alignment: .bottom) {
            HStack(spacing: 20) {
                CircleButton(image: Image(systemName: "plus")) {
                    viewModel.activeSheet = .addEntry
                }
                CircleButton(image: Image("chatIcon")) {
                    viewModel.activeSheet = .chat
                }
            }
        }
        .sheet(item: $viewModel.activeSheet, onDismiss: {
            viewModel.activeSheet = nil
        }, content: { activeSheet in
            switch activeSheet {
            case .addEntry:
                NewEntryView(viewModel: NewEntryViewModel(dataService: DataService(),user: userId))
            case .chat:
                Text("Chat")
            }
        })
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(user: 1, dataService: MockDataService()))
}
