//
//  PresentAdsControllerForUserProfile.swift
//  Waffer
//
//  Created by Batool Alsmael on 1/15/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class PresentAdsControllerForUserProfile: UIViewController, DeletePostDelegate {
    
    
    
    
    var caption: Post?
    
    var imageUrl = ""
    
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        
        
        //print("caption=", caption?.user.uid ?? "default value")
        
        setupView()
        setupNavigationButtons()
        setupDescriptionItems()
        //setupDropDownBtn()
        
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
    
    let categoryLabel : UILabel = {
        let l = UILabel()
        l.text = "  Category: "
        l.font =  UIFont.boldSystemFont(ofSize: 16.0)
        l.textColor = UIColor(red: 135/255, green: 0/255, blue: 0/255, alpha: 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
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
    
    func setupDescriptionItems(){
        view.addSubview(titleLabel)
        titleLabel.text = "Title : " + "\(caption?.titleCaption ?? "")"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(categoryLabel)
        categoryLabel.text = "Category : " + "\(caption?.categoryCaption ?? "")"
        categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        categoryLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        view.addSubview(priceLabel)
        priceLabel.text = "Price : $ " + "\(caption?.priceCaption ?? "")"
        priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
        priceLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(descriptionLabel)
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
    
    //    func setupDropDownBtn()
    //    {
    //        button = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    //        button.setTitle("Colors", for: .normal)
    //        button.setImage(#imageLiteral(resourceName: "Dot-More-Vertical-Menu").withRenderingMode(.alwaysOriginal), for: .normal)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //
    //        //Add Button to the View Controller
    //        self.view.addSubview(button)
    //
    //        //button Constraints
    //        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    //        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    //        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
    //        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    //
    //        //Set the drop down menu's options
    //        button.dropView.dropDownOptions = ["Blue", "Green", "Magenta", "White", "Black", "Pink"]
    //    }
    
    @objc func handleDismiss() {
        let homeController = CustomTabBarController()
        present(homeController, animated: true, completion: nil)
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCancel))
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if (caption?.user.uid == uid)
        {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Dot-More-Vertical-Menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(verticalMenu))
        }
    }
    
    
    
    @objc func handleCancel() {
        let homeController = CustomTabBarController()
        present(homeController, animated: true, completion: nil)
    }
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    
    let verticalMenuLauncher = VerticalMenuLauncher()
    @objc func verticalMenu() {
        verticalMenuLauncher.post = caption
        verticalMenuLauncher.delegate = self
        verticalMenuLauncher.showSettings()
    }
    
    
    
    
    
    fileprivate func setupView() {
        photoImageView.loadImage(urlString: imageUrl)
        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop:65 , paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width, height: self.view.frame.width)
    }
    
    let lable: UILabel = {
        let lbl = UILabel()
        
        return lbl
    }()
    
    
    func didTapDelete() {
        print("Moved to view controller")
        //        let userProfileLayout = UICollectionViewFlowLayout()
        //        let userProfileController = UserProfileController(collectionViewLayout: userProfileLayout)
        //        let thirdNavigationController = UINavigationController(rootViewController: userProfileController)
        //        //navigationController.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
        //        present(thirdNavigationController, animated: true, completion: nil)
        let homeController = CustomTabBarController()
        present(homeController, animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
        
    }
    
    
}
