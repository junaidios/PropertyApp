//
//  Location.swift
//  Velodrome
//
//  Created by JayD on 09/02/2016.
//  Copyright © 2016 Junaid iOS. All rights reserved.
//

import UIKit

class Location: BaseEntity {

    
    var locId :String?
    var placeId :String?
    var titleMsg :String?
    var latitude :String = ""
    var longitude :String = ""
    var distance :String = ""
    var durations :String = ""
    
    
    func mapLocationUsing(data: NSDictionary) -> Location{
        
        self.locId = data["id"] as? String;
        self.placeId = data["place_id"] as? String;
        self.titleMsg = data["description"] as? String;
        
        return self;
    }
    
    func mapLocationDetailsUsing(data: NSDictionary) -> Location{
        
        self.locId = data["id"] as? String;
        self.placeId = data["place_id"] as? String;
        self.titleMsg = data["name"] as? String;
        let geometry = data["geometry"] as! NSDictionary;
        let location = geometry["location"] as! NSDictionary;
        
        let latInNumber = location["lat"] as! NSNumber;
        let lngInNumber = location["lng"] as! NSNumber;
        
        self.latitude =  latInNumber.stringValue;
        self.longitude = lngInNumber.stringValue;
        
        return self;
    }
    
    
    //                "geometry" : {
    //                    "location" : {
    //                        "lat" : -33.8669710,
    //                        "lng" : 151.1958750
    //                    }
    //                },
    //                "id" : "4f89212bf76dde31f092cfc14d7506555d85b5c7",
    //                "name" : "Google Sydney",
    //                "place_id" : "ChIJN1t_tDeuEmsRUsoyG83frY4",
    
}
