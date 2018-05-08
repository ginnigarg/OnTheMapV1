//
//  Parse.swift
//  OnTheMap(V1)
//
//  Created by Guneet Garg on 06/05/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit

class Parse {
    
    let session = URLSession.shared
    
    func convertData (_ data : Data, completionHandler : (_ success : Bool , _ result : [String : AnyObject]?, _ error : String?) -> Void ) {
        var result: AnyObject!
        do {
            result = try JSONSerialization.jsonObject (with : data, options : .allowFragments) as AnyObject!
        } catch {
            completionHandler (false , nil , "Parsing Failed")
            return
        }
        completionHandler (true , result as? [String : AnyObject] , nil)
    }
    
    func errorHandler (_ data: Data? , _ response: URLResponse? , _ error: NSError? , completionHandler: @escaping (_ success: Bool , _ result: [String:AnyObject]? , _ error: String?) -> Void) {
        
        guard (error == nil) else {
            completionHandler (false , nil , "There is a network issue")
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            completionHandler (false , nil , "Invalid Credentials")
            return
        }
        guard let _ = data else {
            completionHandler (false , nil , "No data Found")
            return
        }
    }
    
    func taskForGETMethod (completionHandlerForGET : @escaping (_ success : Bool , _ result : [String : AnyObject]?, _ error : String?) -> Void) {
        var req = URLRequest (url: URL(string : Constants.ParseConstants.DefaultURL + Constants.ParseConstants.Limit)!)
        req.addValue (Constants.ParseConstants.ApplicationID, forHTTPHeaderField : "X-Parse-Application-Id")
        req.addValue (Constants.ParseConstants.RestApiKey, forHTTPHeaderField : "X-Parse-REST-API-Key")
        let task = session.dataTask(with : req as URLRequest) { (data, response, error) in
            guard let _ = data else {
                completionHandlerForGET (false , nil, "There is a network Issue")
                return
            }
            self.errorHandler(data, response, error as NSError?, completionHandler: completionHandlerForGET)
            self.convertData(data!, completionHandler : completionHandlerForGET)
        }
        task.resume ()
    }
    
    func taskForPOSTMethod (location : String, url : String, lat : Double, long : Double, completionHandlerForPost : @escaping (_ success : Bool , _ response : [String : AnyObject]? , _ error : String?) -> Void) {
        var req  = URLRequest(url: URL(string : Constants.ParseConstants.DefaultURL)!)
        req.httpMethod = "POST"
        req.addValue (Constants.ParseConstants.ApplicationID , forHTTPHeaderField : "X-Parse-Application-Id")
        req.addValue (Constants.ParseConstants.RestApiKey , forHTTPHeaderField : "X-Parse-REST-API-Key")
        req.addValue ("application/json" , forHTTPHeaderField : "Content-Type")
        req.httpBody = "{\"uniqueKey\":\"\(String(describing: Udacity.accID))\", \"firstName\": \"\(String(describing: Udacity.firstName))\", \"lastName\": \"\(String(describing: Udacity.lastName))\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(url)\",\"latitude\": \(lat), \"longitude\": \(long)}".data (using : .utf8)
        let task = session.dataTask (with : req as URLRequest) { (data , response , error) in
            guard let _ = data else {
                completionHandlerForPost (false , nil , "There is an error in Network")
                return
            }
            self.errorHandler(data, response, error as NSError?, completionHandler: completionHandlerForPost)
            self.convertData (data! , completionHandler : completionHandlerForPost)
        }
        task.resume ()
    }
    
    func getStudentsInformation (_ completionHandlerForGetStudentsInfo : @ escaping (_ success : Bool , _ result : [Constants.StudentDetail]? , _ errorString : String?) ->  Void ) {
        Parse.sharedInstance().taskForGETMethod { (success , response , error) in
            if success == false {
                completionHandlerForGetStudentsInfo (false , nil , error)
            } else {
                if let data = response!["response"] as AnyObject? {
                    Constants.studentDetails.removeAll ()
                    for results in data as! [AnyObject] {
                        let stud = Constants.StudentDetail (dictionary : results as! [String : AnyObject])
                        Constants.studentDetails.append (stud)
                    }
                    completionHandlerForGetStudentsInfo (true , Constants.studentDetails , nil)
                }
            }
        }
    }
    
    class func sharedInstance() -> Parse {
        struct Singleton {
            static var sharedInstance = Parse()
        }
        return Singleton.sharedInstance
    }
    
}

