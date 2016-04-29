//
//  RankingTableViewController.swift
//  AllStars
//
//  Created by Belatrix on 4/28/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

class RankingTableViewController: ContactsViewController {

    var yOffset : CGFloat = 30.0
    
    private var frameUpdated = false
    
    var kind : TopKind?
    var quantity = "10"
    
    let goldColor = UIColor(red: 255.0/255.0, green: 215.0/255.0, blue: 0, alpha: 1)
    let silverColor = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1)
    let bronzeColor = UIColor(red: 205.0/255.0, green: 127.0/255.0, blue: 50.0/255.0, alpha: 1)
    
    override func initializeSearchBar() {
        //no op
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        tableView.contentInset.top = yOffset
    }
    
    override func getContacts(onCompletition : ContactsHandler) {
        guard let safeKind = kind else {
            return
        }

        showLoadingIndicator()
        UserService.employeeTopList(safeKind, quantity: quantity) { (users : Array<User>?, error : NSError?) -> Void in
            self.hideLoadingIndicator()
            if error == nil {
                onCompletition(contacts: users, error: error)
            } else {
                onCompletition(contacts: nil, error: error)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as! ContactTableViewCell
        
        var trophy = UIImage(named : "trophy")
        
        switch indexPath.row {
            case 0:
                trophy = trophy?.tintWithColor(goldColor)
            case 1:
                trophy = trophy?.tintWithColor(silverColor)
            case 2:
                trophy = trophy?.tintWithColor(bronzeColor)
            default:
                trophy = trophy?.tintWithColor(.blackColor())
        }
        
        if let user = contacts[indexPath.row] as? User {
            if user.score != nil {
                cell.setScoreInformation(trophy, score : String(user.score!))
            }
        }
        return cell
    }

    
    override func selectedContact(contact : Contact) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("profileMainView") as! ProfileViewController
        vc.user = contact
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
