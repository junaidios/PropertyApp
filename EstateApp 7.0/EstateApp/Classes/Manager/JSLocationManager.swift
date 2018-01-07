//
//  LocationManager.swift
//  MayDay
//
//  Created by Junaid on 17/11/2014.
//  Copyright (c) 2014 Coeus Solutions GmbH. All rights reserved.
//

enum RequestType: Int{
    case address
    case coordinate
}

typealias completeBlock =  (_ data: AnyObject?) -> ()

import Foundation
import CoreLocation

class JSLocationManager : CLLocationManager, CLLocationManagerDelegate {
    
    var _latitude : String = "";
    var _longitude : String = "";
    var requestType : RequestType = .address;
    var completionBlock: completeBlock = {(_) -> () in };
    
    class var sharedInstance : JSLocationManager {
        struct Static {
            static let instance : JSLocationManager = JSLocationManager()
            
        }
        return Static.instance
    }
    
    func getUserCurrentLocation(_ type:RequestType, completion: @escaping completeBlock){
        
        requestType = type;
        
        self.completionBlock = completion;
        
        self.desiredAccuracy = kCLLocationAccuracyBest
        
        self.delegate = self
        
        self.startUpdatingLocation()
        
        //        if self.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
        //
        //            self.requestAlwaysAuthorization()
        //        }
        
        if self.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            
            self.requestWhenInUseAuthorization()
        }
    }
    
    func checkGPSStatus() -> Bool {
        
        var output : Bool = false
        
        let status : CLAuthorizationStatus = CLLocationManager.authorizationStatus();
        
        switch status {
        case CLAuthorizationStatus.restricted:
            output = false
        case CLAuthorizationStatus.denied:
            output = false
        case CLAuthorizationStatus.notDetermined:
            output = false
        default:
            output = true
        }
        
        return output
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error.localizedDescription);
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(locations.count > 0)
        {
            
            self.stopUpdatingLocation()
            self.delegate = nil
            
            let locationArray = locations as NSArray
            let locationObj = locationArray.firstObject as! CLLocation
            let coord = locationObj.coordinate
            
            print(coord.latitude)
            print(coord.longitude)
            
            _latitude = String(format: "%f", coord.latitude)
            _longitude = String(format: "%f", coord.longitude)
            
            if requestType == .address{
                getAddressFromLocation(locationObj)
            }
            else
            {
                self.completionBlock(locationObj)
            }
        }
    }
    
    fileprivate func getAddressFromLocation(_ location: CLLocation) -> (){
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                else
                {
                    for  placemark in placemarks! {
                        let pm : CLPlacemark = placemark
                        let addressLines = pm.addressDictionary?["FormattedAddressLines"] as! NSArray
                        var address = "";
                        if addressLines.count>0 {
                            address = addressLines.componentsJoined(by: ", ")
                        } else {
                            address = ""
                        }
                        
                        self.completionBlock(address as AnyObject?)
                    }
                }
        })
    }
    
    func getAddressFromLocation(_ location: CLLocation, completion: @escaping completeBlock) -> (){
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                    completion(error!.localizedDescription as AnyObject?);
                }
                else
                {
                    for  placemark in placemarks! {
                        var address = "";
                        let pm : CLPlacemark = placemark
                        
                        if let addressLines = pm.addressDictionary?["FormattedAddressLines"] as? NSArray {
                            print(addressLines)
                            if addressLines.count>0 {
                                for str in addressLines {
                                    
                                    if address.length != 0 {
                                        address = address + ", ";
                                    }
                                    
                                    let _address = str as! String;
                                    
                                    address = address + _address;
                                    
                                }
                            } else {
                                address = ""
                            }
                        }
                        completion(address as AnyObject?)
                    }
                }
        })
    }
    
    func getLocationFromAddress(_ address: String , completion: @escaping completeBlock) -> (){
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            
            if error != nil {
                print("get location failed : \(error!.localizedDescription)")
                completion(error!.localizedDescription as AnyObject?)
            }
                
            else {
                
                for  placemark in placemarks! {
                    let pm : CLPlacemark = placemark
                    completion(pm.location);
                    break;
                }
                
            }
            
        })
    }
}




