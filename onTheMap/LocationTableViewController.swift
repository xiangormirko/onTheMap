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
    //Table view of current posts
    
    @IBOutlet weak var tableView: UITableView!


    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self

        self.automaticallyAdjustsScrollViewInsets = false
        
        getData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        tableView.reloadData()
    }
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return OTMStudentInfo.sharedInstance().locations.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // reloading table data after change
        let cell = tableView.dequeueReusableCellWithIdentifier("loc")!
        let location = OTMStudentInfo.sharedInstance().locations[indexPath.row]
        // Set the name and image
        cell.textLabel?.text = location.firstName! + location.lastName!
        cell.imageView!.image = UIImage(named: "locs")
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = location.mediaURL
        }
        
        return cell
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        getData()
    }
    
    func getData() {
        OTMClient.sharedInstance().getRequestParse(OTMClient.Constants.ParseStudentLocUrl) { result, error in
            if let results = result["results"] as? [[String : AnyObject]] {
                let locationsFromResults = OTMLocation.locationsFromResults(results)
                OTMStudentInfo.sharedInstance().locations = locationsFromResults.sort({$0.updatedAt > $1.updatedAt})
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
                
            } else {
                print(error)
                self.presentAlert("Error encountered in fetching data")
            }
            
        }
    }
    
    
    @IBAction func logoutButtonTouch(sender: AnyObject) {
        logoutFunction()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // present detail view when a cell is pressed
        let app = UIApplication.sharedApplication()
        let location = OTMStudentInfo.sharedInstance().locations[indexPath.row]
        if let toOpen = location.mediaURL {
            if let url = NSURL(string: toOpen) {
                if UIApplication.sharedApplication().canOpenURL(url) {
                    app.openURL(NSURL(string: toOpen)!)
                } else {
                    print("not a valid url")
                }
            }
        }

        
    }

    
    
}