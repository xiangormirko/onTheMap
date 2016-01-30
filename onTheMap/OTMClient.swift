//
//  OTMClient.swift
//  onTheMap
//
//  Created by MIRKO on 1/14/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit

class OTMClient : NSObject {

    /* Shared session */
    var session: NSURLSession

    /* Authentication state */
    var sessionID : String? = nil

    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    
    func getRequestParse(url: String, completionHandler: (result: AnyObject!, error: NSError?) ->  Void) -> NSURLSessionTask {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)

        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        let session = NSURLSession.sharedSession()
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request(2): \(error)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.displayAlert("There was an error, check your connection and try again")
                }
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayAlert("There was a server error, check your connection and try again")
                    }
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }

            
            /* 6. Use the data! */
            OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)


        }
        task.resume()
        
        return task

    }
    
    func postRequestParse(httpBody: String, completionHandler: (result: AnyObject!, error: NSError?) ->  Void) -> NSURLSessionTask {
        let request = NSMutableURLRequest(URL: NSURL(string: OTMClient.Constants.ParseStudentLocUrl)!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let session = NSURLSession.sharedSession()
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request(1): \(error)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.displayAlert("There was an error, check your connection and try again")
                }
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayAlert("There was a server error, check your connection and try again")
                    }
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            
            /* 6. Use the data! */
            OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            
            
        }
        task.resume()
        
        return task
        
    }
    
    func displayAlert(message: String) {
        var topController = UIApplication.sharedApplication().keyWindow!.rootViewController! as UIViewController
        
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!;
        }
        let alertController = UIAlertController(title: "Apologies", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        topController.presentViewController(alertController, animated:true, completion:nil)
    }
    
    

    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }

    // MARK: Shared Instance
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }

}