//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Rodrigo Gonzalez on 4/22/16.
//  Copyright © 2016 Rodrigo Gonzalez. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactDetail: UILabel!
    @IBOutlet weak var contactImageContainer: UIView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactImageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contactImageContainer.layer.masksToBounds = true
        contactImageContainer.layer.cornerRadius = contactImageContainer.frame.size.width/2
        contactImageContainer.backgroundColor = ContactUtils.randomBackgroundColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContactInformation(contact : Contact) {
        contactName.text = contact.displayName()
        contactDetail.text = contact.detail
        if let contactImage = contact.image {
            ImageLoader.sharedLoader.imageForUrl(contactImage, completionHandler:{(image: UIImage?, url: String) in
                self.contactImage.image = image
                self.contactImage.hidden = false
            })
            contactImageLabel.hidden = true
            contactImageContainer.backgroundColor = .clearColor()
        } else {
            contactImage.hidden = true
            contactImageLabel.hidden = false
            contactImageLabel.text = contact.initials()
        }
    }
}
