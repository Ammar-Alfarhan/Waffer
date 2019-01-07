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
    
    var post: Post? {
        didSet{
            navigationItem.title = post?.user.username
        }
    }
    
    let cellId = "cellId"
    
    
    override func viewDidLoad() {
        print(123)
        collectionView.backgroundColor = .red
        
        collectionView?.register(ChatLogCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        //setupInputComponents()
        fetchMessages()
    }
    
    var messages = [Message]()
    fileprivate func fetchMessages(){
        guard let postId = post?.id else { return }
        let ref = Database.database().reference().child("messages").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let message = Message(dictionary: dictionary)
//            print(message.message, message.fromId, message.toId)
            self.messages.append(message)
            self.collectionView?.reloadData()
        }) { (err) in
            print("Fail to fetch messages", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogCell
        
        cell.message = self.messages[indexPath.item]
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
        print("unwraped postId:", postId)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userMessageRef = Database.database().reference().child("messages").child(postId)
        let ref = userMessageRef.childByAutoId()
        guard let toId = post?.user.uid else { return }
        let timestamp = NSDate().timeIntervalSince1970
        let values = ["message": text, "toId": toId, "fromId": uid, "timestamp": timestamp] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Faild to save message to DB:", err)
                return
            }
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
