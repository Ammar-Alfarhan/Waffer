//
//  NewMessagesController.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 1/26/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var user: User? {
        didSet{
            guard let user = user else { return }
            users.append(user)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MessagesCell.self, forCellReuseIdentifier: cellId)
        
//        fetchUsers()
    }
    var users = [User]()
    var filterUsers = [User]()
    func fetchUsers(){
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot)
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            //            print("dictionaries=", dictionaries)
            dictionaries.forEach({ (key, value) in
//                print("key \(key) value \(value)")
                guard let dictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: dictionary)
                self.users.append(user)
//                self.filterUsers = self.users.
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            })
        }) { (err) in
            print("Faild to fatch users:", err)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessagesCell
        let user = users[indexPath.row]
//        print("user",user)
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = user.email
        let profileImage = user.profileImageUrl
        cell.itemImageView.loadImage(urlString: profileImage)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        print(user)
        self.messagesController?.showChatControllerForUser(user)
//        dismiss(animated: true) {
//            print("Dismiss completed")
//            let user = self.users[indexPath.row]
//            print(user)
//            //self.messagesController?.showChatControllerForUser(user)
//        }
    }
}
