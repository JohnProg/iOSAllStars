//
//  SearchTableViewController.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/11/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    var users : Array<User>? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingIndicator()
        UserService.employeeList { (users : Array<User>?, error : NSError?) -> Void in
            self.hideLoadingIndicator()
            if error == nil {
                self.users = users
            } else {
                //TODO: show error
                
            }
        }
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (users?.count > 0) ? 1 : 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (users?.count > 0) ? users!.count : 0
    }

    
    let cellIdentifier = "userCell"
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserTableViewCell

        let user = users?[indexPath.row]
        
        cell.setValues(user?.avatar, userName: user?.username, userScore: user?.score)
        // Configure the cell...

        return cell
    }
}
