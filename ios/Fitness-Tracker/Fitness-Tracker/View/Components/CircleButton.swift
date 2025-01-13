//
//  CircleButton.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 13.1.25.
//

import SwiftUI

struct CircleButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Circle()
                    .fill(.blue)
                    .frame(width: 60, height: 60)
                
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .font(.system(size: 30, weight: .bold))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CircleButton {
        print("Button tapped!")
    }
}
