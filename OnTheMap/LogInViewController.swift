//
//  LogInViewController.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 12/12/15.
//  Copyright © 2015 Sergey Prybysh. All rights reserved.
//

import UIKit
import Foundation

class LogInViewController: UIViewController {
    
  
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logInTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpTextField: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
    }
    
       @IBAction func tapLogInButton(sender: AnyObject) {
        let logIn = logInTextField.text
        let password = passwordTextField.text
        OTMClient.sharedInstance().getSessionToken(logIn!, password: password!){(success, error) in
            if success {
                self.launchMapViewController()
            }
            else {
                print(error)
            }
        }
    }
    
    @IBAction func tapSignUpButton(sender: AnyObject) {
        let targetURL = NSURL(string: OTMClient.Constants.udacitySignInURL)
        UIApplication.sharedApplication().openURL(targetURL!)
    }
    
    func setUpSubviews() {
        
        logInButton.backgroundColor = UIColor.redColor()
        
        logInTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        
        passwordTextField.secureTextEntry = true
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        
    }
    
    func launchMapViewController() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("main_nav_controller") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
}