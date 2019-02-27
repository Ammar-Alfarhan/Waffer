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

//protocol EditPostDelegate {
//    
//    func moveToAdPosting(caption: Post)
//    
//}
class PresentAdsController: UIViewController, PostDelegate {
    
    
    
    var caption: Post?
    
    var imageUrl = ""
    
    var postId = ""
    
    
    var myView: UIView!
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        
//        print("caption", caption ?? "default value")
        
        //print("caption=", caption?.user.uid ?? "default value")
        
        setupView()
        setupNavigationButtons()
        setupDescriptionItems()
        
        //setupDropDownBtn()
        
    }
        
//    let dismissButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "cancel_shadow"), for: .normal)
//        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
//        return button
//    }()
    
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
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCancel))
        
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
//        print("caption", caption ?? "default value")
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
//        print("caption", caption ?? "default value")
        print("Moved to view controller")
        guard let uid = caption?.user.uid else { return }
        guard let postId = caption?.id else { return }
//        print("uid ",uid)
//        print("postId ",postId)
        
        let ref = Database.database().reference().child("posts").child(uid).child(postId)
        ref.removeValue { (err, ref) in
            if let err = err {
                print("Failed to access post into db:", err)
                return
            }
            
            print(ref)
            
        }

        let homeController = CustomTabBarController()
        present(homeController, animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)

    }
    
    

    
    func didTapEdit() {
    
//        guard let uid = caption?.user.uid else { return }
//        guard let postId = caption?.id else { return }
//        let ref = Database.database().reference().child("posts").child(uid).child(postId)
//        ref.removeValue { (err, ref) in
//            if let err = err {
//                print("Failed to access post into db:", err)
//                return
//            }
//
//            print(ref)
//
//        }
        
        let AdPostingController = AdPostingViewController()
        AdPostingController.post = caption
        AdPostingController.didTapEdit =  true
        let ad = UINavigationController(rootViewController: AdPostingController)
        present(ad, animated: true, completion: nil)
        
    }
    
    
}
////////////////////////////////////////
//protocol dropDownProtocol {
//    func dropDownPressed(string : String)
//}
//
//class dropDownBtn: UIButton, dropDownProtocol {
//
//    func dropDownPressed(string: String) {
//        self.setTitle(string, for: .normal)
//        self.dismissDropDown()
//    }
//    var dropView = dropDownView()
//
//    var height = NSLayoutConstraint()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        self.backgroundColor = UIColor.darkGray
//
//        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
//        dropView.delegate = self
//        dropView.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    override func didMoveToSuperview() {
//        self.superview?.addSubview(dropView)
//        self.superview?.bringSubviewToFront(dropView)
//        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        height = dropView.heightAnchor.constraint(equalToConstant: 0)
//    }
//
//    var isOpen = false
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if isOpen == false {
//
//            isOpen = true
//
//            NSLayoutConstraint.deactivate([self.height])
//
//            if self.dropView.tableView.contentSize.height > 150 {
//                self.height.constant = 150
//            } else {
//                self.height.constant = self.dropView.tableView.contentSize.height
//            }
//
//
//            NSLayoutConstraint.activate([self.height])
//
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
//                self.dropView.layoutIfNeeded()
//                self.dropView.center.y += self.dropView.frame.height / 2
//            }, completion: nil)
//
//        } else {
//            isOpen = false
//
//            NSLayoutConstraint.deactivate([self.height])
//            self.height.constant = 0
//            NSLayoutConstraint.activate([self.height])
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
//                self.dropView.center.y -= self.dropView.frame.height / 2
//                self.dropView.layoutIfNeeded()
//            }, completion: nil)
//
//        }
//    }
//
//    func dismissDropDown() {
//        isOpen = false
//        NSLayoutConstraint.deactivate([self.height])
//        self.height.constant = 0
//        NSLayoutConstraint.activate([self.height])
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
//            self.dropView.center.y -= self.dropView.frame.height / 2
//            self.dropView.layoutIfNeeded()
//        }, completion: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
//
//    var dropDownOptions = [String]()
//
//    var tableView = UITableView()
//
//    var delegate : dropDownProtocol!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        tableView.backgroundColor = UIColor.darkGray
//        self.backgroundColor = UIColor.darkGray
//
//
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        self.addSubview(tableView)
//
//        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dropDownOptions.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//
//        cell.textLabel?.text = dropDownOptions[indexPath.row]
//        cell.backgroundColor = UIColor.darkGray
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
//        self.tableView.deselectRow(at: indexPath, animated: true)
//}
//}
