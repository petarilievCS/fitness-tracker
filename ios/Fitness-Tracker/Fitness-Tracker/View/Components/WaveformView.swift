//
//  WaveformView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 24.2.25.
//

import SwiftUI

struct WaveformView: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<20, id: \.self) { _ in
                Capsule()
                    .frame(width: 4, height: CGFloat.random(in: 10...100))
                    .scaleEffect(scale, anchor: .bottom)
                    .animation(.easeInOut(duration: 0.3).repeatForever(), value: scale)
            }
        }.onAppear() {
            scale = 1.2
        }
    }
}

#Preview {
    WaveformView()
}
