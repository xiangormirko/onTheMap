//
//  OTMView.swift
//  onTheMap
//
//  Created by MIRKO on 1/14/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit


extension LoginViewController {

func configureUI() {
    
    /* Configure background gradient */
    
    
    /* Configure email textfield */
    let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
    let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
    self.usernameTextField.leftView = emailTextFieldPaddingView
    self.usernameTextField.leftViewMode = .Always
    self.usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    
    
    /* Configure password textfield */
    let passwordTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
    let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
    self.passwordTextField.leftView = passwordTextFieldPaddingView
    self.passwordTextField.leftViewMode = .Always
    self.passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    
    let logo : UIImage = UIImage(named: "udacity logo")!
    self.logoView.image = logo
    self.logoView.contentMode = UIViewContentMode.ScaleAspectFit
    
    
    
    /* Configure tap recognizer */
    tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
    tapRecognizer?.numberOfTapsRequired = 1
    
}

}