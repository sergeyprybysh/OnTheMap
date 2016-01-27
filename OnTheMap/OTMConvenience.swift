//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 1/10/16.
//  Copyright © 2016 Sergey Prybysh. All rights reserved.
//

import Foundation

extension OTMClient {
        
    func getSessionToken(logIn: String, password: String, completionHandler: (sussess: Bool, error: String)-> Void){
        let baseURL = Constants.udacitySessionHost
        let body = setUpBodySessionToken(logIn, password: password)
        var parsedJson: AnyObject!
        taskForPOSTMethod(baseURL, body: body!) { (result, error) -> Void in
            parsedJson = OTMClient.parseJSONForUdacitySession(result)
            if let sessionJson = parsedJson[OTMClient.JSONResponseKeys.sessionObject]{
                if let sID = sessionJson![OTMClient.JSONResponseKeys.sessionId] {
                    self.sessionToken = (sID as! String)
                    completionHandler(sussess: true, error: "No error")
                }
                else{
                    completionHandler(sussess: false, error: "Failed to parce Session Id")
                }
            }
            else{
                completionHandler(sussess: false, error: "Failed to parce Session Object")
            }
        }
    }
    
    private func setUpBodySessionToken(logIn: String, password: String) -> NSData? {
        let creds : NSMutableDictionary = NSMutableDictionary()
        creds.setValue(logIn, forKey: "username")
        creds.setValue(password, forKey: "password")
        
        let para : NSMutableDictionary = NSMutableDictionary()
        para.setValue(creds, forKey: "udacity")
        
        let jsonData: NSData
        do{
            jsonData = try NSJSONSerialization.dataWithJSONObject(para, options: NSJSONWritingOptions())
            return jsonData
        } catch _ {
            print ("Serialization Error")
            return nil
        }
    }
    
    func getStudentLocations(completionHandler: (locations: [StudentLocation]?, error: String?) -> Void) {
        
        let baseURL = Constants.parseStudentLocationsHost
        
        let parametrs = ["limit" : "100"]
        
        let headers = ["X-Parse-Application-Id" : Constants.parseApplicationID, "X-Parse-REST-API-Key" : Constants.apiKey]
        
        
        taskForGetMethod(baseURL, parameters: parametrs, headers: headers) { (results, error) -> Void in
            if let locations = results[OTMClient.JSONResponseKeys.resultsStudentLocations] {
                let studentLocations = self.convertDataToStudentLocationObject(locations as! [[String : AnyObject]])
                completionHandler(locations: studentLocations, error: nil)
            }
            else {
                completionHandler(locations: nil, error: "Failed to get Student Locations")
            }
        }
    }
    
    private func convertDataToStudentLocationObject(data: [[String : AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        for studentObject in data {
            let location = StudentLocation(firstName: studentObject[OTMClient.JSONResponseKeys.firstName] as! String,
                lastName : studentObject[OTMClient.JSONResponseKeys.lastName] as! String,
                createdAt : studentObject[OTMClient.JSONResponseKeys.createdAt] as! String,
                mapString : studentObject[OTMClient.JSONResponseKeys.mapString] as! String,
                mediaURL : studentObject[OTMClient.JSONResponseKeys.mediaURL] as! String,
                objectId : studentObject[OTMClient.JSONResponseKeys.objectId] as! String,
                uniqueKey : studentObject[OTMClient.JSONResponseKeys.uniqueKey] as! String,
                updatedAt : studentObject[OTMClient.JSONResponseKeys.updatedAt] as! String,
                latitude : studentObject[OTMClient.JSONResponseKeys.latitude] as! Double,
                longitude : studentObject[OTMClient.JSONResponseKeys.longitude] as! Double)
            studentLocations.append(location)
        }
        return studentLocations
    }
}
