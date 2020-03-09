//
//  UserProfileController.swift
//  Waffer
//
//  Created by Batool Alsmael on 10/27/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class UserProfileController: UICollectionViewController,  UICollectionViewDelegateFlowLayout, UserProfileCellDelegate {
    
    var isSold = false
    var isForSale = true
    var isBookmark = false
    
    func didTapSold() {
        isSold = true
        isForSale = false
        isBookmark = false
        handleSwitching()
    }
    
    func didTapBookmark() {
        isSold = false
        isForSale = false
        isBookmark = true
        handleSwitching()
    }
    
    func didTapForSale() {
        isSold = false
        isForSale = true
        isBookmark = false
        handleSwitching()
    }
    
    func didTapEdit() {
        let editController =  EditUserProfileController()
        editController.user = self.user
        navigationController?.pushViewController(editController, animated: true)
    }
    let cellId = "cellId"
    
    let headerId = "headerId"
   
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        setupLogOutButton()
    }
    
    func handleSwitching(){
        posts.removeAll()
        sold.removeAll()
        paginatePosts()
        collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    var isFinishedPaging = false
    var posts = [Post]()
    var sold = [Post]()
    fileprivate func paginatePosts() {
        
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        var query = ref.queryOrdered(byChild: "creationDate")
        
        if posts.count > 0 {
            let value = posts.last?.creationDate.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.reverse()
            
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.posts.count > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
            }
            
            guard let user = self.user else { return }
            
            allObjects.forEach({ (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("solds").child(snapshot.key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.sold = true
                        self.sold.append(post)
                        self.collectionView?.reloadData()
                    } else {
                        post.sold = false
                        self.posts.append(post)
                        self.collectionView?.reloadData()
                    }
                    //reloading data here doublecate
                }) { (err) in
                    print("Faild to fetch sold items", err)
                }
            })
        }) { (err) in
            print("Failed to paginate for posts:", err)
        }
    }
    var bookmarks = [Post]()
    fileprivate func fetchPosts() {
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
            
        }) { (err) in
            print("Faild to fatch posts:", err)
        }
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
                        self.bookmarks.append(post)
                        self.bookmarks.sort(by: { (p1, p2) -> Bool in
                            return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                        })
                        self.collectionView?.reloadData()
                    }
                }, withCancel: { (error) in
                    print("Failed to fetch bookmark info for post:", error)
                })
            })
            
        }) { (err) in
            print("Faild to fatch posts:", err)
        }
    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isBookmark){
            return bookmarks.count
        } else if (isSold) {
            return sold.count
        } else {
            return posts.count
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
//            paginatePosts()
        }
        
        if (isBookmark) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = bookmarks[indexPath.item]
            return cell
        } else if (isSold) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            let post = sold[indexPath.item]
            cell.post = post
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        }
       
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let presentAdController = PresentAdsController()
        if (isBookmark) {
            presentAdController.imageUrl = bookmarks[indexPath.row].imageUrl
            presentAdController.caption = bookmarks[indexPath.row]
            navigationController?.pushViewController(presentAdController, animated: true)
        } else if (isSold) {
            presentAdController.imageUrl = sold[indexPath.row].imageUrl
            presentAdController.caption = sold[indexPath.row]
            navigationController?.pushViewController(presentAdController, animated: true)
        } else {
            presentAdController.imageUrl = posts[indexPath.row].imageUrl
            presentAdController.caption = posts[indexPath.row]
            navigationController?.pushViewController(presentAdController, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader

        header.user = self.user
        header.delegate = self
        if (isBookmark) {
            header.numberOfPosts = self.bookmarks.count
        } else if (isSold) {
            header.numberOfPosts = self.sold.count
        } else {
            header.numberOfPosts = self.posts.count
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

    var user: User?
    fileprivate func fetchUser() {
        
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
            self.paginatePosts()
            self.fetchPosts()
        }
    }
 
}
