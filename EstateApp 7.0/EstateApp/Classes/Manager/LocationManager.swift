//
//  LocationManager.swift
//  MayDay
//
//  Created by Junaid on 17/11/2014.
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
        
        if self.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization)) {
            
            self.requestAlwaysAuthorization()
        }
        
    }
    
    func checkGPSStatus() -> Bool {
        
        var output : Bool = false
        
        let status : CLAuthorizationStatus = CLLocationManager.authorizationStatus();
        
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
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

        
        print(error.localizedDescription);
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
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
            
            if gpsDataType == GPSDataType.GPSDataTypeAddress{
                getAddressFromLocation(locationObj)
            }
            else
            {
                self.completionBlock(data: locationObj)
            }
        }
    }
    
    private func getAddressFromLocation(location: CLLocation) -> (){
        
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
                            address = addressLines.componentsJoinedByString(", ")
                        } else {
                            address = ""
                        }
                        
                        self.completionBlock(data: address)
                    }
                }
        })
    }
    
    func getAddressFromLocation(location: CLLocation, completion: completeBlock) -> (){
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                    completion(data: error!.localizedDescription);
                }
                else
                {
                    for  placemark in placemarks! {
                        let pm : CLPlacemark = placemark
                        let addressLines = pm.addressDictionary?["FormattedAddressLines"] as! NSArray
                        var address = "";
                        if addressLines.count>0 {
                            address = addressLines.componentsJoinedByString(", ")
                        } else {
                            address = ""
                        }
                        
                        completion(data: address)
                    }
                }
        })
    }
    
    
    func getLocationFromAddress(address: String , completion: completeBlock) -> (){
        
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            
            if error == nil {
                
                for  placemark in placemarks! {
                    
                    let pm : CLPlacemark = placemark
                    completion(data: pm.location);
                }
            }
            
        })
    }
    
//    NSString *address = [NSString stringWithFormat:@"%@,%@,%@", self.streetField.text, self.cityField.text,self.countryField.text];
//    
//    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error)
//    {
//    if(!error)
//    {
//    CLPlacemark *placemark = [placemarks objectAtIndex:0];
//    NSLog(@"%f",placemark.location.coordinate.latitude);
//    NSLog(@"%f",placemark.location.coordinate.longitude);
//    NSLog(@"%@",[NSString stringWithFormat:@"%@",[placemark description]]);
//    }
//    else
//    {
//    NSLog(@"There was a forward geocoding error\n%@",[error localizedDescription]);
//    }
//    }
//    ];

}


