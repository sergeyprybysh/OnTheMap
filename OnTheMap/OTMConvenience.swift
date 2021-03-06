//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 1/10/16.
//  Copyright © 2016 Sergey Prybysh. All rights reserved.
//

import Foundation

extension OTMClient {
        
    func getSessionToken(logIn: String, password: String, completionHandler: (sussess: Bool, results: [String : AnyObject]?, error: NSError?)-> Void){
        let baseURL = Constants.udacitySessionHost
        let body = setUpBodySessionToken(logIn, password: password)
        let headers = ["Accept" : "application/json", "Content-Type" : "application/json"]
        var parsedJson: AnyObject!
        taskForPOSTMethod(baseURL,headers: headers, body: body!) { (result, error) -> Void in
            guard (error == nil) else {
                completionHandler(sussess: false, results: nil, error: error)
                return
            }
            parsedJson = OTMClient.parseJSONForUdacitySession(result!)
            var data = [String: AnyObject]()
            if let sessionJson = parsedJson[OTMClient.JSONResponseKeys.sessionObject]{
                if let sID = sessionJson![OTMClient.JSONResponseKeys.sessionId] {
                    data = [OTMClient.JSONResponseKeys.sessionId : sID!]
                }
                else{
                    completionHandler(sussess: false, results:  nil, error: NSError(domain: "Network", code: 003, userInfo: ["message" : "Your request returned an invalid response!"]))
                }
            }
            else{
                completionHandler(sussess: false, results: nil, error: NSError(domain: "Network", code: 003, userInfo: ["message" : "Failed to parce Session JSON"]))
            }
            if let accountJson = parsedJson[OTMClient.JSONResponseKeys.account]{
                if let accID = accountJson![OTMClient.JSONResponseKeys.accountKey] {
                    data[OTMClient.JSONResponseKeys.accountKey] = accID!
                }
                else{
                    completionHandler(sussess: false, results:  nil, error: NSError(domain: "Network", code: 003, userInfo: ["message" : "Failed to parce Account Id"]))
                }
            }
            else{
                completionHandler(sussess: false, results: nil, error: NSError(domain: "Network", code: 003, userInfo: ["message" : "Failed to parce Account JSON"]))
            }
            completionHandler(sussess: true, results: data, error: nil)
        }
    }
    
    func getUserDetails(user : OnTheMapUser, complitionHandler: (results: [String: AnyObject]?, error: NSError?) -> Void){
        
        let urlSrting = OTMClient.Constants.udacityUserURL + "/" + user.uniqueKey!
        let parameters = [String : String]()
        let headers = ["Accept" : "application/json", "Content-Type" : "application/json"]
        
        var parsedJson: AnyObject!
        taskForGetMethod(urlSrting, parameters: parameters, headers: headers) { (results, error) -> Void in
            guard (error == nil) else {
                complitionHandler(results: nil, error: error)
                return
            }
            parsedJson = OTMClient.parseJSONForUdacitySession(results!)
            var data = [String: AnyObject]()
            if let userObject = parsedJson["user"] as? NSDictionary {
                data[OTMClient.JSONResponseKeys.firstName] = userObject["nickname"]
                data[OTMClient.JSONResponseKeys.lastName] = userObject["last_name"]
                complitionHandler(results: data, error: nil)
            }
            else {
                complitionHandler(results: nil, error: NSError(domain: "Parsing", code: 005, userInfo:  [NSLocalizedDescriptionKey: "Could not parse JSON response"]))
            }
        }
    }
    
    func getStudentLocations(completionHandler: (locations: [StudentLocation]?, error: NSError?) -> Void) {
        
        let baseURL = Constants.parseStudentLocationsHost
        let parametrs = ["limit" : "100", "order": "-updatedAt"]
        let headers = [OTMClient.Constants.headerParseApplicationID : Constants.parseApplicationID, OTMClient.Constants.headerApiKey : Constants.apiKey]
        
        taskForGetMethod(baseURL, parameters: parametrs, headers: headers) { (results, error) -> Void in
            guard (error == nil) else {
                completionHandler(locations: nil, error: error)
                return
            }
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(results as! NSData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(results)'")
            }

            if let locations = parsedResult[OTMClient.JSONResponseKeys.resultsStudentLocations] {
                let studentLocations = self.convertDataToStudentLocationObject(locations as! [[String : AnyObject]])
                completionHandler(locations: studentLocations, error: nil)
            }
            else {
                completionHandler(locations: nil, error: NSError(domain: "Parsing", code: 005, userInfo:  [NSLocalizedDescriptionKey: "Could not parse user location data"]))
            }
        }
    }
    
    func queryingForStudentLocation(uniqueKey : String, complitionHandler : (success : Bool, objectID : String?, error: NSError?) -> Void) {
        let baseURL = Constants.parseStudentLocationsHost
        let parametrs = ["where" : "{\"uniqueKey\":\"\(uniqueKey)\"}"]
        let headers = [OTMClient.Constants.headerParseApplicationID : Constants.parseApplicationID, OTMClient.Constants.headerApiKey : Constants.apiKey]
        taskForGetMethod(baseURL, parameters: parametrs, headers: headers) { (results, error) -> Void in
            guard (error == nil) else {
                complitionHandler(success: false, objectID: nil, error: error)
                return
            }
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(results as! NSData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(results)'")
            }
            if let userData = parsedResult[OTMClient.JSONResponseKeys.results] {
                    let data = userData![0] as! [String : AnyObject]
                    let objectId = data[OTMClient.JSONResponseKeys.objectId] as! String
                    complitionHandler(success: true, objectID: objectId, error: nil)
            }
            else {
                complitionHandler(success: true, objectID: nil, error: nil)
            }
        }    
    }
    
    func postStudentLocation(user: OnTheMapUser, completionHandler: (objectId: String?, error: NSError?) -> Void) {
        let baseUrl = Constants.parseStudentLocationsHost
        
        let headers = [OTMClient.Constants.headerParseApplicationID : Constants.parseApplicationID, OTMClient.Constants.headerApiKey : Constants.apiKey, "Content-Type" : "application/json"]
        
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
            completionHandler(objectId: nil, error: NSError(domain: "Parsing", code: 005, userInfo:  [NSLocalizedDescriptionKey: "Serialization Error"]))
        }
        
        taskForPOSTMethod(baseUrl, headers: headers, body: jsonData!) { (result, error) in
            guard (error == nil) else {
                completionHandler(objectId: nil, error: error)
                return
            }
            let jsonResult = OTMClient.parseJSON(result!)
            if let objectID = jsonResult[OTMClient.JSONResponseKeys.objectId]{
                completionHandler(objectId: objectID as? String, error: nil)
            }
            else {
                completionHandler(objectId: nil, error: NSError(domain: "Parsing", code: 005, userInfo:  [NSLocalizedDescriptionKey: "Could not parse JSON response"]))
            }
        }
    }
    
    func updateStudentLocation(user: OnTheMapUser, completionHandler: (success: Bool, error: NSError?) -> Void) {
        let baseUrl = Constants.parseStudentLocationsHost + "/\(user.objectId!)"
        
        let headers = [OTMClient.Constants.headerParseApplicationID : Constants.parseApplicationID, OTMClient.Constants.headerApiKey : Constants.apiKey, "Content-Type" : "application/json"]
        
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
            completionHandler(success: false, error: NSError(domain: "Parsing", code: 005, userInfo:  [NSLocalizedDescriptionKey: "Serialization Error"]))
        }
        
        taskForPUTMethod(baseUrl, headers: headers, body: jsonData!) { (result, error) in
            guard (error == nil) else {
                completionHandler(success: false, error: error)
                return
            }
            let jsonResult = OTMClient.parseJSON(result!)
            if let _ = jsonResult[OTMClient.JSONResponseKeys.updatedAt]{
                completionHandler(success: true, error: nil)
            }
            else {
                completionHandler(success: false, error: NSError(domain: "Parsing", code: 005, userInfo:  [NSLocalizedDescriptionKey: "Could not parse JSON Response"]))
            }
        }
    }
    
    func deleteSession(completionHandler: (sussess: Bool, error: NSError?)-> Void) {
        
        let baseUrl = Constants.udacitySessionHost
        taskForDELETEMethod(baseUrl){ (success, error) in
            completionHandler(sussess: success, error: error)
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
            let location = StudentLocation(userDictionary: studentObject)
            studentLocations.append(location)
        }
        return studentLocations
    }
}
