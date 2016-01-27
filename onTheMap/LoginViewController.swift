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
        self.logoView.contentMode = UIViewContentMode.ScaleAspectFit
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
        // textfields validation
        if usernameTextField.text!.isEmpty {
            debugTextLabel.text = "Username Empty."
            debugTextLabel.hidden = false
        } else if passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Password Empty."
            debugTextLabel.hidden = false
        } else {
            
            self.setUIEnabled(enabled: false)

            self.getSessionID()
        }
    }
    
    func getSessionID() {
        // Get session function throught Udacity API
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
                    self.debugTextLabel.hidden = false
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
            
            /* GUARD: Did Udacity return an error? */
            guard (parsedResult.objectForKey("status_code") == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUIEnabled(enabled: true)
                }
                print("Udacity returned an error. See the status_code and status_message in \(parsedResult)")
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
            
            
            if let studentNumber = parsedResult["account"]??["key"] as? String {
                
                self.appDelegate.studentID = studentNumber
                print(self.appDelegate.studentID)
                /* 6. Use the data! */
                self.completeLogin()
            } else {
                print("no student id found")
                dispatch_async(dispatch_get_main_queue()) {
                    self.debugTextLabel.text = "Login failed, check your credentials"
                    self.debugTextLabel.hidden = false
                    self.setUIEnabled(enabled: true)
                }

            }



        }
        task.resume()
        
    }
    @IBAction func openSignUp(sender: AnyObject) {
        // Open udacity sign up page if button touched
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)

    }
    
    func completeLogin() {
        // complete login process and present next viewcontroller
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = ""
            self.setUIEnabled(enabled: true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UITabBarController
            self.usernameTextField.text = nil
            self.passwordTextField.text = nil
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }


}

