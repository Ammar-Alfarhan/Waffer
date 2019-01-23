//
//  ChatLogCell.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 1/6/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//

import UIKit

class ChatLogCell: UICollectionViewCell {

    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        return tv
    }()

    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()

    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(bubbleView)
        addSubview(textView)

        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
//        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
//        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        //x,y,w,h
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true

        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        //ios 9 constraints
        //x,y,w,h
        //        textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        //        textView.widthAnchor.constraintEqualToConstant(200).active = true


        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



/*
 import UIKit
 
 class ChatLogCell: UICollectionViewCell {
 
 let textView: UITextView = {
 let tv = UITextView()
 tv.text = "SAMPLE TEXT FOR NOW"
 tv.font = UIFont.systemFont(ofSize: 16)
 tv.translatesAutoresizingMaskIntoConstraints = false
 tv.backgroundColor = UIColor.clear
 tv.textColor = .blue
 return tv
 }()
 
 let bubbleView: UIView = {
 let view = UIView()
 view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
 view.translatesAutoresizingMaskIntoConstraints = false
 view.layer.cornerRadius = 16
 view.layer.masksToBounds = true
 return view
 }()
 
 var bubbleWidthAnchor: NSLayoutConstraint?
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 backgroundColor = .white
 
 addSubview(textView)
 //        addSubview(bubbleView)
 //
 //        bubbleView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
 //        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
 //        bubbleWidthAnchor?.isActive = true
 textView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
 }
 
 required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 }

 */
