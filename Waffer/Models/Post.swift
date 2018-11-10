//
//  Post.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 11/8/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import Foundation

struct Post {
   
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
