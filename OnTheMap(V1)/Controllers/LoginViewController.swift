//
//  LoginViewController.swift
//  OnTheMap(V1)
//
//  Created by Guneet Garg on 06/05/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController:  UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pwd: UITextField!
    
    @IBAction func submit (_ sender: Any) {
        if email.text == "" && pwd.text == ""  {
            displayAlert(userMessage: "Enter your email and password")
            return
        } else if email.text == "" {
            displayAlert(userMessage: "Email Missing!!!")
            pwd.text = ""
            return
        } else if pwd.text == "" {
            displayAlert(userMessage: "Password Missing!!!")
            email.text = ""
            return
        }
        Udacity.sharedInstance().authenticate(email.text! , pwd.text!) { (success , error) in
            print("\(success) in login")
            if error == nil {
                print("Its working till here")
                performUIUpdatesOnMainThread {
                    self.performSegue(withIdentifier: "loginSuceesful", sender: nil)
                }
            } else {
                print("There was an error")
                performUIUpdatesOnMainThread {
                    self.displayAlert(userMessage: error!)
                }
                
            }
        }
    }
    
    @IBAction func signUp (_ sender: Any) {
        UIApplication.shared.open (URL(string: Constants.UdacityConstants.ApiSignUpURL)!, options: [:], completionHandler: nil)
    }
    
}

