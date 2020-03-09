//
//  Post.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 11/8/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import Foundation

struct Post {
   
    var id: String?
    
    let imageUrl: String
    let user: User
    let descriptionCaption: String
    let titleCaption: String
    let priceCaption: String
    let categoryCaption: String
    let creationDate: Date
    let city: String
    
    var bookmark = false
    var sold = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.descriptionCaption = dictionary["descriptionCaption"] as? String ?? ""
        self.titleCaption = dictionary["titleCaption"] as? String ?? ""
        self.priceCaption = dictionary["priceCaption"] as? String ?? ""
        self.categoryCaption = dictionary["categoryCaption"] as? String ?? ""
        self.city = dictionary["city"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
