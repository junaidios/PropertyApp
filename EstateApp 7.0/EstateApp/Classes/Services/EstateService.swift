//
//  EstateService.swift
//  EstateApp
//
//  Created by JayD on 21/06/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class EstateService: BaseService {
   
    
    class func listOfProperties(success:successBlock, failure:failureBlock){
    
        NetworkManager.getWithURI("Locations.php", success: { (data) -> Void in
            
            let propertyList : NSMutableArray = NSMutableArray();
            let dataList : NSArray = data as! NSArray

            for obj in dataList {
            
                let property = Property();
                property.mapPropertyUsing(obj as! NSDictionary);
            
                propertyList.addObject(property);
            
            }
        
            success(data: propertyList);

        })
        { (error) -> Void in
         
            print(error?.localizedDescription);

        }
    }
}
