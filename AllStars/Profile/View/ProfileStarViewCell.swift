//
//  ProfileStarViewCell.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 5/2/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit
import FoldingCell

class ProfileStarViewCell: FoldingCell {

    @IBOutlet weak var fromUserName: UILabel!
    @IBOutlet weak var detailFromUserName: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailMessage: UILabel!
    @IBOutlet weak var detailCategory: UILabel!
    
    @IBOutlet weak var userImageContainer: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userInitials: UILabel!
    
    @IBOutlet weak var detailUserImageContainer: UIView!
    @IBOutlet weak var detailUserInitials: UILabel!
    @IBOutlet weak var detailUserImage: UIImageView!
    
    override func awakeFromNib() {
        
        foregroundView.layer.cornerRadius = 3
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
        
        userImageContainer.layer.masksToBounds = true
        userImageContainer.layer.cornerRadius = userImageContainer.frame.size.width/2
        userImageContainer.backgroundColor = ContactUtils.randomBackgroundColor()
        detailUserImageContainer.layer.masksToBounds = true
        detailUserImageContainer.layer.cornerRadius = detailUserImageContainer.frame.size.width/2
        detailUserImageContainer.backgroundColor = userImageContainer.backgroundColor
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }

    func setInfo(star : Star) {
        if let contactImage = star.fromUser?.image {
            ImageLoader.sharedLoader.imageForUrl(contactImage, completionHandler:{(image: UIImage?, url: String) in
                self.userImage.image = image
                self.detailUserImage.image = image
                self.userImage.hidden = false
                self.detailUserImage.hidden = false
            })
            userInitials.hidden = true
            detailUserInitials.hidden = true
            userImageContainer.backgroundColor = .clearColor()
            detailUserImageContainer.backgroundColor = userImageContainer.backgroundColor
        } else {
            userImage.hidden = true
            detailUserImage.hidden = true
            userInitials.hidden = false
            detailUserInitials.hidden = false
            userInitials.text = star.fromUser?.initials()
            detailUserInitials.text = userInitials.text
        }
        
        fromUserName.text = star.fromUser?.displayName()
        
        if let fromUserName = star.fromUser?.displayName() {
            detailFromUserName.text = "From: " + fromUserName
        }
        
        if let date = star.date {
            detailDate.text = "Date: " + parseDate(date)
        }
        
        if let comment = star.text {
            detailMessage.text = "Comment: " + comment
        } else {
            detailMessage.text = "Comment: No comments"
        }
        if let category = star.category?.name {
            detailCategory.text = "Category: " + category
        } else {
            detailCategory.text = "Category: No category"
        }
    }
    
    func parseDate(date : String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //date format ISO-8601
        let date = dateFormatter.dateFromString(date)
        
        if date == nil {
            return ""
        }
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        return dateFormatter.stringFromDate(date!)
    }

}
