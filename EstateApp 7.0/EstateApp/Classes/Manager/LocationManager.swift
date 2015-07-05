//
//  LocationManager.swift
//  MayDay
//
//  Created by OBAID on 17/11/2014.
//  Copyright (c) 2014 Coeus Solutions GmbH. All rights reserved.
//

enum GPSDataType: Int{
   case GPSDataTypeAddress
   case GPSDataTypeLatLong
}

typealias completeBlock =  (data: AnyObject?) -> ()

import Foundation
import CoreLocation

class LocationManager : CLLocationManager, CLLocationManagerDelegate {
    
    var _latitude : String = "";
    var _longitude : String = "";
    var gpsDataType: GPSDataType = GPSDataType.GPSDataTypeAddress;
    var completionBlock: completeBlock = {(_) -> () in };

    class var sharedInstance : LocationManager {
        struct Static {
            static let instance : LocationManager = LocationManager()
            
        }
        return Static.instance
    }
    
    func getUserCurrentLocation(datatype:GPSDataType, completion: completeBlock){
        
        gpsDataType = datatype;
        
        self.completionBlock = completion;
        
        self.desiredAccuracy = kCLLocationAccuracyBest
        
        self.delegate = self
        
        self.startUpdatingLocation()
        
        if self.respondsToSelector("requestAlwaysAuthorization") {
            
            self.requestAlwaysAuthorization()
        }
        
    }
    
    func checkGPSStatus() -> Bool {
        
        var output : Bool = false
        
        var status : CLAuthorizationStatus = CLLocationManager.authorizationStatus();
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            output = false
        case CLAuthorizationStatus.Denied:
            output = false
        case CLAuthorizationStatus.NotDetermined:
            output = false
        default:
            output = true
        }
        
        return output
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        self.stopUpdatingLocation()
        if ((error) != nil) {
//            completionBlock(error: error, data: nil)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        if ((locations) != nil) {
            
            if(locations.count > 0)
            {
                
                self.stopUpdatingLocation()
                self.delegate = nil
                
                var locationArray = locations as NSArray
                var locationObj = locationArray.firstObject as! CLLocation
                var coord = locationObj.coordinate
                
                println(coord.latitude)
                println(coord.longitude)
                
                _latitude = String(format: "%f", coord.latitude)
                _longitude = String(format: "%f", coord.longitude)
                
                if gpsDataType == GPSDataType.GPSDataTypeAddress{
                    getAddressFromLocation(locationObj)
                }
                else
                {
                    self.completionBlock(data: locationObj)
                }
                
            }
        }
    }
    
    private func getAddressFromLocation(location: CLLocation) -> (){
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    println("reverse geodcode fail: \(error.localizedDescription)")
                }
                else
                {
                    for  placemark in placemarks {
                        var pm : CLPlacemark = placemark as! CLPlacemark
                        var addressLines = pm.addressDictionary["FormattedAddressLines"] as! NSArray
                        var address : NSString = addressLines.componentsJoinedByString(", ");
                        println(address)
                        self.completionBlock(data: address)
                    }
                }
        })
    }
}


