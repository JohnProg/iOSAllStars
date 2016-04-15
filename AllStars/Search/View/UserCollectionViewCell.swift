//
//  UserCollectionViewCell.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/15/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!     
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 0.5
        
        nameLabel.backgroundColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
        }
        
        image.snp_makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(self)
        }
    }
    
    func setContent(name : String) {
        
        let initialsLabel = UILabel()
        initialsLabel.text = Utils.getNameInitials(name)
        initialsLabel.sizeToFit()
        image.addSubview(initialsLabel)
        image.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.3, alpha: 0.9)
        
        initialsLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(image.snp_centerX)
            make.top.equalTo(image.snp_top).offset(10)
        }
        
        nameLabel.text = name
    }
    
    func setContent(image : String, name : String) {
        
        self.image?.image = UIImage(named: "profile")
        
        nameLabel.text = name
    }
}
