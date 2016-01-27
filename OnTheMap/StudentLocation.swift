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
    
    init (firstName : String, lastName  : String, createdAt : String, mapString : String, mediaURL  : String, objectId  : String, uniqueKey : String, updatedAt : String, latitude  : Double, longitude : Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.createdAt = createdAt
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
        self.latitude = latitude
        self.longitude = longitude
    }
}