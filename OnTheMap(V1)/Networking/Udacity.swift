//
//  Udacity.swift
//  OnTheMap(V1)
//
//  Created by Guneet Garg on 06/05/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit

class Udacity {
    
    static var firstName : String? = nil
    static var lastName : String? = nil
    static var sessID : String? = nil
    static var accID : String? = nil
    
    func convertData (_ data : Data, completionHandler : (_ success : Bool , _ result : [String : AnyObject]? , _ error : String?) -> Void ) {
        var result : AnyObject!
        do {
            result = try JSONSerialization.jsonObject (with : data, options : .allowFragments) as AnyObject!
        } catch {
            completionHandler (false , nil , "Parsing failed as JSON: '\(data)'")
        }
        completionHandler (true , result as? [String : AnyObject] , nil)
    }
    
    func errorHandler (_ data: Data? , _ response: URLResponse? , _ error: NSError? , completionHandler: @escaping (_ success: Bool , _ result: [String:AnyObject]? , _ error: String?) -> Void) {
        
        guard (error == nil) else {
            print("Error in error Handler")
            completionHandler (false , nil , "There is a network issue")
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("Invalid Credentials")
            completionHandler (false , nil , "Invalid Credentials")
            return
        }
        guard let _ = data else {
            print("No data Found")
            completionHandler (false , nil , "No data Found")
            return
        }
    }
    
    func taskForGETMethod (_ uniqueId : String , completionHandlerForTaskForGetMethod : @escaping (_ success : Bool , _ results : [String : AnyObject]? ,_ error : String?) ->Void) {
        var req = URLRequest(url : URL(string : ("\(Constants.UdacityConstants.ApiSessionURL)/\(uniqueId)"))!)
        req.addValue (Constants.ParseConstants.ApplicationID , forHTTPHeaderField: "X-Parse-Application-Id")
        req.addValue (Constants.ParseConstants.RestApiKey , forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with : req as URLRequest) { (data, response, error) in
            self.errorHandler (data, response, error as NSError?, completionHandler: completionHandlerForTaskForGetMethod)
            self.convertData (data!, completionHandler: completionHandlerForTaskForGetMethod)
        }
        task.resume ()
    }
    
    func taskforPOSTmethod (_ userName : String , _ password : String , completionHandlerForPOST : @escaping (_ success : Bool , _ result : [String : AnyObject]?, _ error : String?) -> Void) -> URLSessionDataTask {
        //print("Its working on Post method")
        var req = URLRequest(url: URL(string: Constants.UdacityConstants.ApiSessionURL)!)
        req.httpMethod = "POST"
        req.addValue ("application/json" , forHTTPHeaderField: "Accept")
        req.addValue ("application/json" , forHTTPHeaderField: "Content-Type")
        req.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        //print(req.httpBody)
        let task = session.dataTask (with: req as URLRequest) { (data, response, error) in
            self.errorHandler(data, response, error as NSError?, completionHandler: completionHandlerForPOST)
            let range = Range (5..<data!.count)
            let newData = data!.subdata (in: range)
            print("Working fine")
            self.convertData (newData , completionHandler : completionHandlerForPOST)
        }
        task.resume ()
        //print(userName + " " + password)
        return task
    }
    
    func authenticate (_ userName : String , _ password : String , completionHandlerforAuth : @escaping (_ success : Bool , _ error : String?) ->Void) {
        _ = taskforPOSTmethod (userName, password) { (success , result , error) in
            print(success)
            if error == nil {
                completionHandlerforAuth (true , nil)
            } else {
                completionHandlerforAuth (false , error)
            }
        }
    }
    
    func getPublicData (_ userId : String, completionHandlerForGetPublicData : @escaping (_ success : Bool , _ result : String, _ error : String?) -> Void) {
        taskForGETMethod (Udacity.accID!) { (success , result , error) in
            if error != nil {
                print ("Error in getting Data")
            } else {
                if let user = result!["user"] as! [String:AnyObject]? {
                    if let lastName = user["last_name"] as! String? , let firstName = user["first_name"] as! String? {
                        Udacity.firstName = firstName
                        Udacity.lastName = lastName
                    }
                }
            }
        }
    }
    
    func logOut (completionHandlerForLogOut : @escaping ( _ response : AnyObject, _ error : String?) -> Void) {
        var req = URLRequest(url: URL(string: Constants.UdacityConstants.ApiSessionURL)!)
        req.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            req.setValue (xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask (with : req) { (data , response , error) in
            if error != nil {
                return
            }
            let range = Range (5..<data!.count)
            let newData = data?.subdata (in: range)
            print(String(data: newData!, encoding: .utf8)!)
            completionHandlerForLogOut(newData as AnyObject,nil)
        }
        task.resume ()
    }
    
    class func sharedInstance () -> Udacity {
        
        struct Singleton {
            static var sharedInstance = Udacity ()
        }
        return Singleton.sharedInstance
    }
}



