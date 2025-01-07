//
//  MacroRingProgressView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 7.1.25.
//

import SwiftUI

struct MacroRingProgressView: View {
    var progress: Double
    var goal: Double
    var intake: Double
    
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RingProgressView(
                    progress: progress,
                    lineWidth: 15,
                    ringColor: color
                )
                Text("\(Int(intake))")
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                    .fontDesign(.rounded)
            }
    
            VStack {
                Text(title)
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .fontDesign(.rounded)
                Text("of \(Int(goal)) g")
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .fontDesign(.rounded)
            }
        }
    }
}
