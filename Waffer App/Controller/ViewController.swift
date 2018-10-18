//
//  ViewController.swift
//  Waffer App
//
//  Created by Batool Alsmael on 10/10/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem=UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout()
    {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .lightContent
    }

}

