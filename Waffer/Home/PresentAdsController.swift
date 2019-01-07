//
//  PresentAds.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 11/24/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import UIKit

class PresentAdsController: UIViewController {

    //let
    
    var caption: Post?
//    {
//        didSet{
//
////            guard let postImageUrl = post?.imageUrl else { return }
////
////            photoImageView.loadImage(urlString: postImageUrl)
////
////            //usernameLable.text = "Test username"
////
////            usernameLable.text = post?.user.username
////
////            guard let profileImageUrl = post?.user.profileImageUrl else { return }
////
////            userProfileImage.loadImage(urlString: profileImageUrl)
////
////            setupAttributedCaption()
//        }
//    }
    
    //var caption = [Post]()
    var imageUrl = ""
//    var descriptionCaption = ""
//    var creationDate = ""
//    var titleCaption = ""
//    var priceCaption = ""
//    var catecoryCaption = ""
    
    override func viewDidLoad() {
        //here will make the ads get presented
        
        view.backgroundColor = .white
        
        print("caption=", caption ?? "default value")
        
        //print(caption[Post[])
        
        //print(imageUrl)
        
        setupView()
        setupNavigationButtons()
        setupDescriptionItems()
    }
        
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel : UILabel = {
        let l = UILabel()
        l.text = "Title: "
        l.font =  UIFont.boldSystemFont(ofSize: 16.0)
        l.textColor = UIColor(red: 135/255, green: 0/255, blue: 0/255, alpha: 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
//    let titleValueLabel : UILabel = {
//        let l = UILabel()
//        l.text = "Title Value "
//        l.font =  UIFont.boldSystemFont(ofSize: 16.0)
//        l.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
//        l.translatesAutoresizingMaskIntoConstraints = false
//        return l
//    }()
    
    
    let categoryLabel : UILabel = {
        let l = UILabel()
        l.text = "  Category: "
        l.font =  UIFont.boldSystemFont(ofSize: 16.0)
        l.textColor = UIColor(red: 135/255, green: 0/255, blue: 0/255, alpha: 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
//    let categoryValueLabel : UILabel = {
//        let l = UILabel()
//        l.text = "Title Value "
//        l.font =  UIFont.boldSystemFont(ofSize: 16.0)
//        l.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
//        l.translatesAutoresizingMaskIntoConstraints = false
//        return l
//    }()
    
    let descriptionLabel : UILabel = {
        let l = UILabel()
        l.text = "Description: "
        l.font =  UIFont.boldSystemFont(ofSize: 16.0)
        l.textColor = UIColor(red: 135/255, green: 0/255, blue: 0/255, alpha: 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let descriptionValueLabel : UILabel = {
        let l = UILabel()
        l.text = "Description Value "
        l.font =  UIFont.boldSystemFont(ofSize: 16.0)
        l.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let priceLabel : UILabel = {
        let l = UILabel()
        l.text = "   Price: "
        l.font =  UIFont.boldSystemFont(ofSize: 16.0)
        l.textColor = UIColor(red: 135/255, green: 0/255, blue: 0/255, alpha: 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
//    let priceValueLabel : UILabel = {
//        let l = UILabel()
//        l.text = "Price Value "
//        l.font =  UIFont.boldSystemFont(ofSize: 16.0)
//        l.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
//        l.translatesAutoresizingMaskIntoConstraints = false
//        return l
//    }()
    
    
    func setupDescriptionItems(){
        view.addSubview(titleLabel)
        titleLabel.text = "Title : " + "\(caption?.titleCaption ?? "")"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
//        view.addSubview(titleValueLabel)
//        titleValueLabel.text=caption?.titleCaption
//        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        titleValueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
//        titleValueLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 25).isActive = true
//        titleValueLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
//        titleValueLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(categoryLabel)
        //titleValueLabel.text=caption?.categoryCaption
        categoryLabel.text = "Category : " + "\(caption?.categoryCaption ?? "")"
        categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        categoryLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
//        view.addSubview(categoryValueLabel)
//        categoryValueLabel.text=caption?.categoryCaption
//        categoryValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        categoryValueLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 25).isActive = true
//        categoryValueLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
//        categoryValueLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(priceLabel)
        priceLabel.text = "Price : $ " + "\(caption?.priceCaption ?? "")"
        priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
        priceLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
//        view.addSubview(priceValueLabel)
//        priceValueLabel.text = caption?.priceCaption
//        priceValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        priceValueLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 25).isActive = true
//        priceValueLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
//        priceValueLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        view.addSubview(descriptionLabel)
        //titleValueLabel.text=caption?.titleCaption
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(descriptionValueLabel)
        descriptionValueLabel.text=caption?.descriptionCaption
        descriptionValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionValueLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        descriptionValueLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        descriptionValueLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    @objc func handleDismiss() {
        let homeController = CustomTabBarController()
        present(homeController, animated: true, completion: nil)
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCancel))
        
                //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    @objc func handleCancel() {
        let homeController = CustomTabBarController()
        present(homeController, animated: true, completion: nil)
    }
    

    fileprivate func setupView() {
        photoImageView.loadImage(urlString: imageUrl)
        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop:65 , paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width, height: self.view.frame.width)
    }
    
    /*
     fileprivate func setupAttributedCaption() {
     guard let post = self.post else { return }
     
     let attributedText = NSMutableAttributedString(string: post.titleCaption, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
     attributedText.append(NSAttributedString(string: " \(post.priceCaption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
     
     attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
     
     
     let timeAgoDisplay = post.creationDate.timeAgoDisplay()
     attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
     captionLabel.attributedText = attributedText
     }
     */
    
    let lable: UILabel = {
        let lbl = UILabel()
        
        return lbl
    }()
    
    
}
