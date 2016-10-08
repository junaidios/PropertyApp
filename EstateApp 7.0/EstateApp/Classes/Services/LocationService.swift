//
//  LocationService.swift
//  EstateApp
//
//  Created by JayD on 21/06/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit

let GOOGLE_MAP_API_KEY =  "AIzaSyAYWL9f5KC76Bj0OchDwCRFvuYk_z_jjDg" // Client Key 150k limit.

class LocationService: BaseService {
   
    
    class func getPropertyDurationsFromCurrentLocation (locations : [Property], success:successBlock, failure:failureBlock) -> Void {
        
        
        let setting = Settings.loadSettings();
        
        let myLocation = CLLocationCoordinate2DMake(Double(setting.latitude)!, Double(setting.longitude)!);
        
        let origins = "\(myLocation.latitude),\(myLocation.longitude)";
        
        var destinations = ""
        
        for location in locations {
            
            
            if destinations.length != 0 {
                destinations = destinations + "|";
            }
            
            
            destinations = destinations + location.latitude!+","+location.longitude!;
    
        }
        var uri = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(origins)&destinations=\(destinations)&key="+GOOGLE_MAP_API_KEY
        
        print("duration url" , uri)
        
        uri = uri.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!;
        let url = NSURL(string: uri);
        let request = NSURLRequest(URL: url!);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if (data  != nil){
                
                if let jsonData = LocationService().dataToJSON(data!) {
                    
                    print(jsonData)
                    
                    let resultData = jsonData as! [String : AnyObject]
                    
                    let rowsArray = resultData ["rows"] as! [[String : AnyObject]]
                    
                    
                    if let row = rowsArray.first {
                        
                        let elementsArray = row["elements"] as! [[String : AnyObject]];
                        
                        for i in 0..<elementsArray.count {
                            
                            let element = elementsArray[i];
                            
                            if element["status"] as! String == "OK" {
                                
                                let location = locations[i];
                                
                                if let elementDuration =  element["duration"] as? [String: AnyObject]{
                                    
                                    let duration = elementDuration["text"] as! String;
                                    location.duration = duration;
                                }
                                if let elementDistance =  element["distance"] as? [String: AnyObject]{
                                    
                                    let distance = elementDistance["text"] as! String;
                                    location.distance = distance;
                                }
                            }
                        }
                        
                    }
                    
                    success(data: "");
                    
                }
            }
            
        }
        
    }

    
    class func loadListOfLocationWhereInput(input:String, success:successBlock, failure:failureBlock) -> Void
    {
        let googleURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?types=geocode&key="+GOOGLE_MAP_API_KEY+"&input=";
        
        var baseURL = googleURL+input;
        baseURL = baseURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!;
        let url = NSURL(string: baseURL);
        let request = NSURLRequest(URL: url!);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            
            if (data  != nil){
                
                if let jsonData = LocationService().dataToJSON(data!) {
                    
                    print(jsonData);
                    
                    let locationList : NSMutableArray = NSMutableArray();
                    let dataList : NSArray = jsonData["predictions"] as! NSArray
                    
                    for obj in dataList {
                        
                        let place = Location();
                        place.mapLocationUsing(obj as! NSDictionary);
                        
                        locationList.addObject(place);
                    }
                    
                    success(data: locationList);
                }
                else{
                    
                    failure(error: error!);
                }
            }
            else{
                
                failure(error: error!);
            }
        };
    }
    
    class func loadDetailOfLocationWherePlaceId(placeId:String, success:successBlock, failure:failureBlock) -> Void
    {
        let googleURL = "https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyAnGOE9j4H7JJ9mrl5Y9_GyBq2Gf-9bPa4&placeid=";
        
        var baseURL = googleURL+placeId;
        baseURL = baseURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!;
        let url = NSURL(string: baseURL);
        let request = NSURLRequest(URL: url!);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if let jsonData = LocationService().dataToJSON(data!) {
                
                let dataList : NSDictionary = jsonData["result"] as! NSDictionary;
                
                let locationObj = Location().mapLocationDetailsUsing(dataList);
                
                success(data: locationObj);
            }
            else{
                
                failure(error: error!);
            }
        };
    }
    
    func dataToJSON(data: NSData) -> AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
