//
//  LoginView.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 2.1.25.
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            CapsuleTextField(placeholder: "Email", text: $viewModel.email)
            CapsuleTextField(placeholder: "Password", text: $viewModel.password, isSecure: true)
            
            Button(action: {
                viewModel.loginButtonPressed()
            }) {
                Text("Log In")
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .clipShape(.capsule)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
