//
//  ChatViewModel.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 17.2.25.
//

import SwiftUI

@Observable
class ChatViewModel: ObservableObject {
    private var dataService: DataServiceProtocol
    private let user: Int
    
    var text: String = ""
    var isLoading: Bool = false
    var entryAdded = false
    
    var isButtonDisabled: Bool {
        return isLoading || text.isEmpty
    }
    
    var buttonColor: Color {
        return isButtonDisabled ? .gray : .blue
    }
    
    init(dataService: DataServiceProtocol, user: Int) {
        self.dataService = dataService
        self.user = user
    }
    
    func submitButtonTapped() {
        Task {
            try await dataService.parseMeal(text, for: user)
            entryAdded = true
        }
    }
}
