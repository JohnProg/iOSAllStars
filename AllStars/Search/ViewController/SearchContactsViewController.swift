//
//  SearchContactsViewController.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/26/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

class SearchContactsViewController: ContactsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Search", comment : "Search")
    }
    
    override func getContacts(onCompletition : ContactsHandler) {
        showLoadingIndicator()
        UserService.employeeList { (users : Array<User>?, error : NSError?) -> Void in
            self.hideLoadingIndicator()
            if error == nil {
                onCompletition(contacts: users, error: error)
            } else {
                onCompletition(contacts: nil, error: error)
            }
        }
    }
    
    override func selectedContact(contact : Contact) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("profileMainView") as! ProfileTableViewController
        vc.user = contact
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
