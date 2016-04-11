//
//  UIViewController+LoadingIndicatorView.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/11/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit

private var xoLoadingViewAssociationKey: UInt8 = 0
private var xoLoadingIndicatorAssociationKey: UInt8 = 10

extension UIViewController {
    var loadingView : UIView? {
        get {
            return objc_getAssociatedObject(self, &xoLoadingViewAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoLoadingViewAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var loadingIndicator : UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &xoLoadingIndicatorAssociationKey) as? UIActivityIndicatorView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoLoadingIndicatorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func showLoadingIndicator() {
        if (loadingView != nil) {
            let currentWindow = UIApplication.sharedApplication().keyWindow
            currentWindow?.addSubview(loadingView!)
            loadingView!.hidden = false
            
        } else {
            self.createLoadingView()
        }
        self.loadingIndicator?.startAnimating()
    }
    
    func hideLoadingIndicator() {
        if (self.loadingView != nil) {
            self.loadingView!.removeFromSuperview()
            self.loadingView!.hidden = true
        }
        
        self.loadingIndicator?.stopAnimating()
    }
    
    private func createLoadingView() {
        loadingView = UIView()
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let frame : CGRect = (appDelegate.window?.frame != nil) ? appDelegate.window!.frame : self.view.frame
        
        loadingView?.frame = frame
        loadingView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        let currentWindow = UIApplication.sharedApplication().keyWindow
        currentWindow?.addSubview(loadingView!)
        loadingView!.hidden = false
        
        loadingIndicator = UIActivityIndicatorView()
        loadingIndicator!.center = self.view.center
        loadingIndicator?.hidesWhenStopped = true
        loadingIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.loadingView?.addSubview(self.loadingIndicator!)
        
    }
}