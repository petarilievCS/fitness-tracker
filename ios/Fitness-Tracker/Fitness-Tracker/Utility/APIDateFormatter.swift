//
//  APIDateFormatter.swift
//  Fitness-Tracker
//
//  Created by Petar Iliev on 3.1.25.
//

import Foundation

class APIDateFormatter: DateFormatter , @unchecked Sendable {
    override init () {
        super.init()
        self.dateFormat = "yyyy-MM-dd"
        self.timeZone = .gmt
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
