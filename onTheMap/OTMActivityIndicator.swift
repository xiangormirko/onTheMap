//
//  OTMActivityIndicator.swift
//  onTheMap
//
//  Created by MIRKO on 1/30/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit


extension locationFinderViewController {
    func activityDisabled() {
        activityIndicatorView.hidden = false
        findOnMapButton.enabled = false
        activityIndicatorView.startAnimating()
        findOnMapButton.setTitle("Searching...", forState: UIControlState.Normal)
    }
    
    func activityEnabled() {
        activityIndicatorView.hidden = true
        findOnMapButton.enabled = true
        activityIndicatorView.stopAnimating()
        findOnMapButton.setTitle("Find On Map", forState: UIControlState.Normal)
    }
    
}