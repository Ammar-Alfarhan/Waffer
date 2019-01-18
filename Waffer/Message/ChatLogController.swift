//
//  ChatLogController.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 1/4/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var post: Post?
    var user: User? {
        didSet{
            navigationItem.title = user?.username
        }
    }
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        collectionView.backgroundColor = .white
        
        collectionView?.register(ChatLogCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        fetchMessages()
        //setupInputComponents()
    }
    
    var messages = [Message]()
    fileprivate func fetchMessages(){
        guard let postId = post?.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            //print("snapshot1:", snapshot.key)
            guard let dictionaries = snapshot.value as? [String: Any] else { return }

            dictionaries.keys.forEach({ (key) in
                print("key=", key)
                let messagesRef = Database.database().reference().child("messages").child(key)
                messagesRef.observe(.value, with: { (snapshot) in
                    print("snapshot2:", snapshot)
                    guard let dictionary = snapshot.value as? [String: Any] else { return }
                    
                    let message = Message(dictionary: dictionary)
                    //                print("Messages info",message.message, message.fromId, message.toId)
                    
                    print(dictionary)
                    
                    //                print("Message chatPartnerId=", message.chatPartnerId())
                    print("postId=", self.post?.id)
                    print("Message.postId", message.postId)
                    //                print("user.uid= \(self.user?.uid)")
                    if message.postId == postId {
                        if message.chatPartnerId() == self.user?.uid{
                            self.messages.append(message)
                            DispatchQueue.main.async(execute: {
                                self.collectionView?.reloadData()
                            })
                        }
                    }
                    
                    //                self.messages.append(message)
                    //                self.collectionView?.reloadData()
                }) { (err) in
                    print("Fail to fetch messages",err)
                    return
                }
            })
            print(dictionaries.keys)
            guard let messageId = dictionaries[""] as? String else { return }
            print("MessageId=", messageId)
            
        }) { (err) in
            print("Fail to fetch user messages", err)
            return
        }
        
        
        /*
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            print(snapshot.value)
        }) { (err) in
            print("Fail to fetch messages for a user\(uid)", err)
        }*/
        
        
        /*
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            print("snapshot: ", snapshot)
            print("key=",snapshot.key)
//            guard let dictionaries = snapshot.key as? [String: Any] else { return }
            let postId = snapshot.key
            //print("dictionaries", dictionaries)
        
            print("postId=", postId)
            let messagesRef = Database.database().reference().child("messages").child(postId)
            messagesRef.observe(.value, with: { (snapshot) in
                print("Messages snapshot=", snapshot)
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                let message = Message(dictionary: dictionary)
                
//                if message.chatPartnerId() == uid  && message.postId == postId {
//                    self.messages.append(message)
//                    DispatchQueue.main.async(execute: {
//                        self.collectionView?.reloadData()
//                    })
//                }
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                })
//            }, withCancel: { (err) in
//                print(err)
            }) { (err) in
                print("Fail to fetch messages",err)
                return
            }
        }) { (err) in
            print("Fail to fetch messages for postId", err)
            return
        }*/
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.message
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = true
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = self
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: UIControl.State())
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSend(){
        guard let text = inputTextField.text else { return }
        
        guard let postId = post?.id else { return }
        //print("unwraped postId:", postId)
        guard let imageUrl = post?.imageUrl else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        guard let toId = post?.user.uid else { return }
        let timestamp = NSDate().timeIntervalSince1970
        let values = ["message": text, "toId": toId, "fromId": uid, "timestamp": timestamp, "imageUrl": imageUrl, "postId": postId] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            guard let messageId = childRef.key else { return }
            let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(postId).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(postId).child(messageId)
            recipientUserMessagesRef.setValue(1)
            print("Successfully saved message to DB")
        }
        inputTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        containerView.autoresizingMask = .flexibleHeight
        
        containerView.addSubview(sendButton)
        containerView.addSubview(inputTextField)
        
        sendButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, right: containerView.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 50)
        
        inputTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        containerView.addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get{
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
//    func setupInputComponents(){
//        let containerView = UIView()
//        containerView.backgroundColor = .white
//
//        containerView.autoresizingMask = .flexibleHeight
//
//        view.addSubview(containerView)
//
//        containerView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
//
//        containerView.addSubview(sendButton)
//        containerView.addSubview(inputTextField)
//
//        sendButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, right: containerView.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 50)
//
//        inputTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
//
//        let lineSeparatorView = UIView()
//        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
//        containerView.addSubview(lineSeparatorView)
//        lineSeparatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
//    }
}
