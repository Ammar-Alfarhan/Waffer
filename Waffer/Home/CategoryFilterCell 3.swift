//
//  CategoryFilterCell.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 12/4/18.
//  Copyright © 2018 Batool Alsumaeel. All rights reserved.
//

import UIKit

class CategoryFilterCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            
            nameLable.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLable.text = setting?.name
        }
    }
    
    let nameLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "Cars"
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLable)
        
        nameLable.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
