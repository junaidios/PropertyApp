//
//  NetworkManager.swift
//  EstateApp
//
//  Created by JayD on 22/06/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

//    class func handleRequestResponse(json:AnyObject?, error:NSError!, success:successCall, failure:failureCall){
//
//        print("S-E-R-V-E-R  C-A-L-L  C-O-M-P-L-E-T-E-D")
//
//        if (error == nil)
//        {
//            var data:Dictionary = json as! Dictionary<String,AnyObject>!
//
//            print("Request Response: \(data)")
//
//            let isSuccess = data["status"] as! Bool
//
//            if (isSuccess == true){
//
//                success(data: data["data"]);
//            }
//            else{
//
//                failure(error: self.createErrorMessage(data["message"] as! String));
//            }
//        }
//        else {
//
//            print("Request Error: \(error.localizedDescription)")
//
//            failure(error: error);
//        }
//    }

import Alamofire

typealias successCall = (_ data: Any?) -> Void
typealias failureCall = (_ error: NSError?)  -> Void
var BASE_URL:String = "http://69.195.124.91/~bahriaes/Estate/"
var requestsInProgress = 0;
/**
 This class is used for network related operations
 */
class NetworkManager: NSObject {
    
    class func createErrorMessage(_ message:String, code:Int) -> NSError {
        
        return NSError(domain: "server response!", code: code, userInfo: [NSLocalizedDescriptionKey:message])
    }
    
    // MARK:- URLSession
    
    static var headers : [String: String] {
        
        let headerDict = [ "cache-control": "no-cache",
                           "content-type": "application/json" ]
        return headerDict;
    }
    
    static var session : URLSession {
        
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }
    
    
    class func handleRequestResponse(data:Data?, error:Error?, success:@escaping successCall, failure:@escaping failureCall) {
        
        print("S-E-R-V-E-R  C-A-L-L  C-O-M-P-L-E-T-E-D")
        
        requestsInProgress -= 1;
        
        DispatchQueue.main.async {
            
            if requestsInProgress <= 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if (error == nil) {
                
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []);
                    
                    print(json);
                    
                    if let jsonObj = json as? [String: AnyObject] {
                        
                        if let isSuccess = jsonObj["status"] as? Bool, isSuccess == true
                        {
                            success(jsonObj["data"]);
                        }
                        else if let message = jsonObj["message"] as? String {
                            failure(self.createErrorMessage(message, code: 500));
                        }
                        else{
                            success(jsonObj);
                        }
                    }
                }
                catch let errorObj as NSError
                {
                    failure(errorObj);
                }
            }
            else {
                
                print(error!.localizedDescription)
                failure(error as NSError?);
            }
        }
    }
    
    class func uploadImageWithUri( _ uri: String,  imageData: Data  , success: @escaping successCall , failure: @escaping failureCall) {
        
        print("Request URL: " + BASE_URL + uri)
        
        //        let urlPath: String = BASE_URL + uri
    }
    
    class func uploadImageAndParamsWithUri( _ uri: String, parameters : [String : Any], imageData: Data, imageParamName : String  , success: @escaping successCall , failure: @escaping failureCall) {
        
        print("Request URL: " + BASE_URL + uri)
        
        //        let urlPath: String = BASE_URL + uri
    }
    
    
    
    class func requestURL( _ url:URL, method: String = "GET", success: @escaping successCall, failure: @escaping failureCall)
    {
        requestsInProgress += 1;
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("\n\n\nRequest URL:" + url.absoluteString)
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        let session = self.session
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if response != nil {
                let status = (response as! HTTPURLResponse).statusCode
                print("Method: GET\nResponse status: \(status)")
            }
            self.handleRequestResponse(data: data, error: error, success: success, failure: failure)
        })
        
        dataTask.resume()
    }

    class func postWithURI( _ uri:String, params:[String:Any],
                            success:@escaping successCall, failure:@escaping failureCall)
    {
        
        requestsInProgress += 1;
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("\n\n\nRequest URL: " + BASE_URL + uri)
        
        let urlPath: String = BASE_URL + uri
        
        let url = URL(string: urlPath)!
        
        let postData = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = self.session
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if response != nil {
                let status = (response as! HTTPURLResponse).statusCode
                print("Method: POST\nResponse status: \(status)")
            }
            self.handleRequestResponse(data: data, error: error, success: success, failure: failure)
        })
        
        dataTask.resume()
    }
    
    
    class func getWithURI( _ uri:String, success: @escaping successCall, failure: @escaping failureCall)
    {
        requestsInProgress += 1;
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("\n\n\nRequest URL: " + BASE_URL + uri)
        
        let urlPath: String = BASE_URL + uri
        
        let url = URL(string: urlPath)!
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = self.session
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if response != nil {
                let status = (response as! HTTPURLResponse).statusCode
                print("Method: GET\nResponse status: \(status)")
            }
            self.handleRequestResponse(data: data, error: error, success: success, failure: failure)
        })
        
        dataTask.resume()
        
        
    }
    
    class func putWithURI( _ uri:String, params:[String : Any],
                           success:@escaping successCall, failure:@escaping failureCall)
    {
        print("\n\n\nRequest URL: " + BASE_URL + uri)
        print("Request Params: \(params)")
        
        requestsInProgress += 1;
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let urlPath: String = BASE_URL + uri
        
        let url = URL(string: urlPath)!
        
        let postData = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = self.session;
        print(session.configuration);
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if response != nil {
                let status = (response as! HTTPURLResponse).statusCode
                print("Method: PUT\nResponse status: \(status)")
            }
            self.handleRequestResponse(data: data, error: error, success: success, failure: failure)
        })
        
        dataTask.resume()
        
        
    }
    
    class func deleteWithURI( _ uri:String, success:@escaping successCall, failure:@escaping failureCall)
    {
        
        requestsInProgress += 1;
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("\n\n\nRequest URL: " + BASE_URL + uri)
        let urlPath: String = BASE_URL + uri
        
        let url = URL(string: urlPath)!
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        
        let session = self.session
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if response != nil {
                let status = (response as! HTTPURLResponse).statusCode
                print("Method: DELETE\nResponse status: \(status)")
            }
            self.handleRequestResponse(data: data, error: error, success: success, failure: failure)
        })
        
        dataTask.resume()
        
    }
    
    // MARK:- ALAMOFIRE
    
    class func handleRequestResponse(_ uri: String, json:AnyObject?, code: NSInteger, success:successCall, failure:failureCall){
        
        //  print("JSON: \(json)")
        
        var data = [String: AnyObject]();
        
        if let dict = json as? [String: AnyObject]{
            
            data = dict;
        }
        else if let list = json! as? [AnyObject] {
            
            data = ["data":list as AnyObject];
        }
        
        print("Request Response: \(data)")
        
        var status = false;
        
        if let statusObj = data["status"] as? Bool {
            status = statusObj;
        }
        
        
        if ( status == true){
            success(data["data"]);
        }
        else
        {
            var message = "Something went wrong with Api ";
            
            if let msg = data["message"] {
                
                message = msg as! String;
            }
            
            let errorObj = createErrorMessage(message , code: code);
            
            failure(errorObj);
        }
    }
    
    class func parseAlamofireResponse(uri:String, response: DataResponse<Any>, success:successCall, failure:failureCall){
        
        print("S-E-R-V-E-R  C-A-L-L  C-O-M-P-L-E-T-E-D")
        
        switch response.result {
            
        case .success:
            
            if let JSON = response.result.value {
                
                let statusCode = (response.response?.statusCode)!
                print("status code: \(statusCode)")
                
                self.handleRequestResponse(uri, json:JSON as AnyObject, code: statusCode, success: success, failure: failure);
            }
            
        case .failure(let error):
            
            print("status code: \(error.localizedDescription)")
            failure(error as NSError);
        }
    }
    
    
    class func postAlamofireWithURI(_ uri:String, params:[String:Any],
                                    success:@escaping successCall, failure:@escaping failureCall)
    {
        
        print("Request URL: " + BASE_URL + uri)
        print("Request Params: \(params)")
        
        let urlPath: String = BASE_URL + uri
        
        let url = URL(string: urlPath)!
        let request = NSMutableURLRequest(url: url)
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
            .responseJSON { response in
                
                self.parseAlamofireResponse(uri: uri, response: response, success: success, failure: failure);
        }
    }
    
    class func getAlamofireWithURI(_ uri:String, success:@escaping successCall, failure:@escaping failureCall)
    {
        
        print("\n\n\nRequest URL: " + BASE_URL + uri)
        
        let uriEncoded = uri.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlPath = BASE_URL + uriEncoded!
        
        let url = URL(string: urlPath)!
        
        let request = NSMutableURLRequest(url: url)
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.httpMethod = "GET"
        
        URLCache.shared.removeAllCachedResponses()
        
        Alamofire.request(url, method: .get).responseJSON
            { response in
                
                self.parseAlamofireResponse(uri: uri, response: response, success: success, failure: failure);
        }
    }
    
    class func getAlamofireWithoutSpinnerWithURI(_ uri:String, success:@escaping successCall, failure:@escaping failureCall)
    {
        
        print("\n\n\nRequest URL: " + BASE_URL + uri)
        
        let urlPath: String = BASE_URL + uri
        
        let url = URL(string: urlPath)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        Alamofire.request(url, method: .get).responseJSON
            { response in
                
                self.parseAlamofireResponse(uri: uri, response: response, success: success, failure: failure);
        }
    }
    
    class func putAlamofireWithURI(_ uri:String, params:Dictionary<String,AnyObject>,
                                   success:@escaping successCall, failure:@escaping failureCall)
    {
        print("\n\n\nRequest URL: " + BASE_URL + uri)
        print("Request Params: \(params)")
        
        let urlPath: String = BASE_URL + uri
        
        let url = URL(string: urlPath)!
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: [:])
            .responseJSON { response in
                
                self.parseAlamofireResponse(uri: uri, response: response, success: success, failure: failure);
        }
    }
    
    
    class func deleteAlamofireWithURI(_ uri:String,
                                      success:@escaping successCall, failure:@escaping failureCall)
    {
        print("\n\n\nRequest URL: " + BASE_URL + uri)
        
        let urlPath: String = BASE_URL + uri
        
        let url = URL(string: urlPath)!
        let request = NSMutableURLRequest(url: url)
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: [:])
            .responseJSON { response in
                
                self.parseAlamofireResponse(uri: uri, response: response, success: success, failure: failure);
        }
    }
    
}

extension SessionManager {
    static func getManager() -> SessionManager {
        return Alamofire.SessionManager();
    }
}

