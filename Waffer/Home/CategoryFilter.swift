//
//  CategoryFilter.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 12/4/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: String
    //let imageName: String
    
    init(name: String) {
        self.name = name
        //self.imageName = imageName
    }
}

class CategoryFilter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    
    let settings: [Setting] = {
        return [Setting(name: "Cars"), Setting(name: "Electronics"), Setting(name: "Baby and Child"), Setting(name: "Housing"), Setting(name: "Movies, Books, and Music"), Setting(name: "Services"), Setting(name: "Home and Garden"), Setting(name: "Other")]
    }()
    
    let blackView = UIView()
    @objc func showFilter(){
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDissmis)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let hight: CGFloat = 300
            let y = window.frame.height - hight
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: hight)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)

        }
    }
    
    @objc func handleDissmis() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow{
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryFilterCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override init(){
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CategoryFilterCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
