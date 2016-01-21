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
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    
    var location: String? = nil
    var span = MKCoordinateSpanMake(1, 1)
    
    var url = "https://www.udacity.com/api/users/"
    var appDelegate: AppDelegate!
    var studentID: String? = nil
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
        studentID = self.appDelegate.studentID


        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let address = location
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.latitude = placemark.location?.coordinate.latitude
                self.longitude = placemark.location?.coordinate.longitude
                
                let region = MKCoordinateRegion(center: coordinates, span: self.span)
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
            }
        })
    }
    
    
    @IBAction func postLocation(sender: AnyObject) {
        getUserInfo(self.studentID!)
        self.submitButton.enabled = false
        self.submitButton.backgroundColor = UIColor.lightGrayColor()
        self.submitButton.setTitle("Wait...", forState: .Normal)
        
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
    
    func getUserInfo(studentID: String) {
        url = "https://www.udacity.com/api/users/" + studentID
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)

        
        let session = NSURLSession.sharedSession()
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Udacity return an error? */
            guard (parsedResult.objectForKey("status_code") == nil) else {
                print("Udacity returned an error. See the status_code and status_message in \(parsedResult)")
                return
            }
            
            
            /* GUARD: Is the "user" key in parsedResult? */
            guard let results = parsedResult["user"] else {
                print("Info retrieval failed")
                return
            }
            /* 6. Use the data! */
            self.appDelegate.studentInfo.firstName = results!["first_name"] as? String
            self.appDelegate.studentInfo.lastName = results!["last_name"] as? String
            self.appDelegate.studentInfo.mapString = self.location 
            self.appDelegate.studentInfo.uniqueKey = self.appDelegate.studentID
            self.appDelegate.studentInfo.mediaURL = self.textView.text
            self.appDelegate.studentInfo.longitude = self.longitude
            self.appDelegate.studentInfo.latitude = self.latitude
            
            print(self.appDelegate.studentInfo)
            self.postUserInfo(self.appDelegate.studentInfo)
            
        }
        task.resume()
        
    }
    
    func postUserInfo(studentInfo: OTMCoreUserInfo) {

        let httpB = "{\"uniqueKey\": \"\(studentInfo.uniqueKey!)\", \"firstName\": \"\(studentInfo.firstName!)\", \"lastName\": \"\(studentInfo.lastName!)\",\"mapString\": \"\(studentInfo.mapString!)\", \"mediaURL\": \"\(studentInfo.mediaURL!)\",\"latitude\": \(studentInfo.latitude!), \"longitude\": \(studentInfo.longitude!)}"
        print(httpB)
        OTMClient.sharedInstance().postRequestParse(httpB) { result, error in
            if result["objectId"] != nil {
                print("dismissing view controller")
                print(result)
                self.dismissViewControllerAnimated(false, completion: nil)
                
            }
        }
        
    }
    
    

}