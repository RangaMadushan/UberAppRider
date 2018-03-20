//
//  UberHandler.swift
//  Uber App For Rider
//
//  Created by Ranga Madushan on 3/18/18.
//  Copyright © 2018 Ranga Madushan. All rights reserved.
//

import Foundation
import FirebaseDatabase

//protocol eka
protocol UberController: class {
    func canCallUber(delegateCalled: Bool);
    func driverAcceptedRequest(requestedAccepted: Bool, driverName: String);
}

class UberHandler {

    private static let _instance = UberHandler();
    
    weak var delegate: UberController?;
    
    var rider = "";
    var driver = "";
    var rider_id = "";
    
    static var Instance: UberHandler {
        return _instance;
    }

    
    func observeMessagesForRider() {
    
        //when rider requested an uber this will behave as a trigger
        DBProvider.Instance.requestRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
         if let data = snapshot.value as? NSDictionary {
            if let name = data[Constants.NAME] as? String {
                if name == self.rider {
                
                    self.rider_id = snapshot.key;
                   // print("THE VALUE IS \(self.rider_id)");
                    self.delegate?.canCallUber(delegateCalled: true);
                }
             }
            
           }
        }
        
        //when rider Cancelled an uber this will behave as a trigger
        DBProvider.Instance.requestRef.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.rider {
                        
                        //self.rider_id = snapshot.key;
                        // print("THE VALUE IS \(self.rider_id)");
                        self.delegate?.canCallUber(delegateCalled: false);
                    }
                }
                
            }
        }
        
        //DRIVER ACCEPTED UBER
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
            
                if let name = data[Constants.NAME] as? String {
                    if self.driver == "" {
                        self.driver = name;
                        self.delegate?.driverAcceptedRequest(requestedAccepted: true, driverName: self.driver);
                    }
                }
            }
            
        }
        
        //DRIVER CANCELED UBER
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                
                    if name == self.driver {
                        self.driver = "";
                        self.delegate?.driverAcceptedRequest(requestedAccepted: false, driverName: name);
                    }
                }
            }
            
            
        }
    
    }//observeMessagesForRider
    
    
    func requestUber(latitude: Double, longitude: Double) {
        let data: Dictionary<String, Any> = [Constants.NAME: rider, Constants.LATITUDE: latitude, Constants.LONGITUDE: longitude];
        
        DBProvider.Instance.requestRef.childByAutoId().setValue(data);
    
    }//request uber
    
    
    
    func cancelUber() {
        
        DBProvider.Instance.requestRef.child(rider_id).removeValue();
    }//func cancel uber
    
}// class





























