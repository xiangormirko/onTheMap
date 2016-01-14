//
//  LoginViewController.swift
//  onTheMap
//
//  Created by MIRKO on 1/14/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!

    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        
        /* Configure the UI */
        self.configureUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        if usernameTextField.text!.isEmpty {
            debugTextLabel.text = "Username Empty."
        } else if passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Password Empty."
        } else {
            
            self.setUIEnabled(enabled: false)

            self.getSessionID()
        }
    }
    
    func getSessionID() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
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
                    self.debugTextLabel.text = "Login Failed (Login Step)."
                }
                print("There was an error with your request: \(error)")
                return
            }
            
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUIEnabled(enabled: true)
                }
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
            
            /* GUARD: Did TheMovieDB return an error? */
            guard (parsedResult.objectForKey("status_code") == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUIEnabled(enabled: true)
                }
                print("TheMovieDB returned an error. See the status_code and status_message in \(parsedResult)")
                return
            }
            
            
            /* GUARD: Is the "success" key in parsedResult? */
            guard let _ = parsedResult["account"] else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUIEnabled(enabled: true)
                    self.debugTextLabel.text = "Login Failed (Login Step)."
                }
                print("Login failed.")
                return
            }
            
            /* 6. Use the data! */
            self.completeLogin()

        }
        task.resume()
        
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = ""
            self.setUIEnabled(enabled: true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }


}

