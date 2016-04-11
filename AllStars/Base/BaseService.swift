//
//  BaseService.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/11/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit
import Alamofire

typealias ServiceResponse = (AnyObject?, NSError?) -> Void

class BaseService {

    static let allStarsURL = "https://allstars-belatrix.herokuapp.com"
    
    class func makeRequest(endpoint : String?, method : Alamofire.Method, parameters : Dictionary<String,String>?, onCompletion : ServiceResponse) {

        guard let safeEndpoint = endpoint where endpoint?.characters.count > 0 else {
            return
        }
        
        let endpoint = allStarsURL + safeEndpoint
        
        Alamofire.request(method, endpoint, parameters: parameters)
            .responseJSON { response in
                if let JSON = response.result.value {
                    onCompletion(JSON , nil)
                } else {
                    onCompletion(nil, NSError(domain: "", code: 0, userInfo: nil))
                }
        }

    }
    
}
