//
//  LoginViewModel.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 2.1.25.
//

import SwiftUI

@Observable
class LoginViewModel {
    var email: String = ""
    var password: String = ""
    
    func loginButtonPressed() {
        guard let url = URL(string: "https://flask-api-122291004318.us-central1.run.app/users") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("Error: \(error)")
                return
            }
            
            guard let data else {
                print("Data unavailable")
                return
            }
            
            print(String(data: data, encoding: .utf8))
        }
        task.resume()

//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error {
//                print("Error: \(error)")
//                return
//            }
//            
//            guard let data else {
//                print("No data")
//                return
//            }
//            
//            print("Works")
//        }
    }
}
