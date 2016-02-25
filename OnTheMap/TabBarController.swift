//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 1/30/16.
//  Copyright © 2016 Sergey Prybysh. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
    }
    
    func setUpViews() {
        let pinImage = UIImage(named: "pin")
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshData")
        let logOutButton = UIBarButtonItem(title: OTMClient.AppConstants.logOutButtonLable, style: .Plain, target: self, action: "logOutAction")
        let pinButton = UIBarButtonItem(image: pinImage, style: .Plain, target: self, action: "pinAction")
        
        navigationItem.title = OTMClient.AppConstants.navigationItemTitle
        
        let righButtonItem = [refreshButton, pinButton]
        navigationItem.rightBarButtonItems = righButtonItem
        navigationItem.leftBarButtonItem = logOutButton
    }
    
    func refreshData() {
        if selectedIndex == 0 {
          let mapViewControllet = self.viewControllers![0] as! MapViewController
            mapViewControllet.refreshData()
        }
        else if selectedIndex == 1 {
          let tableViewController = self.viewControllers![1] as! TableViewController
            tableViewController.refreshData()
        }
    }
    
    func logOutAction() {

        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to Log Out?", preferredStyle: UIAlertControllerStyle.Alert)
        let overwriteAction = UIAlertAction(title: "Log Out", style: .Default) {(action) in
            self.userLogOut()
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(overwriteAction)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func userLogOut() {
        OTMClient.sharedInstance().deleteSession() { (success, error) in
            if success{
                dispatch_async(dispatch_get_main_queue(), {
                    let logInVC = self.storyboard!.instantiateViewControllerWithIdentifier("logInVC") as! LogInViewController
                    self.presentViewController(logInVC, animated: true, completion: nil)
                })
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlertWithText("Log Out Error", message: "There was an error during Log Out. Please, try again later")
                })
            }
        }
    }
    
    func pinAction() {
        if OTMClient.sharedInstance().userOnTheMap.objectId != nil {
            showAlertWithText("Overwrite Location?", message: "Would you like to overwrite your current location?")
        }
        else {
            OTMClient.sharedInstance().queryingForStudentLocation(OTMClient.sharedInstance().userOnTheMap.uniqueKey!){
                (success, objectId, error) in
                guard (error == nil) else {
                    print(error)
                    return
                }
                if let id = objectId {
                    OTMClient.sharedInstance().userOnTheMap.objectId = id
                    dispatch_async(dispatch_get_main_queue(), {
                    self.showAlertWithText("Overwrite Location?", message: "Would you like to overwrite your current location?")
                    })
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentPostingVC()
                    })
                }
            }
        }
    }
    
    func presentPostingVC() {
        let infoPostingVC = self.storyboard!.instantiateViewControllerWithIdentifier("informationPostingVC") as! InformationPostingViewController
        presentViewController(infoPostingVC, animated: true, completion: nil)
    }
    
    func showAlertWithText(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .Default) {(action) in
            self.presentPostingVC()
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(overwriteAction)
        dispatch_async(dispatch_get_main_queue(), {
        self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}