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
        
    }
    
    func pinAction() {
        let infoPostingVC = self.storyboard!.instantiateViewControllerWithIdentifier("informationPostingVC") as! InformationPostingViewController
        presentViewController(infoPostingVC, animated: true, completion: nil)
    }
}