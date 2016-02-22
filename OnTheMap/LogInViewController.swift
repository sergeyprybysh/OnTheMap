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
    
    let application = UIApplication.sharedApplication()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
    }
    
       @IBAction func tapLogInButton(sender: AnyObject) {
        let logIn = logInTextField.text
        
        guard (logIn != "") else {
            showAlertWithText("Field Is Empty", message: "Please, enter username here")
            return
        }
        let password = passwordTextField.text
        guard (password != "") else {
            showAlertWithText("Field Is Empty", message: "Please, enter password here")
            return
        }
        
        OTMClient.sharedInstance().getSessionToken(logIn!, password: password!){(success, data, error) in
            if success {
                self.appDelegate.userOnTheMap.uniqueKey = data![OTMClient.JSONResponseKeys.accountKey] as? String
                self.appDelegate.sessionID = data![OTMClient.JSONResponseKeys.sessionId] as? String
                OTMClient.sharedInstance().getUserDetails(self.appDelegate.userOnTheMap) { (results, error) in
                    if let data = results {
                        self.appDelegate.userOnTheMap.firstName = data[OTMClient.JSONResponseKeys.firstName] as? String
                        self.appDelegate.userOnTheMap.lastName = data[OTMClient.JSONResponseKeys.lastName] as? String
                        self.launchMapViewController()
                    }
                    else {
                        print(error)
                    }
                }
            }
            else {
                if let statusCode = error![OTMClient.Constants.statusCodeError] {
                    let code = statusCode as! Int
                    if code >= 400 && code <= 499 {
                        dispatch_async(dispatch_get_main_queue(), {
                        self.showAlertWithText("Invalid Credentials", message: "Your Username or Password is invalid")
                        })
                    }
                    else if code >= 500 && code <= 599 {
                        dispatch_async(dispatch_get_main_queue(), {
                        self.showAlertWithText("Try Again Later", message: "There was a problem to connect to the server")
                        })
                    }
                    else {
                        print(error)
                    }                    
                }
                else{
                    print(error)
                }
            }
        }
    }
    
    @IBAction func tapSignUpButton(sender: AnyObject) {
        let targetURL = NSURL(string: OTMClient.Constants.udacitySignInURL)
        application.openURL(targetURL!)
    }
    
    func setUpSubviews() {
        logInButton.backgroundColor = UIColor.redColor()
        logInButton.layer.cornerRadius = 7
        logInButton.clipsToBounds = true
        
        let paddingLogIn = UIView(frame: CGRectMake(0, 0, 15, logInTextField.frame.size.height))
        logInTextField.leftView = paddingLogIn
        logInTextField.leftViewMode = UITextFieldViewMode .Always
        let paddingPassword = UIView(frame: CGRectMake(0, 0, 15, passwordTextField.frame.height))
        passwordTextField.leftView = paddingPassword
        passwordTextField.leftViewMode = UITextFieldViewMode .Always
        
        navigationController?.navigationBarHidden = true
        
        logInTextField.attributedPlaceholder = NSAttributedString(string: OTMClient.AppConstants.email, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        logInTextField.textColor = UIColor.grayColor()
        
        passwordTextField.secureTextEntry = true
        passwordTextField.attributedPlaceholder = NSAttributedString(string: OTMClient.AppConstants.password, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func launchMapViewController() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("main_nav_controller") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func showAlertWithText(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}