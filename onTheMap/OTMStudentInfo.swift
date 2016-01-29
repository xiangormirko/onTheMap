//
//  OTMStudentInfo.swift
//  onTheMap
//
//  Created by MIRKO on 1/29/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation

class OTMStudentInfo : NSObject {

    var locations = [OTMLocation]()
    var studentInfo = OTMCoreUserInfo()
    var studentID = String()
    
    class func sharedInstance() -> OTMStudentInfo {
        
        struct Singleton {
            static var sharedInstance = OTMStudentInfo()
        }
        
        return Singleton.sharedInstance
    }
}