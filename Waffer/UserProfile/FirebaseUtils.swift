//
//  FirebaseUtils.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 11/10/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
           // let user = User(uid: uid, dictionary: userDictionary)
           // completion(user)
            
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
}
