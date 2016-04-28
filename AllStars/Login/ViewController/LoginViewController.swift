//
//  LoginViewController.swift
//  AllStars
//
//  Created by Rodrigo Gonzalez on 4/7/16.
//  Copyright © 2016 Belatrix. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let usernameTag = 100
    let passwordTag = 101
    
    var usernameEntered = false {
        didSet {
            enableLoginButton()
        }
    }
    
    var passwordEntered = false {
        didSet {
            enableLoginButton()
        }
    }
    
    let imageSize = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        
        if Utils.load(Utils.tokenKey).characters.count > 0 {
            navigationController?.navigationBarHidden = true
            let background = UIView(frame: view.frame)
            background.backgroundColor = .whiteColor()
            view.addSubview(background)
            animatedLogin()
        } else {
            let titleView = UIImageView(image: UIImage(named: "Belatrix-isotipo"))
            var frame = titleView.frame
            frame.size = CGSize(width: imageSize, height: imageSize)
            titleView.contentMode = .ScaleAspectFit
            titleView.frame = frame
            
            navigationItem.titleView = titleView
            
            view.backgroundColor = Utils.mainColor
            setupViews()
            setupLoginButton()
            loginButton.enabled = false
            usernameTextField.becomeFirstResponder()
        }
    }

    func animatedLogin() {
        let background = UIView(frame: view.frame)
        background.backgroundColor = Utils.mainColor
        
        let mask = CALayer()
        mask.contents = UIImage(named: "Belatrix-isotipo")!.CGImage
        mask.contentsGravity = kCAGravityResizeAspect
        mask.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mask.position = CGPoint(x: background.frame.size.width/2, y: background.frame.size.height/2 - mask.bounds.size.height/2)
        print(mask.position)
        background.layer.mask = mask
        
        view.addSubview(background)
        animateMask(mask)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            self.performSegueWithIdentifier("login", sender: nil)
        }
    }
    
    func animateMask(mask : CALayer) {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 1.2
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 0.3 //add delay of 0.3 second
        let initalBounds = NSValue(CGRect: mask.bounds)
        let secondBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: mask.bounds.width * 0.6, height: mask.bounds.height * 0.6))
        let thirdBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: mask.bounds.width * 1.3, height: mask.bounds.height * 1.3))
        let finalBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: view.bounds.width * 1.5, height: view.bounds.height * 1.5))
        keyFrameAnimation.values = [initalBounds, secondBounds, thirdBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0, 0.2, 0.3, 1.2]
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        mask.addAnimation(keyFrameAnimation, forKey: "bounds")
    }

    
    let offset = 15
    let textFieldHeight = 45
    
    func setupViews() {
        usernameTextField.tag = usernameTag
        passwordTextField.tag = passwordTag
        setupTextField(usernameTextField)
        setupTextField(passwordTextField)
        
        usernameTextField.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(offset)
            make.left.equalTo(self.view.snp_left).offset(offset)
            make.right.equalTo(self.view.snp_right).offset(-offset)
            make.height.equalTo(textFieldHeight)
        }
        
        passwordTextField.snp_makeConstraints { (make) in
            make.top.equalTo(usernameTextField.snp_bottom).offset(offset)
            make.left.equalTo(self.view.snp_left).offset(offset)
            make.right.equalTo(self.view.snp_right).offset(-offset)
            make.height.equalTo(textFieldHeight)
        }
        
        loginButton.snp_makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp_bottom).offset(offset)
            make.left.equalTo(self.view.snp_left).offset(offset)
            make.right.equalTo(self.view.snp_right).offset(-offset)
            make.height.equalTo(textFieldHeight)
        }
    }
    
    func setupTextField(textfield : UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textfield.leftView = paddingView
        textfield.leftViewMode = .Always
        
        textfield.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
       
        textfield.layer.borderWidth = 0.5
        textfield.layer.borderColor = UIColor.whiteColor().CGColor
        textfield.layer.cornerRadius = 3
        textfield.clipsToBounds = true

        textfield.textColor = .whiteColor()
        
        textfield.addTarget(self, action: #selector(textDidChange), forControlEvents: UIControlEvents.EditingChanged)
        
        textfield.delegate = self
    }
    
    func textDidChange(textfield : UITextField) {
        switch textfield.tag {
        case usernameTag :
            usernameEntered = textfield.text?.characters.count > 0
        case passwordTag :
            passwordEntered = textfield.text?.characters.count > 0
        default :
            // do nothing
            return
        }
    }
    
    func enableLoginButton() {
        loginButton.enabled = usernameEntered && passwordEntered
    }
    
    func setupLoginButton() {
        loginButton.tintColor = .whiteColor()
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.cornerRadius = 3
        loginButton.clipsToBounds = true

    }
    @IBAction func loginButtonAction(sender: AnyObject) {
        //do login stuff
        self.showLoadingIndicator()
        guard let username = usernameTextField.text, password = passwordTextField.text else {
            return
        }

        LoginService.login(username, password: password) { (response : AnyObject?, error : NSError?) -> Void in
            self.hideLoadingIndicator()
            
            if error != nil {
                print("error")
            } else if let token = (response as? NSDictionary)!["token"] as? String, let userId = (response as? NSDictionary)!["user_id"] as? UInt {
                
                Utils.save(token, key: Utils.tokenKey)
                Utils.save(String(userId), key: Utils.userIdKey)
                self.performSegueWithIdentifier("login", sender: nil)
            } else {
                print("error")
            }
        }
    }

    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField.tag {
        case usernameTag :
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTag :
            passwordTextField.resignFirstResponder()
            if loginButton.enabled {
                loginButtonAction(self)
            } else {
                usernameTextField.becomeFirstResponder()
            }
        default :
            // do nothing
            break
        }
        return true
    }
}
