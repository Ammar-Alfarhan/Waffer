//
//  MessagesController.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 1/7/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Messages Controller")
        
        tableView.register(MessagesCell.self, forCellReuseIdentifier: cellId)
        
        observeMessages()
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            print(snapshot)
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let message = Message(dictionary: dictionary)
                //self.postId = key
                let postId = key
                let toId = message.toId
                Database.fetchUserWithUID(uid: toId, completion: { (user) in
                    self.fetchPost(postId: postId, user: user)
                })
                self.messages.append(message)
            })
            if let dictionary = snapshot.value as? [String: Any] {
                let message = Message(dictionary: dictionary)
                print(message)
                //                self.messages.append(message)
                
//                if let toId = message.toId {
//                    self.messagesDictionary[toId] = message
//
//                    self.messages = Array(self.messagesDictionary.values)
//                    self.messages.sort(by: { (message1, message2) -> Bool in
//
//                        return message1.timestamp?.int32Value > message2.timestamp?.int32Value
//                    })
//                }
                
                //this will crash because of background thread, so lets call this on dispatch_async main thread
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            
        }, withCancel: nil)
    }
    
    //All of this is to load the post image that the to go contacted at
    func fetchPost(postId: String, user: User){
        let ref = Database.database().reference().child("posts").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
        
            let post = Post(user: user, dictionary: dictionary)
            
        }) { (err) in
            print(err)
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessagesCell
        
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
