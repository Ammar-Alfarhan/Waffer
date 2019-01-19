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
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
    
    static func fetchPostsWithUser(user: User, completion: @escaping (Post) -> ()) {
        Database.database().reference().child("posts").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                completion(post)
            })
        }) { (err) in
            print("Fail to fetch posts",err)
            return
        }
    }
}
