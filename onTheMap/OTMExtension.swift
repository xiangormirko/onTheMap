//
//  OTMExtension.swift
//  onTheMap
//
//  Created by MIRKO on 1/27/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func logoutFunction() {
        let request = NSMutableURLRequest(URL: NSURL(string: OTMClient.Constants.UdacitySessionUrl)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                self.presentAlert("Logout error")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            let decodedData = NSString(data: newData, encoding: NSUTF8StringEncoding)
            
            
            if decodedData != nil {
                print(decodedData)
                dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                self.presentAlert("Logout error encountered, please try again")
                }
            }
            
        }
        task.resume()
    }
    
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Apologies", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        dispatch_async(dispatch_get_main_queue()) {
        self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func getUserInfo(studentID: String, location: String, mediaUrl: String, long: Double, lat: Double ) {
        //Obtain public user info from Udacity
        
        let url = OTMClient.Constants.UdacityUserUrl + studentID
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        
        let session = NSURLSession.sharedSession()
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentAlert("There was an error with your request, please check your connection and try again")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Udacity return an error? */
            guard (parsedResult.objectForKey("status_code") == nil) else {
                print("Udacity returned an error. See the status_code and status_message in \(parsedResult)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentAlert("There was an error with your request, please check your connection and try again")
                }
                return
            }
            
            
            /* GUARD: Is the "user" key in parsedResult? */
            guard let results = parsedResult["user"] else {
                print("Info retrieval failed")
                return
            }
            /* 6. Use the data! */
            OTMStudentInfo.sharedInstance().studentInfo.firstName = results!["first_name"] as? String
            OTMStudentInfo.sharedInstance().studentInfo.lastName = results!["last_name"] as? String
            OTMStudentInfo.sharedInstance().studentInfo.mapString = location
            OTMStudentInfo.sharedInstance().studentInfo.uniqueKey = studentID
            OTMStudentInfo.sharedInstance().studentInfo.mediaURL = mediaUrl
            OTMStudentInfo.sharedInstance().studentInfo.longitude = long
            OTMStudentInfo.sharedInstance().studentInfo.latitude = lat
            
            
            dispatch_async(dispatch_get_main_queue()) {
                self.postUserInfo(OTMStudentInfo.sharedInstance().studentInfo)
            }
            
            
            
        }
        task.resume()
        
    }
    
    
    func postUserInfo(studentInfo: OTMCoreUserInfo) {
        
        // posting user info to API
        
        let httpB = "{\"uniqueKey\": \"\(studentInfo.uniqueKey!)\", \"firstName\": \"\(studentInfo.firstName!)\", \"lastName\": \"\(studentInfo.lastName!)\",\"mapString\": \"\(studentInfo.mapString!)\", \"mediaURL\": \"\(studentInfo.mediaURL!)\",\"latitude\": \(studentInfo.latitude!), \"longitude\": \(studentInfo.longitude!)}"
        print(httpB)
        OTMClient.sharedInstance().postRequestParse(httpB) { result, error in
            if result["objectId"] != nil {
                print("your post was successful")
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(false, completion: nil)
                }
                
                
            }
            
            if (error != nil) {
                print("Failed post, please try again")
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentAlert("There was an error with your request, please check your connection and try again")
                }
            }
        }
        
    }
}