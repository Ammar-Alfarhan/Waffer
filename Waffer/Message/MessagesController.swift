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
        
        tableView.register(MessagesCell.self, forCellReuseIdentifier: cellId)
        
        observeUserMessages()
    }
    
    var messages = [Message]()
    var ids = [String:[String:Message]]()
    var messagesDictionary = [String:Message]()
    func observeUserMessages(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.keys.forEach({ (key) in
                let messagesRef = Database.database().reference().child("messages").child(key)
                messagesRef.observe(.value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String: Any] else { return }
                    
                    let message = Message(dictionary: dictionary)

                    let postId = message.postId
                    guard let userId = message.chatPartnerId() else { return }
                    self.messagesDictionary[postId] = message
                    self.ids[userId] = self.messagesDictionary
                    print("values",self.messagesDictionary.values)
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return message1.timestamp > message2.timestamp
                    })
                    self.timer?.invalidate()
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)

                }) { (err) in
                    print("Observe messages faild",err)
                    return
                }
            })
        }) { (err) in
            print("Observe user messages faild",err)
            return
        }
    }
 
    var timer: Timer?
    
    @objc func handleReloadTable() {
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            print("we reloaded the table")
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messages[indexPath.row]
        
        let postId = message.postId
        let fromId = message.fromId
        let toId = message.toId
        print("result=",checkFromIdOrToId(userId: fromId, postId: postId))
        if (checkFromIdOrToId(userId: fromId, postId: postId)) {
            
            Database.fetchUserWithUID(uid: fromId) { (user) in
                Database.fetchPostsWithUser(user: user, completion: { (post) in
                    print("post1",post)
                    if (post.id == postId){
                        self.showChatControllerForUser(post)
                    }
                })
            }
        } else {
            Database.fetchUserWithUID(uid: toId) { (user) in
                Database.fetchPostsWithUser(user: user, completion: { (post) in
                    if (post.id == postId){
                        print("post2",post)
                        self.showChatControllerForUser(post)
                    }
                })
            }
        }
    }
    
//    fileprivate func fetchPosts(_ user: User, _ postId: String) {
//
//        let postRef = Database.database().reference().child("posts").child(user.uid)
//        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            print("post",snapshot)
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//
//            dictionary.forEach({ (key, value) in
//                if (key == postId){
//                    guard let postDetails = value as? [String: Any] else { return }
//                    var post = Post(user: user, dictionary: postDetails)
//
//                    print("postDetails", postDetails)
//
//                    post.id = postId
//                    self.showChatControllerForUser(post)
//                }
//            })
//        }) { (err) in
//            print("Fail to fetch posts",err)
//            return
//        }
//    }
    
    fileprivate func checkFromIdOrToId(userId: String, postId: String) -> Bool{
        var postDic = [String]()
        let postRef = Database.database().reference().child("posts").child(userId)
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            dictionary.keys.forEach({ (key) in
                postDic.append(key)
            })
        }) { (err) in
            print("Fail to fetch posts",err)
            return
        }
        if (postDic.contains(postId)) {
            return true
        }
        return false
    }
    
    func showChatControllerForUser(_ post: Post) {
        print("post3",post)
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.post = post
        chatLogController.user = post.user
        navigationController?.pushViewController(chatLogController, animated: true)
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
