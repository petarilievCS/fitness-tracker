//
//  CircleButton.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 13.1.25.
//

import SwiftUI

struct CircleButton: View {
    let image: Image
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Circle()
                    .fill(.blue)
                    .frame(width: 60, height: 60)
                
                image.resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.white)
                    .font(.system(size: 30, weight: .bold))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CircleButton(image: Image("chatIcon")) {
        print("Button tapped!")
    }
    CircleButton(image: Image(systemName: "plus")) {
        print("Button tapped!")
    }
}


