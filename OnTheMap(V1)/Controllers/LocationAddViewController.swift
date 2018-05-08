//
//  LocationAddViewController.swift
//  OnTheMap(V1)
//
//  Created by Guneet Garg on 06/05/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit

class LocationAddViewController : UIViewController {
    
    static var location : String? = nil
    static var link : String? = nil
    
    @IBOutlet weak var locationToFind: UITextField!
    @IBOutlet weak var linkToAddForLocation: UITextField!
    
    @IBAction func cancel (_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func find (_ sender: Any) {
        let link = URL(string : linkToAddForLocation.text!)
        if link?.scheme == "https" && (linkToAddForLocation.text?.contains("://"))! {
            LocationAddViewController.location = locationToFind.text
            LocationAddViewController.link = linkToAddForLocation.text
            self.performSegue(withIdentifier: "update", sender: nil)
        } else {
            displayAlert(userMessage: "Enter a valid link!!")
        }
    }
}

