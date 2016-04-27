//
//  UserService.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/11/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import Foundation

typealias UserListServiceResponse = (Array<User>?, NSError?) -> Void
typealias UserServiceResponse = (User?, NSError?) -> Void
typealias UserCategoriesList = (categories: [Category]?, error: NSError?) -> Void

class UserService: BaseService {

    private static let employeeList = "/api/employee/list/"
    
    class func employeeList(onCompletition : UserListServiceResponse) {
        
        self.makeRequest(employeeList, method: .GET, parameters: nil) { (json : AnyObject?, error : NSError?) -> Void in
            print(json)
            if error != nil {
                onCompletition(nil, error)
            } else {
                guard let jsonUser = (json as? NSDictionary)!["results"] as? Array<NSDictionary> else {
                    return
                }
                onCompletition(User.parseUsers(jsonUser), nil)
            }
        }
        
    }
    
    class func getEmployeeCategoryList(employeePk: UInt, onCompletion: UserCategoriesList) {
        let fullPath = BaseService.subtituteKeyInMethod(Constants.Methods.employeeCategoryList, pathSegment: (key: Constants.PathSegmentKeys.employeeId, value: String(employeePk)))
        BaseService.makeRequest(fullPath, method: .GET, parameters: nil) { (json: AnyObject?, error: NSError?) in
            if error == nil {
                let employeeCategories = Category.parseCategories(json as! [[String: AnyObject]])
                onCompletion(categories: employeeCategories, error: nil)
            } else {
                onCompletion(categories: nil, error: error)
            }
        }
    }

    private static let employeeIdEndpoint = "/api/employee/"
    
    class func employee(employeeId : String, onCompletition : UserServiceResponse) {
        let employeeIdURL = employeeIdEndpoint + employeeId
        self.makeRequest(employeeIdURL, method: .GET, parameters: nil) { (json : AnyObject?, error : NSError?) in
            print(json)
            if error != nil {
                onCompletition(nil, error)
            } else {
                guard let jsonUser = json as? NSDictionary else {
                    return
                }
                onCompletition(User.parseJSON(jsonUser),nil)
            }
        }
    }
    
    private static let employeeTopList = "/api/employee/list/top/"
    
    enum TopKind : String {
        case Score, Level, LastMonthScore, CurrentMonthScore
    }
    
    class func employeeTopList(kind : TopKind, quantity : String, onCompletition : UserListServiceResponse) {
        var kindString = ""
        
        switch kind {
        case .Level:
            kindString = "level"
        case .LastMonthScore:
            kindString = "last_month_score"
        case .CurrentMonthScore:
            kindString = "current_month_score"
        default:
            kindString = "score"
        }
        
        let employeeTopListURL = employeeTopList + kindString + "/" + quantity + "/"
        makeRequest(employeeTopListURL, method: .GET, parameters: nil) { (json : AnyObject?, error :NSError?) in
            if error != nil {
                onCompletition(nil, error)
            }
            guard let jsonUsers = json as? Array<NSDictionary> else {
                return
            }
            
            onCompletition(User.parseUsers(jsonUsers),nil)
        }
    }
}
