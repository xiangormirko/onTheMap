//
//  locationFinderViewController.swift
//  onTheMap
//
//  Created by MIRKO on 1/19/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit


class locationFinderViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var locationTextBox: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!
    

    var locationString: String? = nil

    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationTextBox.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGesture)
        
        
    
    }
    
    @IBAction func findButtonTouchUp(sender: AnyObject) {
        locationString = locationTextBox.text
        findOnMap(locationString)

    }
    
    func findOnMap(location: String?) {
        if let location = location {
            let postingController = self.storyboard!.instantiateViewControllerWithIdentifier("infoPostingViewController") as! infoPostingViewController
            postingController.location = location
            self.navigationController!.pushViewController(postingController, animated: true)
            
        } else {
            print("error")
        }
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        locationTextBox.resignFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}