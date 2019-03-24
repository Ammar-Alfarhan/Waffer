//
//  UserProfileHeader.swift
//  Waffer
//
//  Created by Batool Alsmael on 10/27/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileCellDelegate {
    func didTapEdit()
    func didTapSold()
    func didTapBookmark()
    func didTapForSale()
}

class UserProfileHeader: UICollectionViewCell {
    
    var delegate: UserProfileCellDelegate?
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            if(user?.profileImageUrl == "")
            {
                profileImageView.image = UIImage(named:"plus_photo-1")
            }
            else
            {
               profileImageView.loadImage(urlString: profileImageUrl)
            }
            
            usernameLabel.text = user?.username
        }
    }
    
    var numberOfPosts: Int? {
        didSet{
            let attributedText = NSMutableAttributedString(string: "\(numberOfPosts ?? 0)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            
            postsLabel.attributedText = attributedText
        }
    }
    
   
    

    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    lazy var forSaleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("For sale", for: .normal)
        //button.tintColor = UIColor(white: 0, alpha: 0.2)
        //button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleForSale), for: .touchUpInside)
        return button
    }()
    
    @objc func handleForSale () {
        delegate?.didTapForSale()
        forSaleButton.tintColor = .mainBlue()
        soldButton.tintColor = UIColor(white: 0, alpha: 0.2)
        bookmarkButton.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    lazy var soldButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sold", for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleSold), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSold(){
        delegate?.didTapSold()
        soldButton.tintColor = .mainBlue()
        forSaleButton.tintColor = UIColor(white: 0, alpha: 0.2)
        bookmarkButton.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleBookmark), for: .touchUpInside)
        return button
    }()
    
    @objc func handleBookmark () {
        delegate?.didTapBookmark()
        bookmarkButton.tintColor = .mainBlue()
        forSaleButton.tintColor = UIColor(white: 0, alpha: 0.2)
        soldButton.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    let postsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        return button
    }()
    
     @objc func handleEditProfile() {
        delegate?.didTapEdit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
    
        
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        setupBottomToolbar()
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: forSaleButton.topAnchor, right: rightAnchor, paddingTop: 1, paddingLeft: 25, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        addSubview(postsLabel)
        postsLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: postsLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
    }
    
    fileprivate func setupBottomToolbar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [forSaleButton, soldButton, bookmarkButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
