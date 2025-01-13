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
        CustomTextField(text: viewModel.name, placeholder: "Name", characterLimit: 100)
        CustomTextField(text: viewModel.calories, placeholder: "Calories", keyboardType: .numberPad)
        CustomTextField(text: viewModel.protein, placeholder: "Protein", keyboardType: .numberPad)
        CustomTextField(text: viewModel.carbs, placeholder: "Carbs", keyboardType: .numberPad)
        CustomTextField(text: viewModel.fat, placeholder: "Fats", keyboardType: .numberPad)
        CustomTextField(text: viewModel.servingSize, placeholder: "Serving Size", characterLimit: 25)
        CustomTextField(text: viewModel.numberOfServings, placeholder: "Number of Servings", keyboardType: .numberPad)
        
        Button(action :{
            viewModel.addEntry()
        }) {
            Text("Save")
                .padding()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(.blue)
                .foregroundStyle(.white)
                .cornerRadius(10)
        }
    }
}

#Preview {
    NewEntryView(viewModel: NewEntryViewModel(dataService: MockDataService(), user: 1))
}
