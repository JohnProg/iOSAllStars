//
//  RankingViewController.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/28/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

class RankingViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top Rated"
        
        let tabPageViewController = TabPageViewController.create()
        
        let thisMonthVC = RankingTableViewController()
        thisMonthVC.yOffset = TabPageOption().tabHeight
        thisMonthVC.kind = .CurrentMonthScore
        
        let lastMonthVC = RankingTableViewController()
        lastMonthVC.yOffset = TabPageOption().tabHeight
        lastMonthVC.kind = .LastMonthScore
        
        let allTimeVC = RankingTableViewController()
        allTimeVC.yOffset = TabPageOption().tabHeight
        allTimeVC.kind = .Score
        
        tabPageViewController.tabItems = [(thisMonthVC, "This month"), (lastMonthVC, "Last month"), (allTimeVC, "All time")]
        
        var option = TabPageOption()
        option.tabWidth = view.frame.width / CGFloat(tabPageViewController.tabItems.count)
        option.currentColor = Utils.mainColor
        tabPageViewController.option = option

        tabBarController?.tabBar.translucent = false
        navigationController?.navigationBar.translucent = false
        navigationController?.viewControllers = [tabPageViewController]
    }
}