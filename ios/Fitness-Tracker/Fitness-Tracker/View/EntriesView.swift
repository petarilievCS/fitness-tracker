//
//  EntriesView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 6.2.25.
//

import SwiftUI

struct EntriesView: View {
    @State private var viewModel: EntriesViewModel
    private let testList = [1, 2, 3]
    
    init(dataService: DataServiceProtocol, userId: Int) {
        self.viewModel = EntriesViewModel(user: userId, dataService: dataService)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.entries, id: \.name) { entry in
                TableCellView(entry: entry)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteEntry(entry)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
    }
}

#Preview {
    EntriesView(dataService: MockDataService(), userId: 0)
}
