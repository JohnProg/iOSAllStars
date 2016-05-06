//
//  Keyword.swift
//  AllStars
//
//  Created by Gianfranco Yosida on 5/6/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import Foundation

class Keyword {
    
    var pk: UInt?
    var name: String?
    var numStars: UInt?
    
    init() {}
    
    init(pk: UInt, name: String, numStars: UInt) {
        self.pk = pk
        self.name = name
        self.numStars = numStars
    }
    
}

extension Keyword {
    
    struct Keys {
        static let pk = "pk"
        static let name = "name"
        static let numStars = "num_stars"
    }
    
    static func parseKeyword(json: NSDictionary) -> Keyword {
        let keyword = Keyword()
        keyword.pk = json[Keys.pk] as? UInt
        keyword.name = json[Keys.name] as? String
        keyword.numStars = json[Keys.numStars] as? UInt
        return keyword
    }
    
    static func parseKeywords(json: [NSDictionary]) -> [Keyword] {
        var keywords = [Keyword]()
        for jsonKeyword in json {
            keywords.append(parseKeyword(jsonKeyword))
        }
        return keywords
    }
    
}