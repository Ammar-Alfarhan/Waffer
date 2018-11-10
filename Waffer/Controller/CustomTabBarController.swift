//
//  CustomTabBarController.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 10/23/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController{
    override func viewDidLoad() {
        let navigationController = UINavigationController(rootViewController: ViewController())
        navigationController.title = "Home"
        navigationController.tabBarItem.image = UIImage(named: "home")
        
        let cameraController = CameraTabView()
        let secondNavigationController = UINavigationController(rootViewController: cameraController)
        secondNavigationController.title = "Camera"
        secondNavigationController.tabBarItem.image = UIImage(named: "camera")
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let thirdNavigationController = UINavigationController(rootViewController: userProfileController)
        
//        let adPost = AdPostingViewController()
//        let adPostController = UINavigationController(rootViewController: adPost)
//        adPostController.title = "Post"
        
        thirdNavigationController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        thirdNavigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navigationController, secondNavigationController, thirdNavigationController]
        
    }
    
    
}
