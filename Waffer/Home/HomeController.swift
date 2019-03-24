//
//  ViewController.swift
//  Waffer
//
//  Created by Batool Alsmael on 10/10/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, CLLocationManagerDelegate, HomePostCellDelegate, FillterDelegate {
    
    
    var locationManager = CLLocationManager()
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()

        }
        
        CurrentLocation.userCurrentLocation(completion: { (location) in
            print("location=",location)
            CurrentLocation.getUserGeoLocation(location, completion: { (city) in
                print("City=",city)
            })
        })
        

        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: AdPostingViewController.notificationNameForUpdateFeed, object: nil)
        
        collectionView?.backgroundColor = .white
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshController
        setupTopNavigationBarItems()
        
        fetchAllPost()
        
        collectionView?.alwaysBounceVertical = true
        
        // user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
//            self.tabBarController!.tabBar.isHidden =  true
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    @objc func handleUpdateFeed(){
        handleRefresh()
    }
    
    @objc func handleRefresh(){
//        print("Handling refresh...")
        posts.removeAll()
        fetchAllPost()
    }
    
    fileprivate func fetchAllPost(){
        fetchPosts()
    }
    
    var filteredPost = [Post]()
    var posts = [Post]()
    fileprivate func fetchPosts() {
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            //            print("dictionaries=", dictionaries)
            dictionaries.forEach({ (key, value) in
                
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
            
        }) { (err) in
            print("Faild to fatch posts:", err)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func fetchPostsWithUser(user: User){
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in

                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key

                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("bookmarks").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.bookmark = true
                    } else {
                        post.bookmark = false
                    }
                    CurrentLocation.userCurrentLocation(completion: { (location) in
                        CurrentLocation.getUserGeoLocation(location, completion: { (city) in
                            if (city == post.city) {
                                
                                self.posts.append(post)
                                self.posts.sort(by: { (p1, p2) -> Bool in
                                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                                })
                                self.filteredPost = self.posts
                                self.collectionView?.reloadData()
                            }
                        })
                    })

                }, withCancel: { (error) in
                    print("Failed to fetch bookmark info for post:", error)
                })
            })
       
        }) { (err) in
            print("Faild to fatch posts:", err)
        }
    }
    
    func setupTopNavigationBarItems() {
        
        //        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        //        navigationItem.leftBarButtonItem = logoutBarButton
        
        setupLogOutButton()
        
        //let filterButton = UIButton(type: .system)
        //searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 270, height: 20))
        
        //filterButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        
        navigationController?.navigationBar.addSubview(searchBar)
        
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 45, paddingBottom: 0, paddingRight: 50, width: 0, height: 0)
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: filterButton)]
        
    }
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "_filter") as UIImage?
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleFilterButton), for: .touchUpInside)
        return button
    }()
    
    let categoryFilter = CategoryFilter()
    @objc func handleFilterButton(){
        categoryFilter.delegate = self
        categoryFilter.showFilter()
    }
    
    func didTapFillterByItem(name : String) {
        if (name != "Clear Filter") {
            filteredPost = self.posts.filter { (post) -> Bool in
                return post.categoryCaption.lowercased().contains(name.lowercased())
            }
        } else {
            self.filteredPost = self.posts
        }
        self.collectionView?.reloadData()
    }
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter Item name"
        //sb.barTintColor = .gray
        //UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.init(red: 230, green: 230, blue: 230, alpha: 0)//(r: 230, g: 230, b: 230)
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            filteredPost = posts
        } else {
            filteredPost = self.posts.filter { (post) -> Bool in
                return post.titleCaption.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView?.reloadData()
    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
                //what happens? we need to present some kind of login controller
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
                
            } catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8 //username + userprofileimage
        height += view.frame.width
        height += 50
        height += 40
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPost.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = filteredPost[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func didTapContact(_ post: Post) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = post.user
        searchBar.isHidden = true
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func didBookmark(for cell: HomePostCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        
        var post = self.posts[indexPath.item]
        
        guard let postId = post.id else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values = [String: Any]()
        
        if (post.bookmark == true) {
            values = [uid: 0]
        } else {
            values = [uid: 1]
        }
        print(values)
        Database.database().reference().child("bookmarks").child(postId).updateChildValues(values) { (err, _) in
            
            if let err = err {
                print("Failed to bookmark post:", err)
                return
            }
            
            print("Successfully bookmark post.")
            
            post.bookmark = !post.bookmark
            
            self.posts[indexPath.item] = post
            self.filteredPost = self.posts
            self.collectionView?.reloadItems(at: [indexPath])
//            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        edgesForExtendedLayout = UIRectEdge.bottom
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let presentAdController = PresentAdsController()
        presentAdController.imageUrl = filteredPost[indexPath.row].imageUrl
        presentAdController.caption = filteredPost[indexPath.row]
        searchBar.isHidden = true
        navigationController?.pushViewController(presentAdController, animated: true)

    }
}

