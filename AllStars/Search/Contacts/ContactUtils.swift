//
//  ContactUtils.swift
//  Contacts
//
//  Created by Rodrigo Gonzalez on 4/22/16.
//  Copyright © 2016 Rodrigo Gonzalez. All rights reserved.
//

import UIKit

class ContactUtils {

    //MARK: Color Constants
    struct Colors {
        static let emeraldColor = UIColor(red: (46/255), green: (204/255), blue: (113/255), alpha: 1.0)
        static let sunflowerColor = UIColor(red: (241/255), green: (196/255), blue: (15/255), alpha: 1.0)
        static let pumpkinColor = UIColor(red: (211/255), green: (84/255), blue: (0/255), alpha: 1.0)
        static let asbestosColor = UIColor(red: (127/255), green: (140/255), blue: (141/255), alpha: 1.0)
        static let amethystColor = UIColor(red: (155/255), green: (89/255), blue: (182/255), alpha: 1.0)
        static let peterRiverColor = UIColor(red: (52/255), green: (152/255), blue: (219/255), alpha: 1.0)
        static let pomegranateColor = UIColor(red: (192/255), green: (57/255), blue: (43/255), alpha: 1.0)
    }
    
    static let colors = [Colors.emeraldColor, Colors.sunflowerColor, Colors.pumpkinColor, Colors.asbestosColor, Colors.amethystColor, Colors.peterRiverColor, Colors.pomegranateColor]
    
    class func randomBackgroundColor() -> UIColor {
        let randomIndex = Int(rand()) % colors.count
        return colors[randomIndex]
    }
}
