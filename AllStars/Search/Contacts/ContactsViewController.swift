//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Rodrigo Gonzalez on 4/22/16.
//  Copyright © 2016 Rodrigo Gonzalez. All rights reserved.
//

import UIKit

protocol ContactsViewControllerDelegate : class {
    func contactSelected(contact : Contact)
}

typealias ContactsHandler = (contacts : [Contact]? , error : NSError?) -> Void

class ContactsViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    weak var delegate : ContactsViewControllerDelegate?

    private let cellReuseIdentifier = "cellIdentifier"
    
    private var contactsSearchController : UISearchController = ( {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        return controller
    })()
    
    var contacts = [Contact]() {
        didSet {
            tableView.reloadData()
        }
    }
        
    private var filteredContacts = [Contact]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    convenience init(contacts : [Contact]) {
        self.init(style: .Plain)
        self.contacts = contacts
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSearchBar()

        // register the nib
        let nib = UINib(nibName: "ContactCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)
    
        tableView.tableFooterView = UIView()
        
        getContacts { (contacts, error) -> Void in
            if contacts != nil {
                self.contacts = contacts!
            }
        }
    }
    
    func getContacts(onCompletition : ContactsHandler) {
        // to be overriden
    }
    
    deinit {
        // due to bug with UISearchController http://www.openradar.me/22250107
        contactsSearchController.loadViewIfNeeded()
    }
    
    func initializeSearchBar() {
        contactsSearchController.searchResultsUpdater = self
        contactsSearchController.searchBar.delegate = self
        self.tableView.tableHeaderView = contactsSearchController.searchBar
    }
    
    func selectedContact(contact : Contact) {
        delegate?.contactSelected(contact)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if contactsSearchController.active {
            return 1
        }
        return contacts.count > 0 ? 1 : 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if contactsSearchController.active {
            return filteredContacts.count
        }
        return contacts.count > 0 ? contacts.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! ContactTableViewCell
        var contact = contacts[indexPath.row]
        
        if contactsSearchController.active {
            contact = filteredContacts[indexPath.row]
        }
        
        cell.setContactInformation(contact)
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        contactsSearchController.active = false
        var contact = contacts[indexPath.row]
        if contactsSearchController.active {
            contact = filteredContacts[indexPath.row]
        }
        selectedContact(contact)
    }
    
    // MARK: - Search Actions
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        if let searchText = contactsSearchController.searchBar.text where searchController.active && searchText.characters.count > 0 {
            filteredContacts = contacts.filter({(item: Contact) -> Bool in
                let contactMatch = item.displayName().lowercaseString.rangeOfString(searchText.lowercaseString)
                return contactMatch != nil ? true : false
            })
        } else {
            filteredContacts = contacts
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
}
