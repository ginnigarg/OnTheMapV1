//
//  MapViewController.swift
//  OnTheMap(V1)
//
//  Created by Guneet Garg on 06/05/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController : UIViewController , MKMapViewDelegate {
    
    @IBOutlet weak var geoView : MKMapView!
    
    var annotations = [MKPointAnnotation] ()
    
    override func viewDidLoad () {
        super.viewDidLoad ()
        geoView.delegate = self
        performUIUpdatesOnMainThread {
            self.getStudentsData()
        }
    }
    
    override func viewWillAppear (_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func logOut (_ sender: Any) {
        Udacity.sharedInstance().logOut{ (data ,error) in
            if error == nil {
                performUIUpdatesOnMainThread {
                    self.dismiss (animated: true, completion: nil)
                }
                return
            } else {
                performUIUpdatesOnMainThread {
                    self.displayAlert (userMessage: "Logout Failed")
                }
            }
        }
    }
    
    @IBAction func refresh (_ sender: Any) {
        self.geoView.removeAnnotations (self.geoView.annotations)
        getStudentsData ()
    }
    
    @IBAction func add (_ sender: Any) {
        performUIUpdatesOnMainThread {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LocationAddViewController") as! LocationAddViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func getStudentsData () {
        Parse.sharedInstance().getStudentsInformation () { (success , data , error) in
            if success == false {
                performUIUpdatesOnMainThread {
                    self.displayAlert(userMessage: error!)
                }
            } else {
                for data in data!{
                    let firstName = data.firstName
                    let lastName = data.lastName
                    let url = data.url
                    let latitude = data.lat
                    let longitude = data.long
                    if #available(iOS 8.0, *){
                        let annotation = MKPointAnnotation ()
                        let latitudeDegees = CLLocationDegrees(latitude)
                        let longitudeDegrees = CLLocationDegrees(longitude)
                        let coord = CLLocationCoordinate2DMake(latitudeDegees, longitudeDegrees)
                        annotation.coordinate = coord
                        annotation.title = "\(firstName ?? "NO") \(lastName ?? "Name")"
                        if url.isEmpty == false {
                            annotation.subtitle = url
                        } else {
                            annotation.subtitle = "No URL Available"
                        }
                        self.annotations.append (annotation)
                    }
                }
                performUIUpdatesOnMainThread {
                    //self.geoView.removeAnnotations (self.annotations)
                    self.geoView.addAnnotations (self.annotations)
                }
            }
        }
    }
    
    func mapView (_ geoView : MKMapView, viewFor annotation : MKAnnotation) -> MKAnnotationView? {
        var pin = geoView.dequeueReusableAnnotationView (withIdentifier : "Pin") as? MKPinAnnotationView
        if pin != nil {
            pin!.annotation = annotation
        } else {
            pin = MKPinAnnotationView (annotation : annotation, reuseIdentifier : "Pin")
            pin!.canShowCallout = true
            pin!.pinTintColor = .red
            pin!.rightCalloutAccessoryView = UIButton (type : .infoDark)
        }
        return pin
    }
    
    func mapView (_ geoView : MKMapView, annotationView view : MKAnnotationView, calloutAccessoryControlTapped control : UIControl){
        if control == view.rightCalloutAccessoryView {
            if let open = view.annotation?.subtitle! {
                let url = URL (string : open)
                UIApplication.shared.open (url!)
            }
        }
    }
    
}

    
    


