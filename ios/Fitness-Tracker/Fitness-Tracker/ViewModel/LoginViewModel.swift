//
//  LoginViewModel.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 2.1.25.
//

import SwiftUI

@Observable
class LoginViewModel {
    let userDefaults = UserDefaults.standard
    let dataService: DataServiceProtocol
    
    var email: String = ""
    var password: String = ""
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func loginButtonPressed() {
        // Validate user input
        if email == "" || password == "" {
            alertTitle = "Invalid login credentials"
            alertMessage = "Please enter valid email and password."
            showAlert.toggle()
            return
        }
        
        // Make API Request
        Task {
            do {
                let user = try await DataService().loginUser(email: email, password: password)
                alertTitle = "Success"
                alertMessage = "Successfully logged in."
                showAlert.toggle()
                userDefaults.set(user.id, forKey: "userId")
            } catch {
                alertTitle = "Error"
                alertMessage = "\(error)"
                showAlert.toggle()
            }
        }
    }
}
