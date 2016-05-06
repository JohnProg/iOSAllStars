//
//  RecommendService.swift
//  AllStars
//
//  Created by Gianfranco Yosida on 4/21/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import Foundation

typealias GiveStar = (succeed: Bool, error: NSError?) -> Void
typealias EmployeeStarResponse = (employeeStar : [EmployeeStar]?, error : NSError?) -> Void
typealias EmployeeStarSubcategoryResponse = (star: [Star]?, error: NSError?) -> Void

class StarService {
    
    class func giveStar(fromId: UInt, toId: UInt, subcategory: Category, keyword: Keyword, comment: String?, onCompletion: GiveStar) {
        let segments: [(key: String, value: String)] = [
            (Constants.PathSegmentKeys.fromEmployee, String(fromId)),
            (Constants.PathSegmentKeys.toEmployee, String(toId))
        ]
        let url = BaseService.subtituteKeysInMethod(Constants.Methods.recommend, pathSegments: segments)
        var params: [String: AnyObject!] = [
            Constants.JSONBodyKeys.category : subcategory.parentCategory?.pk,
            Constants.JSONBodyKeys.subcategory : subcategory.pk,
            Constants.JSONBodyKeys.keyword : keyword.pk
        ]
        if let comment = comment {
            params[Constants.JSONBodyKeys.text] = comment
        }
        BaseService.makeRequest(url, method: .POST, parameters: params) { (json: AnyObject?, error: NSError?) in
            if error == nil {
                onCompletion(succeed: true, error: nil)
            } else {
                onCompletion(succeed: false, error: error)
            }
        }
    }
        
    class func employeeStarList(employeeId : UInt, onCompletion: EmployeeStarResponse) {
        let segment = (Constants.PathSegmentKeys.employeeId, String(employeeId))
        let url = BaseService.subtituteKeyInMethod(Constants.Methods.employeeStarList, pathSegment: segment)
        BaseService.makeRequest(url, method: .GET, parameters: nil) { (json: AnyObject?, error: NSError?) in
            if error == nil {
                guard let jsonDictionary = json as? NSDictionary else {
                    onCompletion(employeeStar: nil, error: NSError(domain: "", code: 1000, userInfo: nil))
                    return
                }
                guard let jsonStars = jsonDictionary["results"] as? [NSDictionary] else {
                    onCompletion(employeeStar: nil, error: NSError(domain: "", code: 1000, userInfo: nil))
                    return
                }
                onCompletion(employeeStar: EmployeeStar.parseEmployeeStars(jsonStars), error: nil)
            } else {
                onCompletion(employeeStar: nil, error: error)
            }
        }
    }
    
    class func employeeStarSubcategoryList(employeeId : UInt, subcategoryId : UInt, onCompletion: EmployeeStarSubcategoryResponse) {
        let segments: [(key: String, value: String)] = [
            (Constants.PathSegmentKeys.employeeId, String(employeeId)),
            (Constants.PathSegmentKeys.subCategoryId, String(subcategoryId))
            
        ]
        let url = BaseService.subtituteKeysInMethod(Constants.Methods.employeeStarSubcategoryList, pathSegments: segments)
        BaseService.makeRequest(url, method: .GET, parameters: nil) { (json: AnyObject?, error: NSError?) in
            if error == nil {
                guard let jsonDictionary = json as? NSDictionary else {
                    onCompletion(star: nil, error: NSError(domain: "", code: 1000, userInfo: nil))
                    return
                }
                guard let jsonStars = jsonDictionary["results"] as? [NSDictionary] else {
                    onCompletion(star: nil, error: NSError(domain: "", code: 1000, userInfo: nil))
                    return
                }
                onCompletion(star: Star.parseStars(jsonStars), error: nil)
            } else {
                onCompletion(star: nil, error: error)
            }
        }
    }
    
}
