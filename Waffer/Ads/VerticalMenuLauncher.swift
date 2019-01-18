//
//  SettingsLauncher.swift
//  Waffer
//
//  Created by Batool Alsmael on 1/8/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
protocol DeletePostDelegate {
    func didTapDelete()
}
class VerticalMenuItem: NSObject {
    let name: String
    
    
    init(name: String) {
        self.name = name
        
    }
}

class VerticalMenuLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var post: Post?
    let blackView = UIView()
    
    var delegate : DeletePostDelegate?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    let verticalMenuItems: [VerticalMenuItem] = {
        return [VerticalMenuItem(name: "Edit Post"), VerticalMenuItem(name: "Delete Post"), VerticalMenuItem(name: "Cancel")]
    }()

    func showSettings() {
        //show menu
        
        if let window = UIApplication.shared.keyWindow {
            
            //blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            //blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            //window.addSubview(blackView)
            
            window.addSubview(collectionView)
            
            
            
            let height: CGFloat = CGFloat(verticalMenuItems.count) * cellHeight
            //let y = window.frame.height - height
            let width = window.frame.width/3
            let yheight = window.frame.height / 4
            let y = yheight / 2.4
            let x = width * 2
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                //self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: x, y: y, width: width, height: self.collectionView.frame.height)
                
            }, completion: nil)
        }
    }
    
    
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    
    
    
    
    
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print(verticalMenuItems[indexPath.item].name)
        
        print ("delegate",delegate ?? "nil")
        if (verticalMenuItems[indexPath.item].name == "Edit Post")
        {
            print("edit edit")
        }
        if (verticalMenuItems[indexPath.item].name == "Delete Post")
        {

            
//            DispatchQueue.main.async(execute: {
////                guard let uid = self.post?.user.uid else { return }
////                guard let postId = self.post?.id else { return }
////                
////                            let ref = Database.database().reference().child("posts").child(uid).child(postId)
////                            ref.removeValue { (err, ref) in
////                                if let err = err {
////                                    print("Failed to access post into db:", err)
////                                    return
////                                }
////            
////                           }
//            })
            print("inside delete")
            
           // print (delegate)
            self.delegate?.didTapDelete()
            //ref.removeValue(postId)
            
            
            
           // print("delete\(post?.titleCaption ?? "")")
           
            
        }
        if ( (verticalMenuItems.count-1) == (indexPath.item))
        {
            handleDismiss()
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return verticalMenuItems.count
    }

  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VerticalMenuCell
        
        let verticalMenuItem = verticalMenuItems[indexPath.item]
        cell.verticalMenuItem = verticalMenuItem
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(VerticalMenuCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
