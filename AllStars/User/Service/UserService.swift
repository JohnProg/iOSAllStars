//
//  UserService.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/11/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

typealias UserListServiceResponse = (Array<User>?, NSError?) -> Void
typealias UserServiceResponse = (User?, NSError?) -> Void

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
}
