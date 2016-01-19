//
//  LocationTableViewController.swift
//  onTheMap
//
//  Created by MIRKO on 1/17/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit

class LocationTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var locations = [OTMLocation]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self

        self.automaticallyAdjustsScrollViewInsets = false
        
        OTMClient.sharedInstance().getSudentLocations { result, error in
            if let results = result["results"] as? [[String : AnyObject]] {
                let locationsFromResults = OTMLocation.locationsFromResults(results)
                self.locations = locationsFromResults
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    print("reloading")
                }
                
                
            } else {
                print(error)
            }
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        tableView.reloadData()
    }
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.locations.count)
        return self.locations.count
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // reloading table data after change
        let cell = tableView.dequeueReusableCellWithIdentifier("loc")!
        let location = self.locations[indexPath.row]
        print(location)
        
        // Set the name and image
        cell.textLabel?.text = location.firstName! + location.lastName!
        cell.imageView!.image = UIImage(named: "location")
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = location.mediaURL
        }
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        // present detail view when a cell is pressed
//        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
//        detailController.meme = self.memes[indexPath.row]
//        self.navigationController!.pushViewController(detailController, animated: true)
//        
//    }

    
    
}