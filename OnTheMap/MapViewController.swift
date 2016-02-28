//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 12/12/15.
//  Copyright © 2015 Sergey Prybysh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

   
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        refreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        refreshData()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "map_pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                let isOpened = app.openURL(NSURL(string: toOpen)!)
                if !isOpened {
                    showAlertWithText("Invalid URL", message: "\(toOpen) is invalid. Try to use format: http://host.com")
                }
            }
        }
    }
    
    func updateAnnotations() {
        var annotations = [MKPointAnnotation]()
        let studentLocations = StudentLocationData.studentLocations
        for student in studentLocations {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    func refreshData() {
        OTMClient.sharedInstance().getStudentLocations(){ (studentLocations, error) in
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlertWithText("Try again later", message: (error?.localizedDescription)!)
                })
                return
            }
            if let locationsArray = studentLocations  {
                dispatch_async(dispatch_get_main_queue(), {
                    StudentLocationData.studentLocations = locationsArray
                    self.updateAnnotations()
                 })
            }
        }
    }
    func showAlertWithText(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

