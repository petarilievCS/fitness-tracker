//
//  NewEntryView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 13.1.25.
//

import SwiftUI

struct NewEntryView: View {
    @State private var viewModel: NewEntryViewModel
    
    init(viewModel: NewEntryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TextField("Name", text: $viewModel.name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("Calories", text: $viewModel.calories)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
        TextField("Protein", text: $viewModel.protein)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
        TextField("Carbs", text: $viewModel.carbs)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
        TextField("Fats", text: $viewModel.fat)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
        TextField("Serving Size", text: $viewModel.numberOfServings)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("Number of Servings", text: $viewModel.numberOfServings)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
    }
}

#Preview {
    NewEntryView(viewModel: NewEntryViewModel(dataService: MockDataService(), user: 1))
}
