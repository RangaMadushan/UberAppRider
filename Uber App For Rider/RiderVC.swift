//
//  RiderVC.swift
//  Uber App For Rider
//
//  Created by Ranga Madushan on 3/17/18.
//  Copyright © 2018 Ranga Madushan. All rights reserved.
//

import UIKit
import MapKit

class RiderVC: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var myMap: MKMapView!

    private var locationManager = CLLocationManager();
    private var userLocation: CLLocationCoordinate2D?;
    //    private var driverLocation: CLLocationCoordinate2D?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeLocationManager();
    }
    
    
    
    private func initializeLocationManager() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
        
    }// func initlize location
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //if we have the coordinates from the manager
        if let location = locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude);
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01));
            
            myMap.setRegion(region, animated: true);
            myMap.removeAnnotations(myMap.annotations);
            
            let annotation = MKPointAnnotation();
            annotation.coordinate = userLocation!;
            annotation.title = "Driver Location";
            myMap.addAnnotation(annotation);
            
        }
    } //an overide func
    

    
 


    @IBAction func callUber(_ sender: AnyObject) {
        
        
    }//call uber btn
    
    
    
    
    @IBAction func logout(_ sender: AnyObject) {
        
        if AuthProvider.Instance.logOut() {
        
            dismiss(animated: true, completion: nil)
            
        }else{
         
            //problem with loging out
            self.alertTheUser(title: "Could Not Logout", message: "We could not logout at the moment, please try again later")
        }
    }//log out btn
    
    
    
    
    private func alertTheUser(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    } //func alert user
    

}// class






























