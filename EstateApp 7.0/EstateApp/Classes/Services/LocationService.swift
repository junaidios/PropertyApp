//
//  LocationService.swift
//  EstateApp
//
//  Created by JayD on 21/06/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class LocationService: BaseService {
   
    
    class func loadListOfLocationWhereInput(input:String, success:successBlock, failure:failureBlock) -> Void
    {
        let googleURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?types=geocode&key=AIzaSyAnGOE9j4H7JJ9mrl5Y9_GyBq2Gf-9bPa4&input=";
        
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
