//
//  ChatView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 13.2.25.
//

import SwiftUI

struct ChatView:  View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Describe what you ate:")
                .font(.title2)
                .bold()
            
            TextField("", text: $viewModel.text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
                ProgressView("Analyzing food...")
                    .padding()
            }
            
            if viewModel.isLoading {
                            ProgressView("Analyzing food...")
                                .padding()
                        }
            Button {
                viewModel.submitButtonTapped()
            } label: {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.buttonColor)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.isButtonDisabled)
            .padding()
            
            Spacer()
        }
        .padding()
        .onChange(of: viewModel.entryAdded) { _, added in
            if added {
                dismiss()
            }
        }
    }
}

@Observable
class ChatViewModel: ObservableObject {
    private var dataService: DataServiceProtocol
    
    var text: String = ""
    var isLoading: Bool = false
    var entryAdded = false
    
    var isButtonDisabled: Bool {
        return isLoading || text.isEmpty
    }
    
    var buttonColor: Color {
        return isButtonDisabled ? .gray : .blue
    }
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func submitButtonTapped() {
        Task {
            try await dataService.sendText(text)
        }
    }
}

#Preview {
    ChatView(viewModel: ChatViewModel(dataService: MockDataService()))
}
