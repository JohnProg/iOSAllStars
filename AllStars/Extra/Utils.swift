//
//  Utils.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/7/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

class Utils: NSObject {

    static let mainColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
    static let tokenKey = "token"
    static let userIdKey = "userId"
    
    class func loginScreen() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier("login")
    }
    
    class func save(string : String, key : String) {
        KeychainWrapper.setString(string, forKey: key)
    }
    
    class func load(key : String) -> String {
        if let text = KeychainWrapper.stringForKey(key) {
            return text
        }
        return ""
    }
    
    class func cleanSession() {
        KeychainWrapper.removeObjectForKey(Utils.tokenKey)
        KeychainWrapper.removeObjectForKey(Utils.userIdKey)
    }
}
