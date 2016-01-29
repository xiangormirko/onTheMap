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
            self.presentAlert("Username is required")
        } else if passwordTextField.text!.isEmpty {
            self.presentAlert("Password is required")
        } else {
            self.setUIEnabled(enabled: false)
            self.getSessionID()
        }
    }
    

    @IBAction func openSignUp(sender: AnyObject) {
        // Open udacity sign up page if button touched
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: OTMClient.Constants.UdacitySignUpUrl)!)

    }
    
    func completeLogin() {
        // complete login process and present next viewcontroller
        dispatch_async(dispatch_get_main_queue(), {
            self.setUIEnabled(enabled: true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UITabBarController
            self.usernameTextField.text = nil
            self.passwordTextField.text = nil
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }


}

