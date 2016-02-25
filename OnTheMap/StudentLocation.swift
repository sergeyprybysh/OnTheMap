//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 1/23/16.
//  Copyright © 2016 Sergey Prybysh. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var createdAt : String
    var firstName : String
    var lastName  : String
    var latitude  : Double
    var longitude : Double
    var mapString : String
    var mediaURL  : String
    var objectId  : String
    var uniqueKey : String
    var updatedAt : String
    
    init (userDictionary: [String : AnyObject]) {
        self.firstName = userDictionary["firstName"] as! String!
        self.lastName = userDictionary["lastName"] as! String!
        self.createdAt = userDictionary["createdAt"] as! String!
        self.mapString = userDictionary["mapString"] as! String!
        self.mediaURL = userDictionary["mediaURL"] as! String!
        self.objectId = userDictionary["objectId"] as! String!
        self.uniqueKey = userDictionary["uniqueKey"] as! String!
        self.updatedAt = userDictionary["updatedAt"] as! String!
        self.latitude = userDictionary["latitude"] as! Double!
        self.longitude = userDictionary["longitude"] as! Double!
    }
}