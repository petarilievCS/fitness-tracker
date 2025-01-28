//
//  TableCellView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 25.1.25.
//

import SwiftUI

struct TableCellView: View {
    let viewModel: TableCellViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.name).fontWeight(.bold)
                Text(viewModel.servings).foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack {
                Text(viewModel.calories)
                Text(" ")
            }
        }
        .padding()
        .background(K.UI.backgroundColor)
    }
}

#Preview {
    TableCellView(viewModel: TableCellViewModel(entry: .mock()))
        .padding()
}

struct TableCellViewModel {
    let entry: Entry
    
    var name: String {
        return entry.name
    }
    
    var servings: String {
        return "\(numServingsString) " + (entry.numServings == 1.0 ? "serving" : "servings")
    }
    
    var calories: String {
        return String(entry.calories)
    }
    
    private var numServingsString: String {
        if entry.numServings.truncatingRemainder(dividingBy: 1) == 0 {
            // Whole number
            return String(Int(entry.numServings))
        } else if (entry.numServings * 10).truncatingRemainder(dividingBy: 1) == 0 {
            // One decimal place
            return String(format: "%.1f", entry.numServings)
        } else {
            // Two decimal places
            return String(format: "%.2f", entry.numServings)
        }
    }
}
