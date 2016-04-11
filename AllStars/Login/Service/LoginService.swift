//
//  LoginService.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/11/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

class LoginService: BaseService {

    private static let loginURL = "/api/employee/authenticate/"
    
    class func login(username : String, password : String, onCompletition : ServiceResponse) {
        
        if username.characters.count <= 0 || password.characters.count <= 0 {
            return
        }
        
        let params = ["username" : username, "password" : password]
        
        self.makeRequest(loginURL, method: .POST, parameters: params) { (json : AnyObject?, error : NSError?) -> Void in
                print(json)
            if error != nil {
                onCompletition(nil, error)
            } else {
                onCompletition(json, nil)
            }
        }

    }
}
