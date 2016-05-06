//
//  RecommendTableViewController.swift
//  AllStars
//
//  Created by Gianfranco Yosida on 4/21/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import Foundation
import UIKit
import UITextView_Placeholder

class GiveStarTableViewController: UITableViewController, GiveStarDelegate {
    
    static let commentSegue = "commentSegue"
    static let categoriesSegue = "categoriesSegue"
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    let loggedInUserPk = UInt(Utils.load(Utils.userIdKey))!
    var user: User!
    var categories: [Category]?
    var comment: String? {
        didSet {
            dismissOnTopVCAndEnableDoneButton()
        }
    }
    var subcategory: Category? {
        didSet {
            dismissOnTopVCAndEnableDoneButton()
        }
    }
    var keyword: Keyword? {
        didSet {
            dismissOnTopVCAndEnableDoneButton()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        // TODO: delete this line when keyword is dinamically selected
        keyword = Keyword(pk: 1, name: "PHP", numStars: 3)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == GiveStarTableViewController.commentSegue {
            let commentVC = segue.destinationViewController as! StarCommentViewController
            setUpCommentVC(commentVC)
        } else if segue.identifier == GiveStarTableViewController.categoriesSegue {
            let categoriesVC = segue.destinationViewController as! CategoriesTableViewController
            setUpCategoriesVC(categoriesVC)
        } else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
    // MARK: - Private
    
    private func initViews() {
        navigationItem.title = "Recommendation"
        userNameLabel.text = user.displayName()
        doneBarButtonItem.enabled = false
    }
    
    private func dismissOnTopVCAndEnableDoneButton() {
        navigationController?.popToRootViewControllerAnimated(true)
        if let safeSubcategory = subcategory {
            guard let commentRequired = safeSubcategory.parentCategory?.commentRequired else {
                return
            }
            let isCommentValid = !commentRequired || (comment != nil && !comment!.isEmpty)
            doneBarButtonItem.enabled = keyword != nil && isCommentValid
        }
    }
    
    private func setUpCategoriesVC(categoriesVC: CategoriesTableViewController) {
        categoriesVC.giveStarDelegate = self
        categoriesVC.categories = categories
    }
    
    private func setUpCommentVC(commentVC: StarCommentViewController) {
        commentVC.giveStarDelegate = self
        if let comment = comment {
            if !comment.isEmpty {
                commentVC.commentText = comment
            }
        }
    }
    
    private func fetchAndDisplayCategories() {
        showLoadingIndicator()
        UserService.getEmployeeCategoryList(loggedInUserPk) { (categories, error) in
            self.hideLoadingIndicator()
            if error == nil {
                self.categories = categories
                self.performSegueWithIdentifier(GiveStarTableViewController.categoriesSegue, sender: nil)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func donePressed(sender: UIBarButtonItem) {
        showLoadingIndicator()
        StarService.giveStar(loggedInUserPk, toId: user.pk!, subcategory: subcategory!, keyword: keyword!,comment: comment, onCompletion: { (succed, error) in
            self.hideLoadingIndicator()
            if error == nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.item {
        case 1:
            performSegueWithIdentifier(GiveStarTableViewController.commentSegue, sender: nil)
        case 2:
            fetchAndDisplayCategories()
        default:
            break
        }
    }
    
    // MARK: - RecommendDelegate
    
    func onCommentFilled(comment: String) {
        self.comment = comment
        commentLabel.text = comment
        tableView.reloadData()
    }
    
    func onSubcategorySelected(subcategory: Category) {
        self.subcategory = subcategory
        categoryLabel.text = subcategory.name
        tableView.reloadData()
    }
    
    func onKeywordSelected(keyword: Keyword) {
        self.keyword = keyword
        keywordLabel.text = keyword.name
        tableView.reloadData()
    }
    
}

protocol GiveStarDelegate : class {
    
    func onCommentFilled(comment: String)
    func onSubcategorySelected(subcategory: Category)
    func onKeywordSelected(keyword: Keyword);
    
}