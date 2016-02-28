 //
//  TableViewController.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 12/12/15.
//  Copyright © 2015 Sergey Prybysh. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationData.studentLocations.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: OTMTableViewCell = tableView.dequeueReusableCellWithIdentifier("table_view_cell") as! OTMTableViewCell
        let pinImage = UIImage(named: "pin")
        let student = StudentLocationData.studentLocations[indexPath.row]
        cell.studentsName.text = (student.firstName + " " + student.lastName)
        cell.imageView?.image = pinImage
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = StudentLocationData.studentLocations[indexPath.row]
        if let url = NSURL(string: student.mediaURL) {
            let isOpened = UIApplication.sharedApplication().openURL(url)
            if !isOpened {
            showAlertWithText("Invalid URL", message: "\(url) is invalid. Try to use format: http://host.com")
           }
        }
        else{
            showAlertWithText("Invalid URL", message: "This user did not provide any URL")
        }
    }
    
    func refreshData() {
        OTMClient.sharedInstance().getStudentLocations(){ (studentLocations, error) in
            if let locationsArray = studentLocations  {
                dispatch_async(dispatch_get_main_queue(), {
                    StudentLocationData.studentLocations = locationsArray
                    self.tableView.reloadData()
                })
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: error!.localizedDescription, message: "Try again later", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
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

