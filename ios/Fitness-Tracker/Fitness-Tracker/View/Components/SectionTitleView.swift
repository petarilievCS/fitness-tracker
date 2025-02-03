//
//  SectionTitleView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 28.1.25.
//

import SwiftUI

struct SectionTitleView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.horizontal)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

