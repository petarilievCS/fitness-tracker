//
//  CustomTextField.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 13.1.25.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    @Binding var shakeTrigger: Bool
    
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var characterLimit: Int = 10
    
    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(keyboardType)
            .onChange(of: text) { oldValue, newValue in
                if newValue.count > characterLimit {
                    text = oldValue
                }
            }
            .modifier(ShakeEffect(shakes: shakeTrigger ? 2 : 0))
    }
}

struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -5 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}
