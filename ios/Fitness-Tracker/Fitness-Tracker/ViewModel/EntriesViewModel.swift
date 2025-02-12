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
    var entries: [Entry] {
        dataService.entries
    }
    
    init(user: Int, dataService: DataServiceProtocol) {
        self.dataService = dataService
        self.user = user
        // loadData()
    }
    
    func deleteEntry(_ entry: Entry) {
        Task {
            try await dataService.deleteEntry(entry)
        }
    }
    
    func loadData() {
        Task {
            do {
               try await dataService.fetchEntries(for: user)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
