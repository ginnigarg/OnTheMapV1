//
//  Constants.swift
//  OnTheMap(V1)
//
//  Created by Guneet Garg on 06/05/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct Constants{
    
    
    
    struct UdacityConstants {
        static let ApiUserIdURL = "https://www.udacity.com/api/users/"
        static let ApiSessionURL = "https://www.udacity.com/api/session"
        static let ApiSignUpURL = "https://www.udacity.com/account/auth#!/signup/"
    }
    
    struct ParseConstants {
        static let ApiURL = "https://parse.udacity.com/parse/classes"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let DefaultURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let Limit = "?limit=100&order=-updatedAt"
    }
    
    struct info {
        static var firstName : String = "First Name"
        static var lastName : String = "Last Name"
        static var latitude : Double = 0.0
        static var longitude : Double = 0.0
        static var location : String = ""
        static var uniqueKey : String = ""
        static var mediaUrl : String = ""
    }
    
    struct StudentDetail {
        
        static var studentDetails = [StudentDetail] ()
        
        var firstName : String? = "First Name"
        var lastName : String? = "Last Name"
        var lat : Double = 0.0
        var long : Double = 0.0
        var location : String = ""
        var uniqueKey : String = ""
        var url : String = ""
        var objectID : String? = "ObjectID"
        init(dictionary : [String : AnyObject]) {
            firstName =  (dictionary["firstName"] as? String)!
            lastName = (dictionary["lastName"] as? String)!
            lat = (dictionary["lat"] as? Double)!
            long = (dictionary["long"] as? Double)!
            url = (dictionary["url"] as? String)!
            objectID = (dictionary["objectId"] as? String)
            uniqueKey = (dictionary["uniqueKey"] as? String)!
            location = (dictionary["location"] as? String)!
        }
    }
    
}


