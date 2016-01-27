//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 1/10/16.
//  Copyright © 2016 Sergey Prybysh. All rights reserved.
//

import Foundation

extension OTMClient {
    struct Constants {
        static let udacitySessionHost = "https://www.udacity.com/api/session"
        static let udacitySignInURL = "https://www.udacity.com/account/auth#!/signin"
        static let parseStudentLocationsHost = "https://api.parse.com/1/classes/StudentLocation"

        // MARK: API Key and App ID
        static let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    struct JSONResponseKeys {
        static let sessionId = "id"
        static let sessionObject = "session"
        
        //MARK: Student Locations JSON
        static let resultsStudentLocations = "results"
        static let createdAt = "createdAt"
        static let firstName  = "firstName"
        static let lastName  = "lastName"
        static let latitude  = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL  = "mediaURL"
        static let objectId  = "objectId"
        static let uniqueKey = "uniqueKey"
        static let updatedAt = "updatedAt"
    }
            
}