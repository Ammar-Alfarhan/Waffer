//
//  ChatLogCell.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 1/6/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//

import UIKit

class ChatLogCell: UICollectionViewCell {
    
//    var message: Message? {
//        didSet{
//            //print(message?.message)
//            txtLable.text = message?.message
//        }
//    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 15)
        //lable.numberOfLines = 0
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        
        addSubview(textView)
        
        textView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
