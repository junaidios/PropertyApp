//
//  UserService.swift
//  EstateApp
//
//  Created by JayD on 21/06/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class UserService: BaseService {
    
    class func loadUserProfile(email:String, password:String, success:successBlock, failure:failureBlock)
    {

        var uri = "api/v1/sessions"
        var userInfo = ["email"   :email,
                        "password":password
        ];
        
        var param = ["user":userInfo]
        
        NetworkManager.postWithURI(uri, params: param, success: { (data) -> Void in
            
            println(data)

            success(data: data);
            
        }) { (error) -> Void in
            
            failure(error: error);
        };
    }
    
    
}
