//
//  User.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/11/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

class User {
    var pk : UInt?
    var username : String?
    var email : String?
    var firstName : String?
    var lastName : String?
    var level : UInt?
    var avatar : String?
    var score : UInt?
    
    convenience init(pk : UInt?, username : String?, email : String?, firstName : String?, lastName : String?, level : UInt, avatar : String?, score : UInt?) {
        self.init()
        self.pk = pk
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.level = level
        self.avatar = avatar
        self.score = score
    }
}

//MARK: JSON Parsing
extension User {
    struct Keys {
        static let pk           = "pk"
        static let username     = "username"
        static let email        = "email"
        static let firstName    = "first_name"
        static let lastName     = "last_name"
        static let level        = "level"
        static let avatar       = "avatar"
        static let score        = "score"
    }
    
    class func parseJSON(json : NSDictionary) -> User {
        let user = User()
        user.pk = json[Keys.pk] as? UInt
        user.username = json[Keys.username] as? String
        user.email = json[Keys.email] as? String
        user.firstName = json[Keys.firstName] as? String
        user.lastName = json[Keys.lastName] as? String
        user.level = json[Keys.level] as? UInt
        user.avatar = json[Keys.avatar] as? String
        user.score = json[Keys.score] as? UInt
        return user
    }
    
    class func parseUsers(json : Array<NSDictionary>) -> Array<User>? {
        var users = Array<User>()
        for userJson in json {
            users.append(User.parseJSON(userJson))
        }
        
        return users
    }
    
}
