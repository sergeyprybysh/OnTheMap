//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 1/30/16.
//  Copyright © 2016 Sergey Prybysh. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var whereStudyingLable: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
   
    @IBOutlet weak var buttomView: UIView!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var findOnMapButton: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBAction func tapFinfOnMapButton(sender: AnyObject) {
    }
    
    @IBAction func tapCancelButton(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubViews()
        enterLocationMode()
    }
    
    func enterLocationMode() {
        mapView.hidden = true
    }
    
    func setUpSubViews() {
        topView.backgroundColor = UIColor.lightGrayColor()
        buttomView.backgroundColor = UIColor.lightGrayColor()
        view.backgroundColor = UIColor.darkBlue()
        
       
        findOnMapButton.backgroundColor = UIColor.whiteColor()
        roundButtonCorner(findOnMapButton)
        
        locationTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Location Here", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func roundButtonCorner(button: UIButton){
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
    }
}

extension UIColor {
    
    class func darkBlue() -> UIColor {
        return UIColor(red:0/255, green:64/255, blue:128/255, alpha:1.0)
    }
}
