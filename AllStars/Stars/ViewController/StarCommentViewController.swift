//
//  AddCommentViewController.swift
//  AllStars
//
//  Created by Gianfranco Yosida on 4/22/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import Foundation
import UIKit
import UITextView_Placeholder

class StarCommentViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var commentTextView: UITextView!
    
    var recommendDelegate: RecommendDelegate!
    var commentText: String?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    //MARK: - Private
    
    private func initViews() {
        if let commentText = commentText {
            commentTextView.text = commentText
        }
        commentTextView.placeholder = "Add a comment, up to 100 characters"
        commentTextView.delegate = self
    }
    
    //MARK: - UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            recommendDelegate.onCommentFilled(textView.text)
            return false
        }
        return true
    }
    
    
}
