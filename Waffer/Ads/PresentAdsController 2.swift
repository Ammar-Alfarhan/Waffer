//
//  PresentAds.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 11/24/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class PresentAdsController: UIViewController, PostDelegate {
    
    var caption: Post?
    
    var imageUrl = ""
    
    var postId = ""
    
    var myView: UIView!
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        setupView()
        setupNavigationButtons()
        setupDescriptionItems()
    }
    
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
    
    @objc func handleDismiss() {
        let homeController = CustomTabBarController()
        present(homeController, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        
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
        guard let uid = caption?.user.uid else { return }
        guard let postId = caption?.id else { return }
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete the post?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            let ref = Database.database().reference().child("posts").child(uid).child(postId)
            ref.removeValue { (err, ref) in
                if let err = err {
                    print("Failed to access post into db:", err)
                    return
                }
            }
            let homeController = CustomTabBarController()
            self.present(homeController, animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func didTapSold() {
        guard let uid = caption?.user.uid else { return }
        guard let postId = caption?.id else { return }
        guard let sold = caption?.sold else { return }
        var values = [String: Any]()
        
        if (sold == true) {
            values = [uid: 0]
        } else {
            values = [uid: 1]
        }
        Database.database().reference().child("solds").child(postId).updateChildValues(values) { (err, _) in
            
            if let err = err {
                print("Failed to mark as sold:", err)
                return
            }
            print("Successfully mark as sold post.")
        }
    }
    
    func didTapEdit() {
        let AdPostingController = AdPostingViewController()
        AdPostingController.post = caption
        AdPostingController.didTapEdit =  true
        let ad = UINavigationController(rootViewController: AdPostingController)
        present(ad, animated: true, completion: nil)
        
    }
}
