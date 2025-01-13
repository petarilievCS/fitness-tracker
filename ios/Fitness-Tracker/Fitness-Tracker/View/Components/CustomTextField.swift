//
//  CustomTextField.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 13.1.25.
//

import SwiftUI

struct CustomTextField: View {
    @State var text: String
    
    let placeholder: String
    let keyboardType: UIKeyboardType
    let characterLimit: Int
    
    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(keyboardType)
            .onChange(of: text) { oldValue, newValue in
                if newValue.count > characterLimit {
                    text = oldValue
                }
            }
    }
    
    init(text: String,
         placeholder: String,
         keyboardType: UIKeyboardType = .default,
         characterLimit: Int = 10
    ) {
        self.text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.characterLimit = characterLimit
    }
}
