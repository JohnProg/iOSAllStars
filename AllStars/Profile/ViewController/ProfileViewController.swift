//
//  ProfileViewController.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/28/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIScrollViewDelegate {

    static let starVC = "starVC"

    var user : Contact! {
        didSet {
            setupViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named : "more"), style: .Done, target: self, action: #selector(menuTapped))
            // get logged user
            let userId = Utils.load(Utils.userIdKey)
            
            showLoadingIndicator()
            UserService.employee(userId, onCompletition: { (user : User?, error : NSError?) in
                self.hideLoadingIndicator()
                if error == nil {
                    self.user = user
                }
            })            
        } else {
            if !isCurrentUser() {
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(giveStar))
            }
        }
    }
    
    func isCurrentUser() -> Bool {
        guard let userKey = (user as! User).pk else{
            return false
        }
        
        return String(userKey) == Utils.load(Utils.userIdKey)
    }
    
    func menuTapped() {
        let alertView = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertView.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .Default) { (alertAction : UIAlertAction) -> Void in
            guard let loginScreen = Utils.loginScreen() else {
                return
            }
            Utils.cleanSession()
            self.presentViewController(loginScreen, animated: true, completion: nil)
        }
        
        alertView.addAction(logoutAction)
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func giveStar() {
        let storyboard = UIStoryboard(name: "Stars", bundle: nil)
        let starNavigationVC = storyboard.instantiateViewControllerWithIdentifier(ProfileViewController.starVC) as! UINavigationController
        let giveStarVC = starNavigationVC.childViewControllers.first as! GiveStarTableViewController
        giveStarVC.user = user as! User
        presentViewController(starNavigationVC, animated: true, completion: nil)
    }
    
    var titleView = UIScrollView()
    var contentView = UIScrollView()
    
    var profileView : UIView!
    
    func setupViews() {
        contentView = UIScrollView(frame: self.view.bounds)
        contentView.contentSize = CGSizeMake(0.0, CGFloat.max)
        contentView.delegate = self
        self.view.addSubview(contentView)
        
        profileView = createProfileView()
        contentView.addSubview(profileView)
        
        self.title = user.firstName
        if let navigationHeight = navigationController?.navigationBar.frame.height {
            titleView = UIScrollView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: view.frame.width,
                                        height: navigationHeight))
            
            titleView.contentSize = CGSizeMake(0.0, navigationHeight * 2)
            self.view.addSubview(titleView)
            
            let titleLabel = UILabel(frame: CGRect(x: 0, y: profileView.frame.height + offset / 3, width: titleView.frame.width, height: navigationHeight))
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.text = self.title
            titleView.addSubview(titleLabel)
            self.navigationItem.titleView = titleView
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let navigationHeight = navigationController?.navigationBar.frame.height {
            let contentOffset : CGFloat = scrollView.contentOffset.y + navigationHeight + offset * 2
            let frameOffset : CGFloat = profileView.frame.height + profileView.frame.origin.y + offset / 2
            let contentnOffset:CGPoint = CGPointMake(0.0, min(contentOffset, frameOffset))
            titleView.setContentOffset(contentnOffset, animated: false)
        }
    }
    
    var profileIconSize : CGFloat {
        get {
            return self.view.frame.width / 4
        }
    }
    
    let offset : CGFloat = 15
    let labelHeight : CGFloat = 21

    let profileName = UILabel()
    
    func createProfileView() -> UIView {
        let frameWidth = view.frame.width - view.frame.origin.x - offset * 2
        
        // set the profile imageview
        let profileImage = UIImageView()
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.layer.borderWidth = 1.5
        profileImage.layer.cornerRadius = 10
        profileImage.layer.masksToBounds = true
        
        profileImage.image = UIImage(named: "profile")
        
        // calculate the profile imageview frame
        let profileImageFrame = CGRect(x: view.frame.origin.x + offset,
            y: offset * 2,
            width: profileIconSize,
            height: profileIconSize)

        profileImage.frame = profileImageFrame

        // set the profile name label
        profileName.text = user.displayName()
        profileName.backgroundColor = .clearColor()
        
        // calculate the profile name label frame
        let profileNameFrame = CGRect(x: profileImageFrame.origin.x,
                y: profileImageFrame.origin.y + profileImageFrame.height + offset,
                width: frameWidth,
                height: labelHeight)
        
        profileName.frame = profileNameFrame
        
        // set the profile email label
        let profileEmailLabel = UILabel()
        profileEmailLabel.text = user.detail
        profileEmailLabel.textColor = .lightGrayColor()
        
        let profileEmailFrame = CGRect(x: profileNameFrame.origin.x,
                y: profileNameFrame.origin.y + profileNameFrame.height,
                width: frameWidth,
                height: labelHeight)
        profileEmailLabel.frame = profileEmailFrame
        
        // score background view
        let scoreOffset : CGFloat = 3
        
        let scoreFrame = CGRect(x: profileEmailFrame.origin.x,
                y: profileEmailFrame.origin.y + profileEmailFrame.height + offset,
                width: frameWidth,
                height: labelHeight + scoreOffset * 2)

        let scoreBackgroundView = UIView(frame: scoreFrame)
        scoreBackgroundView.layer.borderColor = UIColor.lightGrayColor().CGColor
        scoreBackgroundView.layer.borderWidth = 0.5
        
        // level label view
        let levelLabelFrame = CGRect(x: 0,
                y: scoreOffset,
                width: scoreFrame.width / 2,
                height: scoreFrame.height - scoreOffset)
        
        let levelLabel = UILabel(frame: levelLabelFrame)
        
        if let user = self.user as? User where user.level != nil  {
            levelLabel.text = "Level: " + String(user.level!)
        } else {
            levelLabel.text = "Level: 0"
        }

        levelLabel.textAlignment = .Center
        levelLabel.textColor = .lightGrayColor()
        
        scoreBackgroundView.addSubview(levelLabel)
        
        // score label view
        
        let scoreLabelFrame = CGRect(x: scoreFrame.width / 2, y: scoreOffset, width: scoreFrame.width / 2, height: scoreFrame.height - scoreOffset)
        let scoreLabel = UILabel(frame: scoreLabelFrame)

        if let user = self.user as? User where user.score != nil  {
            scoreLabel.text = "Score: " + String(user.score!)
        } else {
            scoreLabel.text = "Score: 0"
        }
        
        scoreLabel.textAlignment = .Center
        scoreLabel.textColor = .lightGrayColor()
        
        scoreBackgroundView.addSubview(scoreLabel)
        
        // score separator line
        let verticalSeparatorFrame = CGRect(x: scoreFrame.width / 2, y: 0, width: 1, height: scoreFrame.height)
        
        let verticalSeparator = UIView(frame: verticalSeparatorFrame)
        verticalSeparator.backgroundColor = .lightGrayColor()
        
        scoreBackgroundView.addSubview(verticalSeparator)
        
        // set the background view
        let backgroundFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: profileImageFrame.origin.y + profileImageFrame.height / 2)
        let backgroundView = UIView(frame: backgroundFrame)
        backgroundView.backgroundColor = Utils.mainColor

        let profileView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: scoreFrame.height + scoreFrame.origin.y + offset ))
        
        let bottomLine = UIView(frame: CGRect(x: profileView.frame.origin.x + offset, y: profileView.frame.origin.y + profileView.frame.height, width: profileView.frame.width - offset * 2, height: 1))
        bottomLine.backgroundColor = .lightGrayColor()
        
        profileView.addSubview(backgroundView)
        profileView.addSubview(profileName)
        profileView.addSubview(profileImage)
        profileView.addSubview(profileEmailLabel)
        profileView.addSubview(scoreBackgroundView)
        profileView.addSubview(bottomLine)
        
        return profileView
    }
}
