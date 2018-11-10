//
//  AdPostingViewController.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 10/24/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase

class AdPostingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
//    var selectedImage: UIImage? {
//        didSet {
//            self.adsImageView.image = postedImage
//        }
//    }
    
    var categorySelected = Int()
    let category = ["Cars","Electronics","Baby and Child","Housing", "Home and Garden", "Movies, Books, and Music", "Services", "Other"]
    
    
    var  picker : UIPickerView!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return category[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorySelected = row
    }
    
    
    
    
    //picCategory: UIPickerView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupNavigationButtons()
        
        picker = UIPickerView()
        // set size
        picker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80)
        picker.delegate = self
        picker.dataSource = self
        
        
        
        view.backgroundColor = UIColor(red: 0/255, green: 38/255, blue: 77/255, alpha: 1)
        // view.addSubview(picker)
        view.addSubview(inputContainerView)
        setupInputContainerView()
        adsImageView.image = postedImage
        
        view.addSubview(adsImageView)
        view.addSubview(categoryLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(textView)
        view.addSubview(priceLabel)
        view.addSubview(priceTextField)
        view.addSubview(postButton)
        setupDescriptionItems()
        setupAdsImageView()
        
        
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    //    @objc func handleNext() {
    //        let sharePhotoController = SharePhotoController()
    //        sharePhotoController.selectedImage = header?.photoImageView.image
    //        navigationController?.pushViewController(sharePhotoController, animated: true)
    //    }
    
    @objc func handleCancel() {
        let homeController = CustomTabBarController()
        present(homeController, animated: true, completion: nil)
    }
    
    
    let adsImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plus_photo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let categoryLabel : UILabel = {
        let l = UILabel()
        l.text = "Category: "
        l.font =  UIFont.systemFont(ofSize: 15)
        l.textColor = UIColor.white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let descriptionLabel : UILabel = {
        let l = UILabel()
        l.text = "Description: "
        l.font =  UIFont.systemFont(ofSize: 15)
        l.textColor = UIColor.white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    let textView : UITextView =
    {
        let txt = UITextView()
        txt.backgroundColor = UIColor.white
        txt.textAlignment = NSTextAlignment.justified
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.layer.cornerRadius = 5
        txt.font =  UIFont.systemFont(ofSize: 15)
        txt.layer.masksToBounds = true
        
        return txt
    }()
    
    let priceLabel : UILabel = {
        let l = UILabel()
        l.text = "Price: "
        l.font =  UIFont.systemFont(ofSize: 15)
        l.textColor = UIColor.white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let priceTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder="        $$$"
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 5
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("POST", for: .normal)
        button.backgroundColor = UIColor(red: 135/255, green: 0/255, blue: 0/255, alpha: 1)
        
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        
        button.isEnabled = true
        
        return button
    }()
    
    let inputContainerView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    func setupInputContainerView()
    {
        // need x, y, width, height constraints
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 75)
        inputsContainerViewHeightAnchor?.isActive = true
        inputContainerView.addSubview(picker)
        
    }
    
    //    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    //    var descriptionLabelHeightAnchor: NSLayoutConstraint?
    //    var descriptionTextFieldHeightAnchor: NSLayoutConstraint?
    //    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    func setupAdsImageView()
    {
        //need x, y, width, height constraints
        //adsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        adsImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -2).isActive = true
        //        adsImageView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        //        adsImageView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        adsImageView.bottomAnchor.constraint(equalTo: categoryLabel.topAnchor, constant: -12).isActive = true
        adsImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        adsImageView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        //        adsImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: categoryLabel.topAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width:  inputContainerView, height: 0)
        
        
        
        //        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
    }
    func setupDescriptionItems()
    {
        
        
        categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        categoryLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // need x, y, width, height constraints
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        descriptionLabel.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant : 5).isActive=true
        descriptionLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 25).isActive=true
        
        
        // need x, y, width, height constraints
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        textView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant : 5).isActive=true
        textView.widthAnchor.constraint(equalTo: descriptionLabel.widthAnchor).isActive=true
        textView.heightAnchor.constraint(equalToConstant: 85).isActive=true
        
        // need x, y, width, height constraints
        priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        priceLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant : 5).isActive=true
        priceLabel.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive=true
        priceLabel.heightAnchor.constraint(equalToConstant: 25).isActive=true
        
        // need x, y, width, height constraints
        priceTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant : 5).isActive=true
        priceTextField.widthAnchor.constraint(equalTo: priceLabel.widthAnchor).isActive=true
        priceTextField.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        
        // need x, y, width, height constraints
        postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        postButton.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant : 10).isActive=true
        postButton.widthAnchor.constraint(equalTo: priceTextField.widthAnchor).isActive=true
        postButton.heightAnchor.constraint(equalToConstant: 40).isActive=true
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handlePost() {
        print("handling post..")
        
        let image = postedImage
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
       // navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in

            if let err = err {
               // self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image:", err)
                return
            }

            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to fetch downloadURL:", err)
                    return
                }
                guard let imageUrl = downloadURL?.absoluteString else { return }

                print("Successfully uploaded post image:", imageUrl)

                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            })
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
       // guard let postImage = selectedImage else { return }
        let postImage = postedImage
        guard let caption = textView.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            print("Successfully saved post to DB")
            let homeController = CustomTabBarController()
            self.present(homeController, animated: true, completion: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
