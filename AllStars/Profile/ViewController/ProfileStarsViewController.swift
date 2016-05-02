//
//  ProfileStarsViewController.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 5/2/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

class ProfileStarsViewController: UITableViewController {

    var employeeStar : EmployeeStar!
    var userId : UInt!
    
    var employeeStarSubcategory : [Star]? {
        didSet {
            createCellHeightsArray()
            tableView.reloadData()
        }
    }
    let kCloseCellHeight: CGFloat = 96
    let kOpenCellHeight: CGFloat = 256

    var cellHeights = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingIndicator()
        StarService.employeeStarSubcategoryList(userId!, subcategoryId: employeeStar.pk!) { (employeeStar, error) in
            self.hideLoadingIndicator()
            if error == nil {
                self.employeeStarSubcategory = employeeStar
            }
        }
        
        tableView.backgroundColor = .orangeColor()
    }
    
    // MARK: configure
    func createCellHeightsArray() {
        guard let employeeStarSubcategory = self.employeeStarSubcategory where employeeStarSubcategory.count > 0 else {
            return
        }
        
        for _ in employeeStarSubcategory {
            cellHeights.append(kCloseCellHeight)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeStarSubcategory != nil ? employeeStarSubcategory!.count : 0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell is ProfileStarViewCell {
            let foldingCell = cell as! ProfileStarViewCell
            foldingCell.backgroundColor = UIColor.clearColor()
            
            if cellHeights[indexPath.row] == kCloseCellHeight {
                foldingCell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                foldingCell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileStarCell", forIndexPath: indexPath) as! ProfileStarViewCell
        
        if let star = employeeStarSubcategory?[indexPath.row] {
            cell.setInfo(star)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ProfileStarViewCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
    }
}
