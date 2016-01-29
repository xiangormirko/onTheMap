//
//  locationFinderViewController.swift
//  onTheMap
//
//  Created by MIRKO on 1/19/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class locationFinderViewController: UIViewController, UITextFieldDelegate  {
    
    // user type in location to be searched
    
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
            let address = location
            findOnMapButton.setTitle("Searching...", forState: UIControlState.Normal)
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error)
                    self.presentAlert("There was a geocoding error, please go back and try again")
                    self.findOnMapButton.setTitle("Find On Map", forState: UIControlState.Normal)
                    
                }
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    let postingController = self.storyboard!.instantiateViewControllerWithIdentifier("infoPostingViewController") as! infoPostingViewController
                    postingController.placemark = placemark
                    postingController.location = coordinates
                    postingController.locationString = address
                    self.findOnMapButton.setTitle("Find On Map", forState: UIControlState.Normal)
                    self.navigationController!.pushViewController(postingController, animated: true)

                }
            })

            
        } else {
            print("error")
        }
    }
    
    @IBAction func cancelView(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        locationTextBox.resignFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}