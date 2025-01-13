//
//  NewEntryView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 13.1.25.
//

import SwiftUI

struct NewEntryView: View {
    @State var viewModel: NewEntryViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            CustomTextField(text: viewModel.name, placeholder: "Name", characterLimit: 100)
            CustomTextField(text: viewModel.calories, placeholder: "Calories", keyboardType: .numberPad)
            CustomTextField(text: viewModel.protein, placeholder: "Protein", keyboardType: .numberPad)
            CustomTextField(text: viewModel.carbs, placeholder: "Carbs", keyboardType: .numberPad)
            CustomTextField(text: viewModel.fat, placeholder: "Fats", keyboardType: .numberPad)
            CustomTextField(text: viewModel.servingSize, placeholder: "Serving Size", characterLimit: 25)
            CustomTextField(text: viewModel.numberOfServings, placeholder: "Number of Servings", keyboardType: .numberPad)
            
            DatePicker(
                "Date",
                selection: $viewModel.time,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.compact)
            .padding()
            .background(.gray.opacity(0.2))
            .cornerRadius(10)
            
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
                    .fontWeight(.bold)
            }
            
            Button() {
                isPresented = false
            } label: {
                Text("Cancel")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .fontWeight(.bold)
            }

        }
        .padding()
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = false
    NewEntryView(
        viewModel: NewEntryViewModel(dataService: MockDataService(), user: 1),
        isPresented: $isPresented)
}
