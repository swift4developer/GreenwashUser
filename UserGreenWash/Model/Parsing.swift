//
//  Parsing.swift
//  MalaBes
//
//  Created by PUNDSK006 on 5/15/17.
//  Copyright © 2017 Intechcreative Pvt. Ltt. All rights reserved.
//

import Foundation
//import Alamofire


protocol ParsingDelegate
{
    func noInternetConnection()
    
    func someThingWentWrong()
    
    func success(WithResponse: Any)
}


class Parsing
{
    var delegate: ParsingDelegate?
    
    func parseDataWithPost(params : Dictionary<String, String>, urlString: String)
    {
      
        
        if Validation1.isConnectedToNetwork()
        {
            /*
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key, value) in params
                    {
                        multipartFormData.append((value.data(using: .utf8))!, withName: key)
                    }
            },
                to: urlString,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            
                            //Success
                            if (response.result.value as? [String:Any]) != nil
                            {
                                self.delegate?.success(WithResponse: response.result.value!)
                            }
                            else
                            {
                                self.delegate?.someThingWentWrong()
                            }
                            
                            
                        }
                        upload.uploadProgress(queue: DispatchQueue(label: "uploadQueue"), closure: { (progress) in
                            
                            
                        })
                        
                    case .failure( _):
                        self.delegate?.someThingWentWrong()
                    }
            }
                
            )
            */
        }
        else
        {
            self.delegate?.noInternetConnection()
        }
    }
   /* func imgUploadWithParametrs(params : Dictionary<String, String>, urlString: String,img: UIImage)
    {
        
        print(urlString)
        print(params)
    
        if Validation1.isConnectedToNetwork()
        {
     
            let imgData = UIImageJPEGRepresentation(img, 0.2)!
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "profile_img",fileName: "file1.jpg", mimeType: "image/jpg")
                for (key, value) in params {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                             to:urlString)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        //Success
                        if (response.result.value as? [String:Any]) != nil
                        {
                            self.delegate?.success(WithResponse: response.result.value!)
                        }
                        else
                        {
                            self.delegate?.someThingWentWrong()
                        }
                    }
                    
                case .failure( _):
                    self.delegate?.someThingWentWrong()
                }
            }
            
 
        }
        else
        {
            self.delegate?.noInternetConnection()
        }
        
    }*/
    
    func parsingUsingSimplePost(urlString : String)
    {
        print(urlString)
        
        if Validation1.isConnectedToNetwork()
        {
            let headers = [
                "cache-control": "no-cache",
                "postman-token": "7ec0da15-6ec5-65e3-f418-0f204d923db9"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil)
                {
                    self.delegate?.someThingWentWrong()
                    
                }
                else
                {
                    if let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    {
                        self.delegate?.success(WithResponse: json!)
                    }
                }
            })
            
            dataTask.resume()
        }
        else
        {
            self.delegate?.noInternetConnection()
        }
        
        
        
    }
    
    
}
