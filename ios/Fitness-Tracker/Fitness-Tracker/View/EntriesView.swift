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
    
    init(viewModel: EntriesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.entries, id: \.name) { entry in
            TableCellView(entry: entry)
        }
    }
}

#Preview {
    EntriesView(viewModel: EntriesViewModel(user: 1, dataService: MockDataService()))
}
