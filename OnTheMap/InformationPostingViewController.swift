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
    
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var findOnMapButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var locationName: String? = nil
    
    var lat: Double? = nil
    
    var long: Double? = nil
    //TODO: impliment if/else for POST and PUT 
    @IBAction func tapSubmitButton(sender: AnyObject) {
        
        let text = linkTextField.text
        guard (text != "") else {
            showAlertWithText("Link Field Is Empty", message: "Please, enter URL here")
            return
        }
        
        applicationDelegate.userOnTheMap.mapString = locationName!
        applicationDelegate.userOnTheMap.mediaURL = text
        applicationDelegate.userOnTheMap.latitude = lat!
        applicationDelegate.userOnTheMap.longitude = long!
        if applicationDelegate.userOnTheMap.objectId == nil {
            OTMClient.sharedInstance().postStudentLocation(applicationDelegate.userOnTheMap) { (objectId, error) in
            guard error == nil else {
                print(error)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.applicationDelegate.userOnTheMap.objectId = objectId
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            })
          }
        }
        else {
            OTMClient.sharedInstance().updateStudentLocation(applicationDelegate.userOnTheMap) { (success, error) in
                guard error == nil else {
                    print(error)
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func tapFinfOnMapButton(sender: AnyObject) {
        
        let text = locationTextField.text
        guard (text != "") else {
            showAlertWithText("Location Field Is Empty", message: "Please, enter location here")
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(text!) { (placemark, error) in
            guard error == nil else {
                dispatch_async(dispatch_get_main_queue(), {
                self.showAlertWithText("Try Again", message: "Unable to get location")})
                return
            }
            self.setUpMap(placemark!)
            self.displayMapMode()
        }
    }
    
    @IBAction func tapCancelButton(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        linkTextField.delegate = self
        setUpSubViews()
        displayLocationMode()
    }
    
    func displayLocationMode() {
        whereStudyingLable.hidden = false
        mapView.hidden = true
        linkTextField.hidden = true
        submitButton.hidden = true
    }
    func displayMapMode() {
        whereStudyingLable.hidden = true
        locationTextField.hidden = true
        buttomView.alpha = 0.2
        findOnMapButton.hidden = true
        mapView.hidden = false
        linkTextField.hidden = false
        topView.backgroundColor = UIColor.darkBlue()
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton.hidden = false
    }
    
    func setUpSubViews() {
        topView.backgroundColor = UIColor.lightGrayColor()
        buttomView.backgroundColor = UIColor.lightGrayColor()
        view.backgroundColor = UIColor.darkBlue()
        
        findOnMapButton.backgroundColor = UIColor.whiteColor()
        findOnMapButton.setTitleColor(UIColor.darkBlue(), forState: .Normal)
        setButtonCorner(findOnMapButton)
        
        submitButton.setTitleColor(UIColor.darkBlue(), forState: .Normal)
        submitButton.backgroundColor = UIColor.whiteColor()
        setButtonCorner(submitButton)
        
        locationTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Location Here", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Enter a Link to Share Here", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func setButtonCorner(button: UIButton){
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
    }
    
    func setUpMap(location: [CLPlacemark]){
        let placemark = MKPlacemark(placemark: location[0])
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        
        locationName = placemark.name!
        
        lat = annotation.coordinate.latitude
        long = annotation.coordinate.longitude
        let pin = CLLocationCoordinate2DMake(lat!, long!)
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(pin, span)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
            self.mapView.regionThatFits(region)
        })
    }
    
    func showAlertWithText(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension UIColor {
    
    class func darkBlue() -> UIColor {
        return UIColor(red:0/255, green:64/255, blue:128/255, alpha:1.0)
    }
}
