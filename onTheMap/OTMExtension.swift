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
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
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
                print("herror encountered")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            let decodedData = NSString(data: newData, encoding: NSUTF8StringEncoding)
            
            
            if decodedData != nil {
                print(decodedData)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print("logout unsuccessful")
            }
            
        }
        task.resume()
    }
}