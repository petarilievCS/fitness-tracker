//
//  RingProgressView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 4.1.25.
//

import SwiftUI

struct RingProgressView: View {
    var progress: Double // A value between 0.0 and 1.0
    var lineWidth: CGFloat = 10
    var ringColor: Color = .blue
    var backgroundColor: Color = .gray.opacity(0.2)

    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)

            // Progress Circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(ringColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90)) // Start from top
                .animation(.easeInOut, value: progress)
        }
        .padding(lineWidth / 2)
    }
}
