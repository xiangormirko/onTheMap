//
//  OTMPostButton.swift
//  onTheMap
//
//  Created by MIRKO on 1/30/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit

extension infoPostingViewController {
    func postEnabled() {
        submitButton.enabled = true
        submitButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        submitButton.backgroundColor = UIColor.whiteColor()
        submitButton.setTitle("Submit", forState: .Normal)
    }
    
    func postDisabled() {
        submitButton.enabled = false
        submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton.backgroundColor = UIColor.lightGrayColor()
        submitButton.setTitle("Wait...", forState: .Normal)
        
    }
}