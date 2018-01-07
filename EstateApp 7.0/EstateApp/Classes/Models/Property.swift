//
//  Property.swift
//  EstateApp
//
//  Created by JayD on 12/10/2015.
//  Copyright © 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class Property : BaseEntity {
    
    var propertyId : String = ""
    var titleMsg : String = ""
    var size : String = ""
    var type : String = ""
    var demand : String = ""
    var condition : String = ""
    var detail : String = ""
    var numOfRoom : String = ""
    var numOfBath : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var city : String = ""
    var country : String = ""
    var specialMsg : String = ""
    var ownerName : String = ""
    var ownerNumber : String = ""
    var ownerAddress : String = ""
    var ownerEmail : String = ""
    var distance : String = ""
    var duration : String = ""
    var distanceValue : Int = 0
    var durationValue : Int = 0
    var photo : String = ""
    var photos = [String]();

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
    
    
    func mapPropertyUsing(data: [String: Any]) -> Void {
        
        let list : [String] = [
            //                "Any Type",
            //            "--------- Homes ---------",
            "Houses",
            "Flats",
            "Upper Portions",
            "Lower Portions",
            "Farm Houses",
            "Rooms",
            "Penthouse",
            //            "--------- Plots ---------",
            "Residential Plots",
            "Commercial Plots",
            "Agricultural Land",
            "Industrial Land",
            "Plot Files",
            "Plot Forms",
            //            "--------- Commercial ---------",
            "Offices",
            "Shops",
            "Warehouses",
            "Factories",
            "Buildings",
            "Other"];

        
        self.propertyId = String.stringValue(data["propertyid"]);
        self.titleMsg = String.stringValue(data["title_msg"]);
        self.size = String.stringValue(data["size"]);
        let typeId = String.numberValue(data["type"] as AnyObject).intValue;
        self.type = list[typeId];
        self.demand = String.stringValue(data["demand"]);
        self.condition = String.stringValue(data["condition"]);
        self.detail = String.stringValue(data["detail"]);
        self.numOfRoom = String.stringValue(data["number_of_rooms"]);
        self.numOfBath = String.stringValue(data["number_of_baths"]);
        self.city = String.stringValue(data["city"]);
        self.country = String.stringValue(data["country"]);
        self.latitude = String.stringValue(data["latitude"]);
        self.longitude = String.stringValue(data["longitude"]);
        self.specialMsg = String.stringValue(data["special_msg"]);
        self.ownerNumber = String.stringValue(data["owner_number"]);
        self.ownerName = String.stringValue(data["owner_name"]);
        self.ownerAddress = String.stringValue(data["owner_address"]);
        self.ownerEmail = String.stringValue(data["owner_email"]);
        if let arr = data["photos"] as? [String] {
            self.photo = ""
            if let subURL = arr.first {
                self.photo = BASE_URL.appendingFormat(subURL)
            }
            
            for url in arr {
                self.photos.append(BASE_URL.appendingFormat(url ))
            }
        }
        
    }
    
}
