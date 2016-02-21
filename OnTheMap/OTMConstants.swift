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
        static let udacityUserURL = "https://www.udacity.com/api/users"
        static let udacitySignInURL = "https://www.udacity.com/account/auth#!/signin"
        static let parseStudentLocationsHost = "https://api.parse.com/1/classes/StudentLocation"

        // MARK: API Key and App ID
        static let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let statusCodeError = "statusCode"
        static let messageError = "message"
    }
    struct JSONResponseKeys {
        static let sessionId = "id"
        static let sessionObject = "session"
        static let account = "account"
        static let accountKey = "key"
        
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
    
    struct AppConstants {
        static let logOutButtonLable = "Logout"
        static let navigationItemTitle = "On The Map"
        static let email = "Email"
        static let password = "Password"
    }
            
}