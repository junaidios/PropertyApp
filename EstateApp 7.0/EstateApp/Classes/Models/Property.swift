//
//  Property.swift
//  EstateApp
//
//  Created by JayD on 12/10/2015.
//  Copyright © 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class Property : BaseEntity {
    
    
    var propertyId :String?
    var titleMsg :String?
    var size :String?
    var type :String?
    var demand :String?
    var condition :String?
    var detail :String?
    var numOfRoom :String?
    var numOfBath :String?
    var latitude :String?
    var longitude :String?
    var city :String?
    var country :String?
    var specialMsg :String?
    var ownerName :String?
    var ownerNumber :String?
    var ownerAddress :String?
    var ownerEmail :String?
    var photo :String?

//"propertyid": "1",
//"title_msg": "test",
//"size": "24",
//"type": "1",
//"demand": "24000",
//"condition": "new",
//"detail": "no desp",
//"number_of_rooms": "3",
//"number_of_baths": "4",
//"city": "24000",
//"country": "30000",
//"latitude": "34.5",
//"longitude": "71.5",
//"special_msg": "eid mubarak",
//"owner_number": null,
//"owner_name": null,
//"owner_address": null,
//"owner_email": null,
//"photos": []
    
    
    func mapPropertyUsing(data: NSDictionary) -> Property{
        
        self.propertyId = data["propertyid"] as? String;
        self.titleMsg = data["title_msg"] as? String;
        self.size = data["size"] as? String;
        self.type = data["type"] as? String;
        self.demand = data["demand"] as? String;
        self.condition = data["condition"] as? String;
        self.detail = data["detail"] as? String;
        self.numOfRoom = data["number_of_rooms"] as? String;
        self.numOfBath = data["number_of_baths"] as? String;
        self.city = data["city"] as? String;
        self.country = data["country"] as? String;
        self.latitude = data["latitude"] as? String;
        self.longitude = data["longitude"] as? String;
        self.specialMsg = data["special_msg"] as? String;
        self.ownerNumber = data["owner_number"] as? String;
        self.ownerName = data["owner_name"] as? String;
        self.ownerAddress = data["owner_address"] as? String;
        self.ownerEmail = data["owner_email"] as? String;
        let arr = data["photos"] as? NSArray;
        self.photo = ""
        
        if let subURL = arr?.firstObject as? String {
            self.photo = baseURLString.stringByAppendingString(subURL)
        }
        
        return self;
    }
    
}
