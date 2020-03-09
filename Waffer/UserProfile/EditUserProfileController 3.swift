//
//  EditUserProfileController.swift
//  Waffer
//
//  Created by Batool Alsmael on 2/27/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class EditUserProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user : User? {
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
            
            usernameTextField.text = user?.username
            emailTextField.text = "123456"
            passwordTextField.text = "123456"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit User Profile"
        view.backgroundColor =  UIColor(r: 217,g: 217,b: 217)
        //profileImageView.loadImage(urlString: user?.profileImageUrl ?? "default value")
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;

        view.addSubview(inputContainerView)
        view.addSubview(changePhotoButton)
        view.addSubview(editButton)
        view.addSubview(profileImageView)
        setupInputContainerView()
        setupChangePhotoButton()
        setupEditButton()
        setupProfileImageView()
    }
    

    
    let profileImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "plus_photo-1")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true

        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    let inputContainerView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    func setupInputContainerView()
    {
        // need x, y, width, height constraints
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 200) .isActive = true
        
        // nameLabel
        inputContainerView.addSubview(usernameLabel)
        inputContainerView.addSubview(usernameTextField)
        //usernameTextField.text = user?.username
        inputContainerView.addSubview(usernameSeparatorView)
        inputContainerView.addSubview(emailLabel)
        inputContainerView.addSubview(emailTextField)
        //emailTextField.text = user?.email
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordLabel)
        inputContainerView.addSubview(passwordTextField)
        //passwordTextField.text = user?.email
        
        //need x, y, width, height constraints
        usernameLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        
        usernameLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //need x, y, width, height constraints
        usernameTextField.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor, constant: 90).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        
        usernameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        usernameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //need x, y, width, height constraints
        usernameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        usernameSeparatorView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        usernameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        usernameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        emailLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        
        emailLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailLabel.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: emailLabel.leftAnchor, constant: 90).isActive = true
        emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //need x, y, width, height constraints
        passwordLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passwordLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordLabel.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: passwordLabel.leftAnchor, constant: 150).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
    }
    

    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func setupProfileImageView()
    {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: changePhotoButton.topAnchor, constant: -5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        profileImageView.layer.cornerRadius = 130 / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = editedImage
            //plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = originalImage
            //plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 1


        dismiss(animated: true, completion: nil)
    }
    
    let changePhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.setTitleColor(UIColor(r: 0,g: 45,b: 179), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font=UIFont.boldSystemFont(ofSize: 16)

       button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    func setupChangePhotoButton()
    {
        // need x, y, width, height constraints
        changePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        changePhotoButton.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant : 2).isActive=true
        changePhotoButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        changePhotoButton.heightAnchor.constraint(equalToConstant: 25).isActive=true
    }
    
    
    let usernameLabel : UILabel = {
        let l = UILabel()
        l.text="Username:"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let usernameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder="Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let usernameSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220,g: 220,b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    let emailLabel : UILabel = {
        let l = UILabel()
        l.text="Password:"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder="Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let emailSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220,g: 220,b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    let passwordLabel : UILabel = {
        let l = UILabel()
        l.text="Confirm Password:"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder="Confirm Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    lazy var editButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 135,g: 0,b: 0)
        button.setTitle("Update", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font=UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
         
        return button
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @objc func handleUpdate() {
        
        if( self.emailTextField.text != self.passwordTextField.text)
        {
            let alertController = UIAlertController(title: "Password fields must match", message: nil, preferredStyle: .actionSheet)
            
            
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            
            guard let image = self.profileImageView.image else { return }
            
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
                
                // Firebase 5 Update: Must now retrieve downloadURL
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    guard let profileImageUrl = downloadURL?.absoluteString else { return }
                    
                    print("Successfully uploaded profile image:", profileImageUrl)
                    
                    let uid = self.user?.uid
                    
                    let dictionaryValues = ["name": self.usernameTextField.text ?? "default value", "profileImageUrl": profileImageUrl] as [String : Any]
                    let values = [uid: dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if let err = err {
                            print("Failed to save user info into db:", err)
                            return
                        }
                        
                        print("Successfully saved user info to db")
                        
                        
                        let homeController = CustomTabBarController()
                        self.present(homeController, animated: true, completion: nil)

                        
                        
                    })
                })
            })
        }
    }
    
    func setupEditButton()
    {
        // need x, y, width, height constraints
        editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        editButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant : 12).isActive=true
        editButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive=true
        editButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
    }
}


