//
//  Contact.swift
//  Contacts
//
//  Created by Rodrigo Gonzalez on 4/22/16.
//  Copyright © 2016 Rodrigo Gonzalez. All rights reserved.
//

import UIKit

class Contact {

    var image : String?
    var firstName : String = ""
    var lastName : String = ""
    var detail : String = ""
    var nameOrder : NameOrder = .FirstNameLastName
    
    init() {
        
    }
    
    init (firstName : String, lastName : String, detail : String, image : String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.detail = detail
        self.image = image
    }
    
    enum NameOrder {
        case FirstNameLastName
        case LastNameFirstName
    }
    
    func displayName() -> String {
        switch nameOrder {
            case .LastNameFirstName:
                return lastName + " " + firstName
            default:
                return firstName + " " + lastName
        }
    }
    func initials() -> String {
        switch nameOrder {
        case .LastNameFirstName:
            return String(lastName[lastName.startIndex]) + String(firstName[firstName.startIndex])
        default:
            return String(firstName[firstName.startIndex]) + String(lastName[lastName.startIndex])
        }
    }
}
