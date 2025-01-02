//
//  CapsuleTextView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 2.1.25.
//

import SwiftUI

struct CapsuleTextField: View {
    var placeholder: String = ""
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .capsuleTextFieldStyle()
        } else {
            TextField(placeholder, text: $text)
                .capsuleTextFieldStyle()
        }
    }
}

struct CapsuleTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.gray.opacity(0.2))
            .clipShape(.capsule)
            .overlay(
                Capsule().stroke(.blue, lineWidth: 2)
            )
    }
}

extension View {
    func capsuleTextFieldStyle() -> some View {
        self.modifier(CapsuleTextFieldStyle())
    }
}
