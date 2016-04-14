//
//  User.swift
//  EstateApp
//
//  Created by JayD on 21/06/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class Settings: BaseEntity {
 
    var isCustomLocation : Bool = false
    var latitude : String = ""
    var longitude : String = ""
    var radius : String = ""
    var locationName : String = ""

    var rooms : String = ""
    var baths : String = ""
    var minPrice : String = ""
    var maxPrice : String = ""
    
    override init() {
        super.init()
    }
    
    
    func encodeWithCoder(aCoder: NSCoder!) {
        
        aCoder.encodeBool(isCustomLocation,    forKey:"isCustomLocation")
        aCoder.encodeObject(latitude,          forKey:"latitude")
        aCoder.encodeObject(longitude,         forKey:"longitude")
        aCoder.encodeObject(radius,            forKey:"radius")
        aCoder.encodeObject(locationName,      forKey:"locationName")
        aCoder.encodeObject(rooms,             forKey:"rooms")
        aCoder.encodeObject(baths,             forKey:"baths")
        aCoder.encodeObject(minPrice,          forKey:"minPrice")
        aCoder.encodeObject(maxPrice,          forKey:"maxPrice")
    }
    
    
    init(coder aDecoder: NSCoder) {
        
        super.init()
        
        self.isCustomLocation   = aDecoder.decodeBoolForKey("isCustomLocation") ;
        self.latitude           = aDecoder.decodeObjectForKey("latitude") as! String;
        self.longitude          = aDecoder.decodeObjectForKey("longitude") as! String;
        self.radius             = aDecoder.decodeObjectForKey("radius") as! String;
        self.locationName       = aDecoder.decodeObjectForKey("locationName") as! String;
        self.rooms              = aDecoder.decodeObjectForKey("rooms") as! String;
        self.baths              = aDecoder.decodeObjectForKey("baths") as! String;
        self.minPrice           = aDecoder.decodeObjectForKey("minPrice") as! String;
        self.maxPrice           = aDecoder.decodeObjectForKey("maxPrice") as! String;
    }
    
    
    class func loadSettings()  -> Settings{
        
        if let  archivedObject = NSUserDefaults.standardUserDefaults().objectForKey("Settings"){
            
            let settings  = NSKeyedUnarchiver.unarchiveObjectWithData(archivedObject as! NSData) as! Settings;
        
            return settings;
        }
        else {
            
            let settings = Settings();
            
            settings.isCustomLocation = false;
            settings.radius = "20";
            settings.rooms = "3";
            settings.latitude = "00.00";
            settings.longitude = "00.00";
            settings.baths = "2";
            settings.minPrice = "20000";
            settings.maxPrice = "8000000";
            
            return settings;
        }
    }
    
    
    func saveSettings(){
        
        let archivedObject : NSData = NSKeyedArchiver.archivedDataWithRootObject(self)
        
        NSUserDefaults.standardUserDefaults().setObject(archivedObject, forKey: "Settings");
        
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    
    
    func deleteSettings(){
        
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "Settings")

        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
}
