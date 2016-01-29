//
//  OTMHelpler.swift
//  onTheMap
//
//  Created by MIRKO on 1/14/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit


extension LoginViewController {
    
    func getSessionID() {
        // Get session function throught Udacity API
        let request = NSMutableURLRequest(URL: NSURL(string: OTMClient.Constants.UdacitySessionUrl)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.usernameTextField.text!)\", \"password\": \"\(self.passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let session = NSURLSession.sharedSession()
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUIEnabled(enabled: true)
                    self.presentAlert("login failed, please check your connection and credentials")
                }
                print("There was an error with your request: \(error)")
                return
            }
            
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUIEnabled(enabled: true)
                }
                self.presentAlert("No data was returned by the request!")
                print("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                parsedResult = nil
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUIEnabled(enabled: true)
                }
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Udacity return an error? */
            guard (parsedResult.objectForKey("status_code") == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUIEnabled(enabled: true)
                    
                }
                self.presentAlert("Apologies there was an error, check your connection and try again")
                print("Udacity returned an error. See the status_code and status_message in \(parsedResult)")
                return
            }
            
            
            /* GUARD: Is the "success" key in parsedResult? */
            guard let _ = parsedResult["account"] else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUIEnabled(enabled: true)
                    self.presentAlert("Login failed, check your credentials and connection")
                }
                self.presentAlert("Apologies there was an error, check your connection and try again")
                print("Login failed.")
                return
            }
            
            
            if let studentNumber = parsedResult["account"]??["key"] as? String {
                OTMStudentInfo.sharedInstance().studentID = studentNumber
                /* 6. Use the data! */
                self.completeLogin()
            } else {
                print("no student id found")
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentAlert("Login failed, check your credentials")
                    self.setUIEnabled(enabled: true)
                }
                
            }
            
            
            
        }
        task.resume()
        
    }
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func setUIEnabled(enabled enabled: Bool) {
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    

    

}


