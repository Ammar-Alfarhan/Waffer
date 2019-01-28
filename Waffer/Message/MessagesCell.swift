//
//  MessagesCell.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 1/7/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase

class MessagesCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            
            guard let userId = message?.chatPartnerId() else { return }
            Database.fetchUserWithUID(uid: userId) { (user) in
                let imageUrl = user.profileImageUrl
                self.textLabel?.text = user.username
                self.itemImageView.loadImage(urlString: imageUrl)
            }
            
            detailTextLabel?.text = message?.message
            
            let timeAgoDisplay = message?.timestamp.timeAgoDisplay()
            timeLabel.text = timeAgoDisplay
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let itemImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
//        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(itemImageView)
        addSubview(timeLabel)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        itemImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        itemImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        //need x,y,width,height anchors
//        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
//        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
        timeLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 18, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 100, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
