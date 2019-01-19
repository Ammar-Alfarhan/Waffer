//
//  HomePostCell.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 11/10/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase

protocol HomePostCellDelegate {
    func didTapContact(post: Post)
}

class HomePostCell: UICollectionViewCell {
    
    var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet{
            
            guard let postImageUrl = post?.imageUrl else { return }
            
            photoImageView.loadImage(urlString: postImageUrl)
            
            //usernameLable.text = "Test username"
            
            usernameLable.text = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            
            userProfileImage.loadImage(urlString: profileImageUrl)
            
            setupAttributedCaption()
        }
    }
    
    
    
     fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        
        print ("post \(post.user.username)")
        print ("post uid \(post.user.uid)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print ("uid \(uid)")
        if ( (post.user.uid) != uid)
        {
            print("not equal to each other")
            contactButton.isHidden = false
        }
        
        
        let attributedText = NSMutableAttributedString(string: post.titleCaption, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(post.priceCaption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        captionLabel.attributedText = attributedText
     }
    
    let userProfileImage: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .gray
        //iv.image = UIImage(named: "plus_photo-1")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        //let image = iv.image
        //let newImage = imageSizeToContainer(image)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
//    func imageSizeToContainer(image: UIImage) -> UIImage{
//        let ratio = image.size.width / image.size.height
//        if frame.width > frame.height {
//            let newHeight = frame.width / ratio
//            photoImageView.frame.size = CGSize(width: frame.width, height: newHeight)
//        }
//        else{
//            let newWidth = frame.height * ratio
//            photoImageView.frame.size = CGSize(width: newWidth, height: frame.height)
//        }
//    }
    
//    lazy var showAdButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(showAdController), for:.touchUpInside)
//        //button.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(showAdController)))
//        return button
//    }()
//
//    @objc func showAdController() {
//        print("Hello", 123)
//    }
    
    lazy var contactButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleContact), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    @objc func handleContact(){
        print("Go to chat..")
        guard let post = post else { return }
        delegate?.didTapContact(post: post)
    }
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let usernameLable: UILabel = {
        let lable = UILabel()
        //lable.text = "Username"
        lable.font = UIFont.boldSystemFont(ofSize: 14)
        return lable
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(photoImageView)
        addSubview(userProfileImage)
        addSubview(usernameLable)
        
       
        
        userProfileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userProfileImage.layer.cornerRadius = 40 / 2
        photoImageView.anchor(top: userProfileImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        usernameLable.anchor(top: topAnchor, left: userProfileImage.rightAnchor, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        guard let post = self.post else { return }
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        print("id of the user posted \(post.user.uid)")
//        print("id of the user loggd \(uid)")
        
//        if (post.user.uid != uid)
//        {
//            contactButton.isHidden = false
//            print("id of the user posted \(post.user.uid)")
//        }
        
        setupActionButtons()
        
        addSubview(captionLabel)
        captionLabel.anchor(top: contactButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
    }
    
    fileprivate func setupActionButtons() {
        
        
        let stackView = UIStackView(arrangedSubviews: [bookmarkButton, contactButton])
        
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 80, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
