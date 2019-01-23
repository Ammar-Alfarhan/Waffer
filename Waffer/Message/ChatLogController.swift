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
            
        }
    }
    var user: User? {
        didSet{
            navigationItem.title = user?.username
            fetchMessages()
        }
    }
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        collectionView.backgroundColor = .white
        
        collectionView?.register(ChatLogCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.keyboardDismissMode = .interactive
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    var messages = [Message]()
    fileprivate func fetchMessages(){
        guard let postId = post?.id else { return }
        guard let toId = post?.user.uid else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.keys.forEach({ (key) in
                let messagesRef = Database.database().reference().child("messages").child(key)
                messagesRef.observe(.value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String: Any] else { return }
                    
                    let message = Message(dictionary: dictionary)
                    
                    if message.postId == postId {
                        self.messages.append(message)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return message1.timestamp < message2.timestamp
                        })
                        //                        self.collectionView?.reloadData()
                        DispatchQueue.main.async(execute: {
                            self.collectionView?.reloadData()
                        })
                    }
                }) { (err) in
                    print("Fail to fetch messages",err)
                    return
                }
            })
        }) { (err) in
            print("Fail to fetch user messages", err)
            return
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.message
        
        setupCell(cell,message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.message).width + 32
        return cell
    }
    
    fileprivate func setupCell(_ cell: ChatLogCell,_ message: Message) {
        
//        guard let image = user?.profileImageUrl else { return }
//        cell.profileImageView.loadImage(urlString: image)
        
        if (message.fromId == Auth.auth().currentUser?.uid){
            cell.bubbleView.backgroundColor = ChatLogCell.blueColor
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = .black
            print("toid=", message.toId)
            Database.fetchUserWithUID(uid: message.fromId) { (user) in
                print("image=",user.profileImageUrl)
                cell.profileImageView.loadImage(urlString: user.profileImageUrl)
            }
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        //get estimated height somehow????
        let text = messages[indexPath.item].message
        height = estimateFrameForText(text).height + 20
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
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
            let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(postId).child(toId).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(postId).child(uid).child(messageId)
            recipientUserMessagesRef.setValue(1)
//            self.collectionView.reloadData()
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
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
