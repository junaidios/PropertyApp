//
//  EstateService.swift
//  EstateApp
//
//  Created by JayD on 21/06/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class EstateService: BaseService {
   
    
    class func savePropertyWhere(title
                                title:String, size:String, type:String, demand:String, condition:String,
                                latitude:String, longitude:String, city:String, country:String, description:String,
                                specialNote:String, rooms:String, baths:String, kitchen:String,
                                ownerName:String, ownerNumber:String, ownerAddress:String, ownerEmail:String,
                                img1:UIImage?, img2:UIImage?, img3:UIImage?,
                                success:successBlock, failure:failureBlock)
    {
        
        var params =
        [
            "title_msg": title,
            "size": size,
            "type": type,
            "demand": demand,
            
            "city": city,
            "country": country,
            "latitude": latitude,
            "longitude": longitude,
            "condition": condition,
            "detail": description,
            "number_of_rooms": rooms,
            "number_of_baths": baths,
//            "number_of_kitchens": kitchen,
            "special_msg": specialNote,
            "owner_number": ownerName,
            "owner_name": ownerName,
            "owner_address": ownerAddress,
            "owner_email": ownerEmail
        ];
        
        
        if let imgTemp = img1 {
            
            let imgStr = imgTemp.toBase64()
            params["img1"] = imgStr;
        }
        
        if let imgTemp = img2 {
            let imgStr = imgTemp.toBase64()
            params["img2"] = imgStr;
        }
        
        if let imgTemp = img3 {
            let imgStr = imgTemp.toBase64()
            params["img3"] = imgStr;
        }
        
        
                                    
        NetworkManager.postWithURI("add_property.php",  params:params, success: { (data) -> Void in
            
            print(data);

            success(data: data);
            
            })
            { (error) -> Void in
                
//                JSAlertView.show((error?.localizedDescription)!);

                print(error?.localizedDescription);
                failure(error: error);
                
        }
    }
    
    
    class func listOfProperties(success:successBlock, failure:failureBlock){
        
        let setting = Settings.loadSettings();
        
        let params =
        [
            "lat": setting.latitude,
            "lng": setting.longitude
        ];
        
        NetworkManager.postWithURI("Locations.php?action=all", params:params, success: { (data) -> Void in
            
            
            let propertyList : NSMutableArray = NSMutableArray();
            let dataList : NSArray = data as! NSArray
            
            
            for obj in dataList {
                
                let property = Property();
                property.mapPropertyUsing(obj as! NSDictionary);
                property.distance = obj["distance"] as! String;
                propertyList.addObject(property);
                
            }
            
            success(data: propertyList);
            
            })
            { (error) -> Void in
                
                
                print(error?.localizedDescription);
                
        }
    }
    
    
    class func listOfPropertiesForMaps(latitude:String, longitude:String, ulatitude:String, ulongitude:String, radius:String, success:successBlock, failure:failureBlock){
        
        let params =
        [
            "lat": latitude,
            "lng": longitude,
            "user_lat": latitude,
            "user_lng": longitude,
            "radius":radius
        ];
        
        NetworkManager.postWithURI("Locations.php?action=map", params:params, success: { (data) -> Void in
            
            
            let propertyList : NSMutableArray = NSMutableArray();
            let dataList : NSArray = data as! NSArray
            
            
            for obj in dataList {
                
                let property = Property();
                property.mapPropertyUsing(obj as! NSDictionary);
                property.distance = obj["user_distance"] as! String;
                propertyList.addObject(property);
            }
            
            success(data: propertyList);
            
            })
            { (error) -> Void in
                
                
                print(error?.localizedDescription);
                
        }
    }
    
    
    class func searchListOfProperties(success:successBlock, failure:failureBlock){
        
        let setting = Settings.loadSettings();
        
        let params =
        [
            "lat": setting.latitude,
            "lng": setting.longitude,
            "radius": setting.radius,
            "rooms": setting.rooms,
            "baths": setting.baths,
            "min_price": setting.minPrice,
            "max_price": setting.maxPrice
        ];
        
        
        NetworkManager.postWithURI("Locations.php?action=search", params:params,  success: { (data) -> Void in
            
            let propertyList : NSMutableArray = NSMutableArray();
            let dataList : NSArray = data as! NSArray
            
            for obj in dataList {
                
                let property = Property();
                property.mapPropertyUsing(obj as! NSDictionary);
                property.distance = obj["distance"] as! String;
                propertyList.addObject(property);
                
            }
            
            success(data: propertyList);
            
            })
            { (error) -> Void in
                
                
                
                print(error?.localizedDescription);
                
        }
    }
}
