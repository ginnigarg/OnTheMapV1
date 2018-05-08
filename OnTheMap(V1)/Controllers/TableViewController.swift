//
//  TableViewController.swift
//  OnTheMap(V1)
//
//  Created by Guneet Garg on 06/05/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit

class TableViewController : UITableViewController {
    
    @IBOutlet var studentTableView: UITableView!
    
    override func viewDidLoad () {
        super.viewDidLoad ()
        performUIUpdatesOnMainThread {
            self.getStudentsData ()
        }
    }
    
    @IBAction func logOut (_ sender: Any) {
        Udacity.sharedInstance().logOut { (data,error) in
            if error == nil {
                performUIUpdatesOnMainThread {
                    self.dismiss(animated: true, completion: nil)
                }
                return
            } else {
                performUIUpdatesOnMainThread {
                    self.displayAlert(userMessage: "Logout Failed")
                }
            }
        }
    }
    
    @IBAction func add (_ sender: Any) {
        performUIUpdatesOnMainThread {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LocationAddViewController") as! LocationAddViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func refresh (_ sender: Any) {
        getStudentsData()
    }
    
    func getStudentsData () {
        Parse.sharedInstance().getStudentsInformation {(success ,data , error) in
            if error == nil && success == true {
                performUIUpdatesOnMainThread {
                    self.studentTableView.reloadData()
                }
            }
        }
    }
    
    override func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count =  Constants.studentDetails.count
        return count
    }
    
    
    override func tableView (_ tableView: UITableView , didSelectRowAt indexPath : IndexPath) {
        let application = UIApplication.shared
        let url = URL(string : Constants.studentDetails[indexPath.row].url)
        if url?.scheme == "https" {
            application.open(url!)
        } else {
            displayAlert(userMessage: "Invalid URL")
        }
        performUIUpdatesOnMainThread {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell (withIdentifier: "dataCell", for: indexPath)
        self.tableView.rowHeight = 70
        let information = Constants.studentDetails[(indexPath as NSIndexPath).row]
        if #available(iOS 8.0, *) {
            tableCell.textLabel?.text = information.firstName! + " " + information.lastName!
            tableCell.detailTextLabel?.text = information.url
        }
        return tableCell
    }
    
    
    
    
    
    
}

