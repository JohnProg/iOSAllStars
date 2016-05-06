//
//  CategoriesTableViewController.swift
//  AllStars
//
//  Created by Gianfranco Yosida on 4/25/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import Foundation
import UIKit

class CategoriesTableViewController: UITableViewController {
    
    static let categoryCell = "categoryCell"
    static let categoriesTableVC = "categoriesTableVC"
    
    var parentCategory: Category?
    var categories: [Category]!
    var recommendDelegate: RecommendDelegate!
    var isSubcategory: Bool {
        get {
            return parentCategory != nil
        }
    }
    
    // MARK: - Private
    
    private func fetchAndDisplaySubcategories(category: Category) {
        showLoadingIndicator()
        CategoryService.getSubcategoryList(category.pk!) { (subcategories, error) in
            self.hideLoadingIndicator()
            if error == nil {
                let subcategoriesVC = self.storyboard?.instantiateViewControllerWithIdentifier(CategoriesTableViewController.categoriesTableVC) as! CategoriesTableViewController
                subcategoriesVC.parentCategory = category
                subcategoriesVC.categories = subcategories
                subcategoriesVC.recommendDelegate = self.recommendDelegate
                self.navigationController?.pushViewController(subcategoriesVC, animated: true)
            }
        }
    }
    
    // MARK - TableViewDelegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCellWithIdentifier(CategoriesTableViewController.categoryCell, forIndexPath: indexPath)
        let category = categories[indexPath.item]
        categoryCell.textLabel?.text = category.name
        return categoryCell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let category = categories[indexPath.item]
        if isSubcategory {
            category.parentCategory = parentCategory!
            recommendDelegate.onSubcategorySelected(category)
        } else {
            fetchAndDisplaySubcategories(category)
        }
    }
    
}
