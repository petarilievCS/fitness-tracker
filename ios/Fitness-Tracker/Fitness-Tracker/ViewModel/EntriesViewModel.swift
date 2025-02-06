//
//  EntriesViewModel.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 5.2.25.
//

import SwiftUI

@Observable
class EntriesViewModel {
    private let dataService: DataServiceProtocol
    private let user: Int
    var entries: [Entry] = []
    
    init(user: Int, dataService: DataServiceProtocol) {
        self.dataService = dataService
        self.user = user
        loadData()
    }
    
    func loadData() {
        Task {
            do {
                self.entries = try await dataService.fetchEntries(for: user)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
