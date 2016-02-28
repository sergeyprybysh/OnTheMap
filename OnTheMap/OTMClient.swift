//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Sergey Prybysh on 12/20/15.
//  Copyright © 2015 Sergey Prybysh. All rights reserved.
//

import Foundation

class OTMClient : NSObject {
        
    var userOnTheMap = OnTheMapUser()
    
    var sessionID: String? = nil
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForPOSTMethod(urlArg: String, headers: [String: String], body: NSData, completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
    
        let urlString = urlArg
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.HTTPBody = body
        
        let task = session.dataTaskWithRequest(request) { (data, response, downloadError) in
            
            guard (downloadError == nil) else {
                print("There was an error in POST + \(downloadError)")
                completionHandler(result: nil, error: NSError(domain: "Network", code: 001, userInfo: nil))
                return
            }            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    completionHandler(result: nil, error: NSError(domain: "Network", code: 002, userInfo: ["statusCode" : response.statusCode]))
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(result: nil, error: NSError(domain: "Network", code: 003, userInfo: ["message" : "Your request returned an invalid response!"]))
                return
            }
            guard let data = data else {
                completionHandler(result: nil, error: NSError(domain: "Network", code: 003, userInfo: ["message" : "No data was returned by the request!"]))
                return
            }
            completionHandler(result: data, error: nil)
        }        
       task.resume()
       return task
    }
    
    func taskForGetMethod(urlArg: String, parameters: [String : AnyObject], headers: [String : String], completionHandler:(result: AnyObject?, error: NSError?) -> Void )-> NSURLSessionDataTask {
        
        let urlString = urlArg + OTMClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandler(result: nil, error: error)
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(result: nil, error:  NSError(domain: "Network", code: 003, userInfo: [NSLocalizedDescriptionKey : "Your request returned an invalid response!"]))
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(result: nil, error:  NSError(domain: "Network", code: 003, userInfo: [NSLocalizedDescriptionKey : "Your request returned no data!"]))
                return
            }
            completionHandler(result: data, error: nil)
        }
        task.resume()
        return task
    }
    
    func taskForPUTMethod(urlArg: String, headers: [String: String], body: NSData, completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = urlArg
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "PUT"
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.HTTPBody = body
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error in PUT + \(error)")
                completionHandler(result: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(result: nil, error:  NSError(domain: "Network", code: 003, userInfo: [NSLocalizedDescriptionKey : "Your request returned an invalid response!"]))
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(result: nil, error:  NSError(domain: "Network", code: 003, userInfo: [NSLocalizedDescriptionKey : "Your request returned no data!"]))
                return
            }
            completionHandler(result: data, error: nil)
        }
        task.resume()
        return task
    }
    
    func taskForDELETEMethod(urlArg: String, completionHandler:(success: Bool, error: NSError?) -> Void )-> NSURLSessionDataTask {
        
        let urlString = urlArg
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error in Delete + \(error)")
                completionHandler(success: false, error: error)
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(success: false, error:  NSError(domain: "Network", code: 003, userInfo: [NSLocalizedDescriptionKey : "Your request returned an invalid response!"]))
                return
            }
            guard let _ = data else {
                print("No data was returned by the request!")
                completionHandler(success: false, error: error)
                return
            }
            completionHandler(success: true, error:  NSError(domain: "Network", code: 003, userInfo: [NSLocalizedDescriptionKey : "Your request returned no data!"]))
        }
        task.resume()
        return task
    }
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    class func parseJSONForUdacitySession(data: AnyObject) -> AnyObject {
        
        var parsedResult: AnyObject!
        do {
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            print("Could not parse the data as JSON: '\(data)'")
        }
        return parsedResult
    }
    
    class func parseJSON(data: AnyObject) -> AnyObject {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: .AllowFragments)
        } catch {
            print("Could not parse the data as JSON: '\(data)'")
        }
        return parsedResult
    }
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
    
}
