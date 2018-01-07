//
//  LocationService.swift
//  EstateApp
//
//  Created by JayD on 21/06/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit

let GOOGLE_MAP_API_KEY =  "AIzaSyBN_ipthjGqZxDee2E1U3yM_cnzDopRlyU" // Client Key 150k limit.

class LocationService: BaseService {
    
    
    class func getPropertyDurationsFromCurrentLocation ( locations: [Property], success:@escaping successBlock, failure:@escaping failureBlock) -> Void {
        
        let setting = Settings.loadSettings();
        
        let myLocation = CLLocationCoordinate2DMake(Double(setting.latitude)!, Double(setting.longitude)!);
        
        let origins = "\(myLocation.latitude),\(myLocation.longitude)";
        
        var destinations = ""
        
        for location in locations {
            
            if destinations.length != 0 {
                destinations = destinations + "|";
            }
            destinations = destinations + location.latitude+","+location.longitude;
        }
        
        let params = ("origins=\(origins)&destinations=\(destinations)&key=" + GOOGLE_MAP_API_KEY).urlEncoding;
        
        let uri = "https://maps.googleapis.com/maps/api/distancematrix/json?" + params;
        
        print("duration url" , uri)
        
        let url = URL(string: uri);
        
        var distanceMatrixes = [(String, Int, String, Int)]();
        
        NetworkManager.requestURL(url!, success: { (data) in
            
            DispatchQueue.main.async() {
                
                if let resultData = data as? [String: AnyObject] {
                    
                    if let rowsArray = resultData ["rows"] as? [[String : AnyObject]] {
                        
                        if let row = rowsArray.first {
                            
                            let elementsArray = row["elements"] as! [[String : AnyObject]];
                            
                            for i in 0..<elementsArray.count {
                                
                                let element = elementsArray[i];
                                
                                var tupple : (String, Int, String, Int) = ("", 0, "", 0)
                                
                                if element["status"] as! String == "OK" {
                                    
                                    if let elementDuration =  element["duration"] as? [String: AnyObject]{
                                        tupple.0 = String.stringValue(elementDuration["text"]);
                                        tupple.1 = String.numberValue(elementDuration["value"]).intValue;
                                    }
                                    if let elementDistance =  element["distance"] as? [String: AnyObject]{
                                        
                                        tupple.2 = String.stringValue(elementDistance["text"]);
                                        tupple.3 = String.numberValue(elementDistance["value"]).intValue;
                                    }
                                }

                                distanceMatrixes.append(tupple);
                            }
                        }
                    }
                }
                
                success(distanceMatrixes as AnyObject);
            }
            
        }) { (error) in
            
            failure(error!);
        }
        
    }
    
    
    class func loadListOfLocationWhereInput(input:String, success:@escaping successBlock, failure:@escaping failureBlock) -> Void
    {
        let params = ("types=geocode&key=AIzaSyAnGOE9j4H7JJ9mrl5Y9_GyBq2Gf-9bPa4&input=\(input)").urlEncoding
        
        let googleURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?" + params
        
        let url = URL(string: googleURL);
        
        NetworkManager.requestURL(url!, success: { (data) in
            
            if let jsonData = data as? [String: Any] {
                
                var locationList = [Location]();
                if let dataList = jsonData["predictions"] as? [[String: Any]] {
                    
                    for obj in dataList {
                        
                        let place = Location();
                        place.mapLocationUsing(data: obj);
                        locationList.append(place);
                    }
                    
                    success(locationList as AnyObject);
                }
            }
            
        }) { (error) in
            
            failure(error!);
        }
    }
    
    class func loadDetailOfLocationWherePlaceId(placeId:String, success:@escaping successBlock, failure:@escaping failureBlock) -> Void
    {
        let googleURL = "https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyAnGOE9j4H7JJ9mrl5Y9_GyBq2Gf-9bPa4&placeid=";
        
        let url = URL(string: googleURL+placeId);
        
        NetworkManager.requestURL(url!, success: { (data) in
            
            if let jsonData = data as? [String : Any] {
                
                if let dataList = jsonData["result"] as? [String : Any]  {
                    
                    let locationObj = Location().mapLocationDetailsUsing(data: dataList);
                    
                    success(locationObj);
                }
            }
        }) { (error) in
            
            failure(error!);
        }
    }
    
}
