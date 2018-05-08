//
//  LocationUpdateViewController.swift
//  OnTheMap(V1)
//
//  Created by Guneet Garg on 06/05/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class LocationUpdateViewController : UIViewController , MKMapViewDelegate {
    
    @IBOutlet weak var geoView: MKMapView!

    let annotations = MKPointAnnotation()
    var latitude : CLLocationDegrees = 0.0
    var longitude : CLLocationDegrees = 0.0
    
    @IBAction func cancel (_ sender: Any) {
        performUIUpdatesOnMainThread {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search()
    }
    
    func newController() {
        performUIUpdatesOnMainThread {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            self.present(controller!, animated : true, completion : nil)
        }
    }
    
    func search () {
        let geoCoder = CLGeocoder ()
        geoCoder.geocodeAddressString(LocationAddViewController.location!) { (placemarks, error) in
            let pin = placemarks?.first
            if let pin = pin {
                let coord = pin.location?.coordinate
                let span = MKCoordinateSpanMake(0.005, 0.005)
                let region = MKCoordinateRegionMake(coord!, span)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coord!
                self.latitude = (coord?.latitude)!
                self.longitude = (coord?.longitude)!
                performUIUpdatesOnMainThread {
                    self.geoView.removeAnnotation(annotation)
                    self.geoView.addAnnotation(annotation)
                    self.geoView.setRegion(region, animated: true)
                }
            } else {
                performUIUpdatesOnMainThread {
                    self.displayAlert(userMessage: "Unable to locate the location")
                }
            }
        }
    }
    
    @IBAction func finish(_ sender: Any) {
        Parse.sharedInstance().taskForPOSTMethod(location : LocationAddViewController.location!, url : LocationAddViewController.link!, lat : latitude, long : longitude) { (success , result , error ) in
            if error == nil {
                _ = result
            } else {
                performUIUpdatesOnMainThread {
                    self.displayAlert(userMessage: "There was network issues while posting")
                }
            }
            performUIUpdatesOnMainThread {
                self.newController()
            }
        }
    }
}

    


