//
//  NewEntryView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 13.1.25.
//

import SwiftUI

struct NewEntryView: View {
    @State var viewModel: NewEntryViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 10) {
            CustomTextField(
                text: $viewModel.name,
                shakeTrigger: $viewModel.nameShakeTrigger,
                placeholder: viewModel.namePlaceholder,
                characterLimit: 100
            )
            CustomTextField(
                text: $viewModel.caloriesString,
                shakeTrigger: $viewModel.caloriesShakeTrigger,
                placeholder: viewModel.caloriesPlaceholder,
                keyboardType: .numberPad
            )
            CustomTextField(
                text: $viewModel.proteinString,
                shakeTrigger: $viewModel.proteinShakeTrigger,
                placeholder: viewModel.proteinPlaceholder,
                keyboardType: .numberPad
            )
            CustomTextField(
                text: $viewModel.carbsString,
                shakeTrigger: $viewModel.carbsShakeTrigger,
                placeholder: viewModel.carbsPlaceholder,
                keyboardType: .numberPad
            )
            CustomTextField(
                text: $viewModel.fatString,
                shakeTrigger: $viewModel.fatShakeTrigger,
                placeholder: viewModel.fatPlaceholder,
                keyboardType: .numberPad
            )
            CustomTextField(
                text: $viewModel.servingSizeString,
                shakeTrigger: $viewModel.servingSizeShakeTrigger,
                placeholder: viewModel.servingSizePlaceholder,
                characterLimit: 25
            )
            CustomTextField(
                text: $viewModel.numberOfServingsString,
                shakeTrigger: $viewModel.numberOfServingsShakeTrigger,
                placeholder: viewModel.numberOfServingsPlaceholder,
                keyboardType: .decimalPad
            )
            
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
                if viewModel.addEntryButtonTapped() {
                    dismiss()
                }
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
               dismiss()
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
        viewModel: NewEntryViewModel(dataService: MockDataService(), user: 1, onSave: {}))
}
