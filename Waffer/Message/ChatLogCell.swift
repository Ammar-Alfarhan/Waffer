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

        addSubview(bubbleView)
        addSubview(textView)

        //x,y,w,h
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
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
