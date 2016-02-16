//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 1/10/16.
//  Copyright © 2016 Sergey Prybysh. All rights reserved.
//

import Foundation

extension OTMClient {
        
    func getSessionToken(logIn: String, password: String, completionHandler: (sussess: Bool, error: String?)-> Void){
        let baseURL = Constants.udacitySessionHost
        let body = setUpBodySessionToken(logIn, password: password)
        let headers = ["Accept" : "application/json", "Content-Type" : "application/json"]
        var parsedJson: AnyObject!
        taskForPOSTMethod(baseURL,headers: headers, body: body!) { (result, error) -> Void in
            guard (error == nil) else {
                completionHandler(sussess: false, error: error?.description)
                return
            }
            parsedJson = OTMClient.parseJSONForUdacitySession(result)
            if let sessionJson = parsedJson[OTMClient.JSONResponseKeys.sessionObject]{
                if let sID = sessionJson![OTMClient.JSONResponseKeys.sessionId] {
                    self.sessionToken = (sID as! String)
                    completionHandler(sussess: true, error: nil)
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
    
    func getStudentLocations(completionHandler: (locations: [StudentLocation]?, error: String?) -> Void) {
        
        let baseURL = Constants.parseStudentLocationsHost
        let parametrs = ["limit" : "100"]
        let headers = ["X-Parse-Application-Id" : Constants.parseApplicationID, "X-Parse-REST-API-Key" : Constants.apiKey]
        
        taskForGetMethod(baseURL, parameters: parametrs, headers: headers) { (results, error) -> Void in
            guard (error == nil) else {
                completionHandler(locations: nil, error: error?.description)
                return
            }
            if let locations = results[OTMClient.JSONResponseKeys.resultsStudentLocations] {
                let studentLocations = self.convertDataToStudentLocationObject(locations as! [[String : AnyObject]])
                completionHandler(locations: studentLocations, error: nil)
            }
            else {
                completionHandler(locations: nil, error: "Failed to get Student Locations")
            }
        }
    }
    
    func postStudentLocation(user: OnTheMapUser, completionHandler: (objectId: String?, error: String?) -> Void) {
        let baseUrl = Constants.parseStudentLocationsHost
        
        let headers = ["X-Parse-Application-Id" : Constants.parseApplicationID, "X-Parse-REST-API-Key" : Constants.apiKey, "Content-Type" : "application/json"]
        
        let body = NSMutableDictionary()
        body.setValue(user.uniqueKey, forKey: OTMClient.JSONResponseKeys.uniqueKey)
        body.setValue(user.firstName, forKey: OTMClient.JSONResponseKeys.firstName)
        body.setValue(user.lastName, forKey: OTMClient.JSONResponseKeys.lastName)
        body.setValue(user.mapString, forKey: OTMClient.JSONResponseKeys.mapString)
        body.setValue(user.mediaURL, forKey: OTMClient.JSONResponseKeys.mediaURL)
        body.setValue(user.latitude, forKey: OTMClient.JSONResponseKeys.latitude)
        body.setValue(user.longitude, forKey: OTMClient.JSONResponseKeys.longitude)
        
        let jsonData: NSData?
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions())
        }
        catch{
            print("Serialization Error")
            jsonData = nil
            completionHandler(objectId: nil, error: "Serialization Error")
        }
        
        taskForPOSTMethod(baseUrl, headers: headers, body: jsonData!) { (result, error) in
            guard (error == nil) else {
                completionHandler(objectId: nil, error: error?.description)
                return
            }
            let jsonResult = OTMClient.parseJSON(result)
            if let objectID = jsonResult[OTMClient.JSONResponseKeys.objectId]{
                completionHandler(objectId: objectID as? String, error: nil)
            }
            else {
                completionHandler(objectId: nil, error: "Failed to parce ObjectId")
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
