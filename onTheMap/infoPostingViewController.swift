//
//  infoPostingViewController.swift
//  onTheMap
//
//  Created by MIRKO on 1/19/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation

import Foundation
import UIKit


import UIKit
import MapKit

class infoPostingViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate {
    
    //View to post data to Parse Backend
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    
    var location: CLLocationCoordinate2D? = nil
    var span = MKCoordinateSpanMake(1, 1)
    var placemark: CLPlacemark? = nil
    var locationString: String? = nil
    var mediaUrl: String? = nil

    var appDelegate: AppDelegate!
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        textView.delegate = self
        
        textView.text = "Insert your comment or URL"
        textView.textColor = UIColor.lightGrayColor()
        textView.textAlignment = .Center
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate


        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        postEnabled()

            if location != nil {
                self.latitude = location?.latitude
                self.longitude = location?.longitude
                
                let region = MKCoordinateRegion(center: location!, span: self.span)
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark!))
            } else {
                self.presentAlert("Location error, please go back and try again")
        }
        
    }
    
    
    @IBAction func postLocation(sender: AnyObject) {
        postDisabled()
        getUserInfo(OTMStudentInfo.sharedInstance().studentID, location: locationString!, mediaUrl: textView.text, long: self.longitude!, lat: self.latitude!)

    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Insert your comment or URL" {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGrayColor()
        }
    
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    @IBAction func cancelView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    

}