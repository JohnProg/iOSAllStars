//
//  RecommendService.swift
//  AllStars
//
//  Created by Gianfranco Yosida on 4/21/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import Foundation

typealias GiveStar = (star: Star?, error: NSError?) -> Void
typealias EmployeeStarResponse = (employeeStar : [EmployeeStar]?, error : NSError?) -> Void

class StarService {
    
    class func giveStar(fromId: UInt, toId: UInt, subcategory: Category, comment: String?, onCompletion: GiveStar) {
        let segments: [(key: String, value: String)] = [
            (Constants.PathSegmentKeys.fromEmployee, String(fromId)),
            (Constants.PathSegmentKeys.toEmployee, String(toId))
        ]
        let url = BaseService.subtituteKeyInMethod(Constants.Methods.recommend, pathSegments: segments)
        var params: [String: AnyObject!] = [
            Constants.JSONBodyKeys.category : subcategory.parentCategoryPk,
            Constants.JSONBodyKeys.subcategory : subcategory.pk
        ]
        if let comment = comment {
            params[Constants.JSONBodyKeys.text] = comment
        }
        BaseService.makeRequest(url, method: .POST, parameters: params) { (json: AnyObject?, error: NSError?) in
            if error == nil {
                let star = Star.parseStar(json as! [String: AnyObject])
                onCompletion(star: star, error: nil)
            } else {
                onCompletion(star: nil, error: error)
            }
        }
    }
        
    class func employeeStarList(employeeId : UInt, onCompletion: EmployeeStarResponse) {
        let segments: [(key: String, value: String)] = [
            (Constants.PathSegmentKeys.employeeId, String(employeeId))
        ]
        let url = BaseService.subtituteKeyInMethod(Constants.Methods.employeeStarList, pathSegments: segments)
        
        BaseService.makeRequest(url, method: .GET, parameters: nil) { (json: AnyObject?, error: NSError?) in
            if error == nil {
                guard let jsonDictionary = json as? NSDictionary else {
                    return
                }
                guard let jsonStars = jsonDictionary["results"] as? [NSDictionary] else {
                    return
                }
                onCompletion(employeeStar: EmployeeStar.parseEmployeeStars(jsonStars), error: nil)
            } else {
                onCompletion(employeeStar: nil, error: error)
            }
        }
    }
    
}
