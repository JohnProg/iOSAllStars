//
//  EmployeeStar.swift
//  AllStars
//
//  Created by Raul Rashuaman on 4/28/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import Foundation

class EmployeeStar {
    
    var pk: UInt?
    var name: String?
    var stars: UInt?
}

extension EmployeeStar {
    
    struct Keys {
        static let pk = "pk"
        static let name = "name"
        static let stars = "num_stars"
    }
    
    class func parseEmployeeStar(json: [String: AnyObject]) -> EmployeeStar {
        let employeeStar = EmployeeStar()
        employeeStar.pk = json[Keys.pk] as? UInt
        employeeStar.name = json[Keys.name] as? String
        employeeStar.stars = json[Keys.stars] as? UInt
        return employeeStar
    }
    
    class func parseEmployeeStars(json: [[String: AnyObject]]) -> [EmployeeStar] {
        var employeeStars = [EmployeeStar]()
        for employeeStar in json {
            employeeStars.append(EmployeeStar.parseEmployeeStar(employeeStar))
        }
        return employeeStars
    }
}