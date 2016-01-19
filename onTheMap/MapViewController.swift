//
//  MapViewController.swift
//  onTheMap
//
//  Created by MIRKO on 1/14/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        mapView.delegate = self
        
        var annotations = [MKPointAnnotation]()
        
        OTMClient.sharedInstance().getSudentLocations { result, error in
            if let results = result["results"] as? [[String : AnyObject]] {
                let locations = OTMLocation.locationsFromResults(results)
                
                
                for location in locations {
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(location.latitude!)
                    let long = CLLocationDegrees(location.longitude!)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = location.firstName!
                    let last = location.lastName!
                    let mediaURL = location.mediaURL!
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                    self.mapView.addAnnotations(annotations)

                }
            } else {
                print(error)
            }
            
        }

        
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = false
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
            
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
        
}

