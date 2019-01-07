//
//  User.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 11/20/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}
