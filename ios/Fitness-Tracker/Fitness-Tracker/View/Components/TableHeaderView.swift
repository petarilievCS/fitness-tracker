//
//  TableHeaderView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 28.1.25.
//

import SwiftUI

struct TableHeaderView: View {
    var body: some View {
        HStack {
            Text("Entries")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            Spacer()
        }
        .background(K.UI.backgroundColor)
        .cornerRadius(K.UI.cornerRadius, corners: [.topLeft, .topRight])
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    TableHeaderView()
}
