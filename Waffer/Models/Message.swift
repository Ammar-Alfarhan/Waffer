//
//  Message.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 1/6/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//

import Foundation

struct Message {
    let message: String
    let fromId: String
    let toId: String
    let timestamp: Date
    
    init(dictionary: [String: Any]) {
        self.message = dictionary["message"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["timestamp"] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
