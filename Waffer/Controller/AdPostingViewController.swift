//
//  AdPostingViewController.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 10/24/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class AdPostingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
   
    var post: Post?
    var didTapEdit = false
    var categorySelected = Int()
    var postIndex = 0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationButtons()
        
        
        picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
        picker.delegate = self
        picker.dataSource = self
        
        // adsImageView.image = postedImage
        view.backgroundColor = .white
        view.addSubview(inputContainerView)
        setupInputContainerView()
        setupDescriptionItems()
        
        setupPageForEdit()
        
       
        if (postIndex != -1)
        {
            picker.selectRow(postIndex, inComponent: 0, animated: true)
        }
        
        
    }
    
    fileprivate func setupPageForEdit(){
        
        if(didTapEdit == true)
        {
            titleTextField.text = post?.titleCaption
            textView.text = post?.descriptionCaption
            priceTextField.text = post?.priceCaption
            let index = category.index(of: post?.categoryCaption ?? "")
            postIndex = index ?? -1
            categorySelected = postIndex 
        }
        else
        {
            titleTextField.placeholder="Title"
            priceTextField.placeholder="Price"
        }
        
//        if (post?.titleCaption != "")
//        {
//          titleTextField.text = post?.titleCaption
//        }
//        else {titleTextField.placeholder="Title"}
//
//        if (post?.descriptionCaption != "")
//        {
//            textView.text = post?.descriptionCaption
//        }
//
//        if (post?.priceCaption != "")
//        {
//            priceTextField.text = post?.priceCaption
//        }
//        else {priceTextField.placeholder="Price"}
//
//        if (post?.categoryCaption != "")
//        {
//            //let filtered = category.filter { $0 == post?.categoryCaption  }
//
//            //print("filtered",filtered)
//        }
        
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
    }
    
    @objc func handleCancel() {
        let homeController = CustomTabBarController()
        present(homeController, animated: true, completion: nil)
    }
    
    let descriptionLabel : UILabel = {
        let l = UILabel()
        l.text = "Enter Item Description: "
        l.font =  UIFont.boldSystemFont(ofSize: 16)
        l.textColor = UIColor(red: 135/255, green: 0/255, blue: 0/255, alpha: 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let titleTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let textView : UITextView =
    {
        let txt = UITextView()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.03)
        txt.textAlignment = NSTextAlignment.justified
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        txt.layer.borderWidth = 1
        txt.layer.cornerRadius = 5
        txt.font =  UIFont.systemFont(ofSize: 15)
        txt.layer.masksToBounds = true
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    
    
    let priceTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 5
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("POST", for: .normal)
        button.backgroundColor = UIColor(red: 135/255, green: 0/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 10
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
        inputContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 500)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(picker)
        inputContainerView.addSubview(titleTextField)
        inputContainerView.addSubview(textView)
        inputContainerView.addSubview(priceTextField)
        inputContainerView.addSubview(descriptionLabel)
        inputContainerView.addSubview(postButton)
        
    }
    
    
    func setupDescriptionItems()
    {
        
        // need x, y, width, height constraints
        titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleTextField.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 25).isActive = true
        titleTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // need x, y, width, height constraints
        priceTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        priceTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant : 10).isActive=true
        priceTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        priceTextField.heightAnchor.constraint(equalToConstant: 40).isActive=true
        
        // need x, y, width, height constraints
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        descriptionLabel.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant : 10).isActive=true
        descriptionLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        // need x, y, width, height constraints
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        textView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant : 5).isActive=true
        textView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        textView.heightAnchor.constraint(equalToConstant: 120).isActive=true
        
        // need x, y, width, height constraints
        postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        postButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant : 45).isActive=true
        postButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handlePost() {
        print("handling post..")
        print ("postedImage ",postedImage)
        print ("post ",post ?? "default value")
        
        if(didTapEdit == true)
        {
            self.saveToDatabaseWithImageUrl(imageUrl: post?.imageUrl ?? "default value")
        }
        else
        {
            let image = postedImage
            guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
            
            // navigationItem.rightBarButtonItem?.isEnabled = false
            
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("posts").child(filename)
            storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
                
                if let err = err {
                    // self.navigationIem.rightBarButtonItem?.isEnabled = true
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
////        if (postIndex != -1)
////        {
////            let image = post?.imageUrl
////        }
////        else {
//        let imageq = post?.imageUrl
//        //imageq?.isEmpty
        //print("imageq?.isEmpty", post?.imageUrl.isEmpty ?? "")
////        if(postedImage.images == )
       // if((post?.imageUrl.isEmpty)!)
        
        //{
        
        //}
//        else {
//            print("!(post?.imageUrl.isEmpty)")
//            self.saveToDatabaseWithImageUrl(imageUrl: post?.imageUrl ?? "")
//        }
        
    }
    
    static let notificationNameForUpdateFeed = NSNotification.Name(rawValue: "UpdateFeed")
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        // guard let postImage = selectedImage else { return }
//        if let data = try? Data(contentsOf: post?.imageUrl)
//        {
//            let image: UIImage = UIImage(data: data)
//        }
        let postImage = postedImage
        guard let descriptionCaption = textView.text else { return }
        guard let titleCaption = titleTextField.text else { return }
        guard let priceCaption = priceTextField.text else { return }
        let categoryCaption = category[categorySelected]
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if(didTapEdit == true)
        {
            print("didTapEdit == true Hi this is Batool")
            print ("post id: ", post?.id ?? "default value")
            print ("post catogory: ", categoryCaption)
  
            let userPostRef = Database.database().reference().child("posts").child(uid)
            let ref = userPostRef.child(post?.id ?? "default value")
            
            let values = ["imageUrl": imageUrl, "descriptionCaption": descriptionCaption, "titleCaption": titleCaption, "priceCaption": priceCaption, "categoryCaption": categoryCaption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
            print("values",values)
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }
                
                print("Successfully saved post to DB")
                
                NotificationCenter.default.post(name: AdPostingViewController.notificationNameForUpdateFeed, object: nil)
                
                let homeController = CustomTabBarController()
                self.present(homeController, animated: true, completion: nil)
            }
            
        }
        else
        {
            let userPostRef = Database.database().reference().child("posts").child(uid)
            let ref = userPostRef.childByAutoId()
            
            let values = ["imageUrl": imageUrl, "descriptionCaption": descriptionCaption, "titleCaption": titleCaption, "priceCaption": priceCaption, "categoryCaption": categoryCaption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
            
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }
                
                print("Successfully saved post to DB")
                
                NotificationCenter.default.post(name: AdPostingViewController.notificationNameForUpdateFeed, object: nil)
                
                let homeController = CustomTabBarController()
                self.present(homeController, animated: true, completion: nil)
            }
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}


