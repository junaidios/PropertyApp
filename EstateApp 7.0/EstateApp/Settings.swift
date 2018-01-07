//
//  User.swift
//  EstateApp
//
//  Created by JayD on 21/06/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class Settings: BaseEntity, NSCoding { 
 
    var isCustomLocation : Bool = false
    var latitude : String = ""
    var longitude : String = ""
    var radius : String = ""
    var locationName : String = ""

    var rooms : String = ""
    var baths : String = ""
    var minPrice : String = ""
    var maxPrice : String = ""
    
    var radiusPriority: String = "10"
    var pricePriority : String = "10"
    var roomsPriority : String = "10"
    var bathsPriority : String = "10"
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {

        aCoder.encode(isCustomLocation, forKey:"isCustomLocation")
        aCoder.encode(latitude,         forKey:"latitude")
        aCoder.encode(longitude,        forKey:"longitude")
        aCoder.encode(radius,           forKey:"radius")
        aCoder.encode(locationName,     forKey:"locationName")
        aCoder.encode(rooms,            forKey:"rooms")
        aCoder.encode(baths,            forKey:"baths")
        aCoder.encode(minPrice,         forKey:"minPrice")
        aCoder.encode(maxPrice,         forKey:"maxPrice")
        
        aCoder.encode(radiusPriority,   forKey:"radiusPriority")
        aCoder.encode(pricePriority,    forKey:"pricePriority")
        aCoder.encode(roomsPriority,    forKey:"roomsPriority")
        aCoder.encode(bathsPriority,    forKey:"bathsPriority")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        self.isCustomLocation   = aDecoder.decodeBool(forKey: "isCustomLocation") ;
        self.latitude           = aDecoder.decodeObject(forKey: "latitude") as! String;
        self.longitude          = aDecoder.decodeObject(forKey:"longitude") as! String;
        self.radius             = aDecoder.decodeObject(forKey:"radius") as! String;
        self.locationName       = aDecoder.decodeObject(forKey:"locationName") as! String;
        self.rooms              = aDecoder.decodeObject(forKey:"rooms") as! String;
        self.baths              = aDecoder.decodeObject(forKey:"baths") as! String;
        self.minPrice           = aDecoder.decodeObject(forKey:"minPrice") as! String;
        self.maxPrice           = aDecoder.decodeObject(forKey:"maxPrice") as! String;

        self.radiusPriority     = aDecoder.decodeObject(forKey:"radiusPriority") as! String;
        self.pricePriority      = aDecoder.decodeObject(forKey:"pricePriority") as! String;
        self.roomsPriority      = aDecoder.decodeObject(forKey:"roomsPriority") as! String;
        self.bathsPriority      = aDecoder.decodeObject(forKey:"bathsPriority") as! String;
    }
    
    class func loadSettings()  -> Settings{
        
        if let  archivedObject = UserDefaults.standard.object(forKey: "Settings"){
            
            let settings  = NSKeyedUnarchiver.unarchiveObject(with: (archivedObject as! NSData) as Data) as! Settings;
        
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
            settings.maxPrice = "800000";
            
            settings.pricePriority  = "10";
            settings.radiusPriority = "10";
            settings.roomsPriority  = "10";
            settings.bathsPriority  = "10";
            
            return settings;
        }
    }
    
    func saveSettings(){
        
        let archivedObject : NSData = NSKeyedArchiver.archivedData(withRootObject: self) as NSData
        
        UserDefaults.standard.set(archivedObject, forKey: "Settings");
        
        UserDefaults.standard.synchronize();
    }
    
    func deleteSettings(){
        
        UserDefaults.standard.set(nil, forKey: "Settings")

        UserDefaults.standard.synchronize();
    }
}
