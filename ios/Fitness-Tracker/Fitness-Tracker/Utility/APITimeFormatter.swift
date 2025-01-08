//
//  APITimeFormatter.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 8.1.25.
//

import Foundation

class APITimeFormatter: DateFormatter , @unchecked Sendable {
    static let shared = APITimeFormatter()
    
    private override init () {
        super.init()
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        self.timeZone = .gmt
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
