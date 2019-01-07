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
        
//        if Auth.auth().currentUser == nil {
//            //show if not logged in
//            DispatchQueue.main.async {
//                let loginController = LoginController()
//                let navController = UINavigationController(rootViewController: loginController)
//                self.present(navController, animated: true, completion: nil)
//            }
//
//            return
//        }
//        
//        let userProfileLayout = UICollectionViewFlowLayout()
//        let userProfileController = UserProfileController(collectionViewLayout: userProfileLayout)
//        let thirdNavigationController = UINavigationController(rootViewController: userProfileController)
//        //thirdNavigationController.title = "User Profile"
//        thirdNavigationController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
//        thirdNavigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
//        
//        let homeLayout = UICollectionViewFlowLayout()
//        let homeController = HomeController(collectionViewLayout: homeLayout)
//        let navigationController = UINavigationController(rootViewController: homeController)
//        navigationController.title = "Home"
//        navigationController.tabBarItem.image = UIImage(named: "home")
//        
//        let cameraController = CameraTabView()
//        let secondNavigationController = UINavigationController(rootViewController: cameraController)
//        secondNavigationController.title = "Camera"
//        secondNavigationController.tabBarItem.image = UIImage(named: "camera")
//        
//        tabBar.tintColor = .black
//        
//        viewControllers = [navigationController, secondNavigationController, thirdNavigationController]
//        
       setupViewControllers()
    }
    
    
    func setupViewControllers(){
        
        let userProfileLayout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: userProfileLayout)
        let thirdNavigationController = UINavigationController(rootViewController: userProfileController)
        thirdNavigationController.title = "User Profile"
        thirdNavigationController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        thirdNavigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        let homeLayout = UICollectionViewFlowLayout()
        let homeController = HomeController(collectionViewLayout: homeLayout)
        let navigationController = UINavigationController(rootViewController: homeController)
        navigationController.title = "Home"
        navigationController.tabBarItem.image = UIImage(named: "home")
        
        let cameraController = CameraTabView()
        let secondNavigationController = UINavigationController(rootViewController: cameraController)
        secondNavigationController.title = "Camera"
        secondNavigationController.tabBarItem.image = UIImage(named: "camera")
    
        tabBar.tintColor = .black
        
         viewControllers = [navigationController, secondNavigationController, thirdNavigationController]
    }
}
