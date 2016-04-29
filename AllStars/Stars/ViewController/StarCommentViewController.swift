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
    
    static let maxLength = 100
    
    @IBOutlet weak var commentTextView: UITextView!
    
    weak var recommendDelegate: RecommendDelegate?
    var commentText: String?
    var commentEntered = false {
        didSet {
            doneButton?.enabled = commentEntered
        }
    }
    var doneButton : UIBarButtonItem?
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        initViews()
        doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
        commentEntered = commentTextView.text.characters.count > 0
    }
    
    func doneButtonTapped() {
        recommendDelegate?.onCommentFilled(commentTextView.text)
    }
    
    //MARK: - Private
    
    private func initViews() {
        if let commentText = commentText {
            commentTextView.text = commentText
        }
        commentTextView.placeholder = "Add a comment, up to \(StarCommentViewController.maxLength) characters"
        commentTextView.delegate = self
        commentTextView.becomeFirstResponder()
    }

    func textViewDidChange(textView: UITextView) {
        commentEntered = textView.text.characters.count > 0
    }
    
    //MARK: - UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let charactersCount = textView.text.characters.count + (text.characters.count - range.length)
        if charactersCount > StarCommentViewController.maxLength && text != "\n" {
            return false
        }
        if text == "\n" {
            if commentEntered {
                recommendDelegate?.onCommentFilled(textView.text)
            }
            return false
        }
        return true
    }
    
}
