//
//  CameraTabView.swift
//  Waffer
//
//  Created by Batool Alsmael on 10/30/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//
import UIKit
import Firebase
class CameraTabView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraController = CameraViewController()
        present(cameraController, animated: true, completion: nil)
    }
}

