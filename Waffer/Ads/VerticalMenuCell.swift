//
//  VerticalMenuCell.swift
//  Waffer
//
//  Created by Batool Alsmael on 1/8/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//


import UIKit

class VerticalMenuCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white

            nameLable.textColor = isHighlighted ? UIColor.white : UIColor.black

            //iconImageView.tintColor = highlighted ? UIColor.whiteColor() : UIColor.darkGrayColor()
        }
    }
    
    var verticalMenuItem: VerticalMenuItem? {
        didSet {
            nameLable.text = verticalMenuItem?.name
            
        }
    }
    
    
    let nameLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "Edit Post"
        lbl.font = UIFont.systemFont(ofSize: 13)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .red
        
        addSubview(nameLable)
        
        nameLable.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
