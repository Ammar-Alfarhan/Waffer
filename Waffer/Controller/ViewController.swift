//
//  ViewController.swift
//  Waffer
//
//  Created by Batool Alsmael on 10/10/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        
        
        // user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            handleLogout()
        }
    }
    
    
    
    func setupNavigationBarItems() {
        
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = logoutBarButton
        
        let searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 270, height: 20))
        let filterButton = UIButton(type: .system)
        let image = UIImage(named: "_filter") as UIImage?
        filterButton.setImage(image, for: .normal)
        filterButton.contentMode = .scaleAspectFit
        filterButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: filterButton), UIBarButtonItem(customView: searchBar)]
        
    }
    
    @objc func handleLogout()
    {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    
    
}

