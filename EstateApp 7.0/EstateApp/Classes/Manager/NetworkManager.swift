//
//  NetworkManager.swift
//  EstateApp
//
//  Created by JayD on 22/06/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

typealias successCall = (data: AnyObject?) -> Void
typealias failureCall = (error: NSError?)   -> Void

//if DEBUG
var baseURLString:String = "http://www.ilocal.com/"

class NetworkManager: NSObject {
   
    class func createErrorMessage(message:String) -> NSError {
        
        return NSError(domain: "server response!", code: 100, userInfo: [NSLocalizedDescriptionKey:message])
    }
    
    class func handleRequestResponse(json:AnyObject?, error:NSError!, success:successCall, failure:failureCall){
    
        println("S-E-R-V-E-R  C-A-L-L  C-O-M-P-L-E-T-E-D")
        
        if (error == nil)
        {
            var data:Dictionary = json as! Dictionary<String,AnyObject>!
            
            println("Request Response: \(data)")
            
            let isSuccess = data["success"] as! Bool
            
            if (isSuccess == true){
                
                success(data: data["data"]);
            }
            else{
                
                failure(error: self.createErrorMessage(data["message"] as! String));
            }
        }
        else {
            
            println("Request Error: \(error.localizedDescription)")

            failure(error: error);
        }
    }
    
    class func postWithURI( uri:String, params:Dictionary<String,AnyObject>,
        success:successCall, failure:failureCall)
    {
        println("Request URL: " + baseURLString + uri)
        println("Request Params: \(params)")
        
        
        let urlPath: String = baseURLString + uri
        
        var url: NSURL = NSURL(string: urlPath)!
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)

        request.HTTPMethod = "POST"
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            var err: NSError
            
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            println("AsSynchronous\(jsonResult)")
        })
//        Alamofire.request(.POST, baseURLString + uri, parameters: params)
//            .responseJSON { (request, response, json, errorRequest) in
        
//                self.handleRequestResponse(json, error: errorRequest, success: success, failure: failure);
//        }
    }
    
    class func getWithURI( uri:String, success:successCall, failure:failureCall)
    {
        println("\n\n\nRequest URL: " + baseURLString + uri)
        
//        Alamofire.request(.GET, baseURLString + uri)
//            .responseJSON { (request, response, json, errorRequest) in
        
//                self.handleRequestResponse(json, error: errorRequest, success: success, failure: failure);
//        }
    }
    
    class func putWithURI( uri:String, params:Dictionary<String,AnyObject>,
        success:successCall, failure:failureCall)
    {
        println("\n\n\nRequest URL: " + baseURLString + uri)
        println("Request Params: \(params)")
        
//        Alamofire.request(.PUT, baseURLString + uri, parameters: params)
//            .responseJSON { (request, response, json, errorRequest) in
        
//                self.handleRequestResponse(json, error: errorRequest, success: success, failure: failure);
//        }
    }
    
}
