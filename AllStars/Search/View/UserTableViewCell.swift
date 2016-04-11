//
//  UserTableViewCell.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/11/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScore: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setValues(image : String?, userName : String?, userScore : UInt? ) {
        if let safeImage = image {
            //TODO: put the actual image
            print(safeImage)
        } else {
            //default image
            userImage.image = UIImage(named:"profile")
        }
        
        self.userName.text = userName
        let scoreTitle = (userScore != nil) ? "puntaje: " + String(userScore!) : "puntaje: 0"
        
        self.userScore.text = scoreTitle
    }
}
