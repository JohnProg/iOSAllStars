//
//  Star.swift
//  AllStars
//
//  Created by Gianfranco Yosida on 4/26/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import Foundation

class Star {
    
    var pk: UInt?
    var date: String?
    var text: String?
    var fromUser: User?
    var toUser: User?
    var category: Category?
    var subcategoryPk: UInt?
    
}

extension Star {
    
    struct Keys {
        static let pk = "pk"
        static let date = "date"
        static let text = "text"
        static let fromUser = "from_user"
        static let toUser = "to_user"
        static let category = "category"
        static let subcategory = "subcategory"
    }
    
    class func parseStar(json: NSDictionary) -> Star {
        let star = Star()
        star.pk = json[Keys.pk] as? UInt
        star.date = json[Keys.date] as? String
        star.text = json[Keys.text] as? String
        
        if let jsonFromUser = json[Keys.fromUser] as? NSDictionary {
            star.fromUser = User.parseJSON(jsonFromUser)
        }
        
        if let jsonToUser = json[Keys.toUser] as? NSDictionary {
            star.toUser = User.parseJSON(jsonToUser)
        }
        if let jsonCategory = json[Keys.category] as? NSDictionary {
            star.category = Category.parseCategory(jsonCategory)
        }
        
        star.subcategoryPk = json[Keys.subcategory] as? UInt
        return star
    }
    
    class func parseStars(json : [NSDictionary]) -> [Star] {
        var stars = [Star]()
        
        for jsonStar in json {
            stars.append(Star.parseStar(jsonStar))
        }
        
        return stars
    }
}
