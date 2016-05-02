//
//  Category.swift
//  AllStars
//
//  Created by Gianfranco Yosida on 4/21/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import Foundation

class Category {
    
    var pk: UInt?
    var name: String?
    var parentCategoryPk: UInt?
    var weight : UInt?
}

extension Category {
    
    struct Keys {
        static let pk = "pk"
        static let name = "name"
        static let weight = "wight"
    }
    
    class func parseCategory(json: NSDictionary) -> Category {
        let category = Category()
        category.pk = json[Keys.pk] as? UInt
        category.name = json[Keys.name] as? String
        category.weight = json[Keys.weight] as? UInt
        return category
    }
    
    class func parseCategories(json: [NSDictionary]) -> [Category] {
        var categories = [Category]()
        for category in json {
            categories.append(Category.parseCategory(category))
        }
        return categories
    }
    
}
