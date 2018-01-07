//
//  JSAlertView.swift
//  Velodrome
//
//  Created by JayD on 12/02/2016.
//  Copyright © 2016 Junaid iOS. All rights reserved.
//

import UIKit

class JSAlertView: NSObject {
    
    class func show(_ message:String){
        
        UIAlertView(title: "Estate App!", message: message, delegate: nil, cancelButtonTitle: "Okay").show();
    }
    
    class func show(_ title:String, message:String){
        
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Okay").show();
    }

}
