//
//  LoginInfo.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 4.1.25.
//

struct LoginRequest: Encodable {
    let email: String
    let password_hash: String
}
