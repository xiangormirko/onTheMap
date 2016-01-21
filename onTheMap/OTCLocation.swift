//
//  OTCLocation.swift
//  onTheMap
//
//  Created by MIRKO on 1/15/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation

struct OTMLocation {
    
    var createdAt: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var latitude : Double? = nil
    var longitude: Double? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    var objectId: String? = nil
    var uniqueKey: String? = nil
    var updatedAt: String? = nil
    
    init(dictionary: [String : AnyObject]) {
        createdAt = dictionary["createdAt"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        objectId = dictionary["objectId"] as? String
        uniqueKey = dictionary["uniqueKey"] as? String
        updatedAt = dictionary["updatedAt"] as? String
        
    }
    
    static func locationsFromResults(results: [[String : AnyObject]]) -> [OTMLocation] {
        var locations = [OTMLocation]()
        
        for result in results {
            locations.append(OTMLocation(dictionary: result))
        }
        
        return locations
    }
    
    
}