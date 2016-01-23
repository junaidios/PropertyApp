//
//  NetworkManager.swift
//  EstateApp
//
//  Created by JayD on 22/06/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit
import Alamofire

typealias successCall = (data: AnyObject?) -> Void
typealias failureCall = (error: NSError?)  -> Void

//if DEBUG
var baseURLString:String = "http://bahriaestate.com/Estate/"

class NetworkManager: NSObject {
   
    class func createErrorMessage(message:String) -> NSError {
        
        return NSError(domain: "server response!", code: 100, userInfo: [NSLocalizedDescriptionKey:message])
    }
    
    class func handleRequestResponse(json:AnyObject?, error:NSError!, success:successCall, failure:failureCall){
    
        print("S-E-R-V-E-R  C-A-L-L  C-O-M-P-L-E-T-E-D")
        
        if (error == nil)
        {
            var data:Dictionary = json as! Dictionary<String,AnyObject>!
            
            print("Request Response: \(data)")
            
            let isSuccess = data["status"] as! Bool
            
            if (isSuccess == true){
                
                success(data: data["data"]);
            }
            else{
                
                failure(error: self.createErrorMessage(data["message"] as! String));
            }
        }
        else {
            
            print("Request Error: \(error.localizedDescription)")

            failure(error: error);
        }
    }
    
    class func postWithURI( uri:String, params:Dictionary<String,AnyObject>,
        success:successCall, failure:failureCall)
    {
        print("Request URL: " + baseURLString + uri)
        print("Request Params: \(params)")
        
        let urlPath: String = baseURLString + uri
        
        Alamofire.request(.POST, urlPath, parameters: params)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                

                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    self.handleRequestResponse(JSON, error: nil, success: success, failure: failure);

                }
        }
    }
    
    class func getWithURI( uri:String, success:successCall, failure:failureCall)
    {
        print("\n\n\nRequest URL: " + baseURLString + uri)

        let urlPath: String = baseURLString + uri

        Alamofire.request(.GET, urlPath, parameters:[:])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    self.handleRequestResponse(JSON, error: nil, success: success, failure: failure);
                    
                }

        }
    }
    
    class func putWithURI( uri:String, params:Dictionary<String,AnyObject>,
        success:successCall, failure:failureCall)
    {
        print("\n\n\nRequest URL: " + baseURLString + uri)
        print("Request Params: \(params)")
        
        Alamofire.request(.PUT, baseURLString + uri, parameters: params)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                

                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    self.handleRequestResponse(JSON, error: nil, success: success, failure: failure);
                    
                }
        }
    }
    
}
