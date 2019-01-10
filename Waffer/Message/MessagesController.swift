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
        
//        observeMessages()
        
        observeUserMessages()
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            //print(dictionaries["messageId"])
            guard let messageId = dictionaries["messageId"] as? String else { return }
            print("messageId", messageId)
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observe(.value, with: { (snapshot) in
                print("snapshot2:", snapshot)
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                let message = Message(dictionary: dictionary)
//                self.messagesDictionary[key] = message
//                self.messages = Array(self.messagesDictionary.values)
                self.messages.append(message)
                self.messages.sort(by: { (message1, message2) -> Bool in
                    return message1.timestamp > message2.timestamp
                    /*
                dictionaries.forEach({ (key, value) in
                    print(value)
                    print(key)
                    guard let dictionary = value as? [String: Any] else { return }
                    let message = Message(dictionary: dictionary)
                    self.messagesDictionary[key] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return message1.timestamp > message2.timestamp
                    })*/
                })
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }, withCancel: { (err) in
                print(err)
                return
            })
            
        })
            { (err) in
            print("Observe user messages faild",err)
            return
        }
    }
        
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            //print(snapshot)
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let message = Message(dictionary: dictionary)
                //self.messages.append(message)
//                let toId = message.toId
//
//                self.messagesDictionary[toId] = message
                self.messagesDictionary[key] = message
                
                self.messages = Array(self.messagesDictionary.values)
                self.messages.sort(by: { (message1, message2) -> Bool in
                    return message1.timestamp > message2.timestamp
                })
                
                //self.postId = key
//                let postId = key
//                let toId = message.toId
//                Database.fetchUserWithUID(uid: toId, completion: { (user) in
//                    self.fetchPost(postId: postId, user: user)
//                })
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            })
        }, withCancel: nil)
    }
    
//    var posts = [Post]()
//    //All of this is to load the post image that the to go contacted at
//    func fetchPost(postId: String, user: User){
//        let ref = Database.database().reference().child("posts").child(postId)
//        ref.observe(.childAdded, with: { (snapshot) in
//            print(snapshot)
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//
//            let post = Post(user: user, dictionary: dictionary)
//            self.posts.append(post)
//        }) { (err) in
//            print(err)
//            return
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessagesCell
        
        let message = messages[indexPath.row]
        cell.message = message
        //let post = posts[indexPath.row]
        //cell.post = post
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
