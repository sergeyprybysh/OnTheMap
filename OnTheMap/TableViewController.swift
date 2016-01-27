//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 12/12/15.
//  Copyright © 2015 Sergey Prybysh. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var studentLocations: [StudentLocation]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        studentLocations = applicationDelegate.studentArray
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: OTMTableViewCell = tableView.dequeueReusableCellWithIdentifier("table_view_cell") as! OTMTableViewCell
        let student = studentLocations[indexPath.row]
        cell.studentsName.text = (student.firstName + " " + student.lastName)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = studentLocations[indexPath.row]
        let urlString = NSURL(string: student.mediaURL)
        if let url = urlString{
            UIApplication.sharedApplication().openURL(url)
        }
        else {
            print("Invalid URL provided")
        }
    }
    
    


}

