//
//  CustomTabBarController.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 10/23/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//


import UIKit
import Firebase

class CustomTabBarController: UITabBarController{
    override func viewDidLoad() {
        
        self.tabBarController?.tabBar.isHidden = false
       setupViewControllers()
    }
    
    func setupViewControllers(){
        
        let userProfileLayout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: userProfileLayout)
        let userProfile = UINavigationController(rootViewController: userProfileController)
        userProfile.title = "User Profile"
        userProfile.tabBarItem.image = #imageLiteral(resourceName: "userprofile-unselected")
        userProfile.tabBarItem.selectedImage = #imageLiteral(resourceName: "userprofile-selected")
        
        let messageController = MessagesController()
        let messages = UINavigationController(rootViewController: messageController)
        messages.title = "Messages"
        messages.tabBarItem.image = #imageLiteral(resourceName: "messages")
        messages.tabBarItem.selectedImage = #imageLiteral(resourceName: "tabbedmessages")
        
        
        let homeLayout = UICollectionViewFlowLayout()
        let homeController = HomeController(collectionViewLayout: homeLayout)
        let home = UINavigationController(rootViewController: homeController)
        home.title = "Home"
        home.tabBarItem.image = #imageLiteral(resourceName: "home")
        
        let cameraController = CameraTabView()

        let camera = UINavigationController(rootViewController: cameraController)
        camera.title = "Camera"
        camera.tabBarItem.image = #imageLiteral(resourceName: "camera")
    
        tabBar.tintColor = .black
        
         viewControllers = [home, camera, messages, userProfile]
    }

}
