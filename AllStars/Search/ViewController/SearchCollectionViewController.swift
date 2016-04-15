//
//  SearchCollectionViewController.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/15/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SearchCell"

class SearchCollectionViewController: UICollectionViewController {

    var users : Array<User>? {
        didSet {
            self.collectionView?.reloadData()
        }
    }

    var cellWidth : CGFloat {
        get {
            return self.view.frame.width / 3
        }
    }

    var cellHeight : CGFloat {
        get {
            return self.cellWidth
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .whiteColor()
        showLoadingIndicator()
        UserService.employeeList { (users : Array<User>?, error : NSError?) -> Void in
            self.hideLoadingIndicator()
            if error == nil {
                self.users = users
            } else {
                //TODO: show error
                
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (users?.count > 0) ? 1 : 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (users?.count > 0) ? users!.count * 3 : 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserCollectionViewCell

        if indexPath.row % 2 == 0 {
            cell.setContent("Rodrigo Gonzalez Gonzalez")
        } else {
            cell.setContent("Image", name: "Rodrigo Gonzalez Gonzalez")
        }
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 0.0
    }
}
