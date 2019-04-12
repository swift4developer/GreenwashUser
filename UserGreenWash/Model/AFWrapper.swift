//
//  AFWrapper.swift
//  AFSwiftDemo
//
//  Created by Ashish on 10/4/16.
//  Copyright © 2016 Ashish Kakkad.All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AFWrapper: NSObject {
    
    class func requestGETURL(_ strURL: String, success:@escaping (Dictionary<String,Any>) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = responseObject.result.value!
                success(resJson as! Dictionary)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (Dictionary<String,Any>) -> Void, failure:@escaping (Error) -> Void){
        
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = responseObject.result.value!
                success(resJson as! Dictionary<String, Any>)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    class func requestPostURLForUploadImage(_ strURL : String,isImageSelect : Bool,fileName : String, params : [String : AnyObject]?,image : UIImage, success:@escaping (Dictionary<String,Any>) -> Void, failure:@escaping (Error) -> Void){
        var imgName = ""
        let timeStamp = NSNumber(value: Date().timeIntervalSince1970)
        imgName = fileName + "." +  String(describing: timeStamp) + ".png"
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if isImageSelect == true{
                let imgData = UIImageJPEGRepresentation(image, 0.2)!
                multipartFormData.append(imgData, withName: fileName,fileName:imgName, mimeType: "image/jpg")
              
            }
            for (key, value) in params! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                         to:strURL)
        { (result) in
            switch result {
            case .success(let upload, _ ,_ ):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    let resJson = response.result.value
                    if resJson != nil{
                        let res = resJson as! Dictionary<String, Any>
                        if res.count > 0 {
                            success(resJson as! Dictionary<String, Any>)
                        }else{
                            print("Uploading")
                        }
                    }else {
                        print("Uploading")
                    }
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    class func requestPostURLForUploadMultiplePropertyImage(_ strURL : String,imageArray : Array<UIImage>,fileName : String, params : [String : AnyObject]?, success:@escaping (Dictionary<String,Any>) -> Void, failure:@escaping (Error) -> Void){
        _ = UIApplication.shared.delegate as! AppDelegate
        /*if appDelegate.arryOfAppDeleImg.count > 0  {
            var uploadCount = 0
            
            for i in 0..<imageArray.count {
                let image = appDelegate.arryOfAppDeleImg[i] as? UIImage
                let imgView = UIImageView()
                imgView.image = image
                var imgData = UIImageJPEGRepresentation(imgView.image!, 1.0)!
                let imageSize: Int = imgData.count
                let imageSizeInKb = Double(imageSize) / 1024.0
                if imageSizeInKb > 600.0 {
                    imgData = UIImageJPEGRepresentation(imgView.image!, 0.6)!
                }
                
                var imgName = ""
                let timeStamp = NSNumber(value: Date().timeIntervalSince1970)
                imgName = fileName + "\(i)" + "." +  String(describing: timeStamp) + ".png"
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imgData, withName: fileName,fileName:imgName, mimeType: "image/jpg")
                    for (key, value) in params! {
                        multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                },
                                 to:strURL)
                { (result) in
                    switch result {
                    case .success(let upload, _ ,_ ):
                        
                        upload.uploadProgress(closure: { (progress) in
                            print("Upload Progress: \(progress.fractionCompleted)")
                        })
                        
                        upload.responseJSON { response in
                            let resJson = response.result.value
                            let res = resJson as! Dictionary<String, Any>
                            if res.count > 0 {
                                uploadCount += 1
                                if uploadCount == imageArray.count {
                                    uploadCount = 0
                                    let alertController = UIAlertController(title: "Thank you", message: "Property images has been uploaded", preferredStyle: UIAlertControllerStyle.alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:
                                        {
                                            action in
                                            
                                    }))
                                    //alertController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler:nil))
                                    // self.present(alertController,animated: true,completion: nil)
                                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                    alertWindow.rootViewController = UIViewController()
                                    alertWindow.windowLevel = UIWindowLevelAlert + 1
                                    alertWindow.makeKeyAndVisible()
                                    alertWindow.rootViewController?.present(alertController, animated: true) { _ in }
                                }
                                success(resJson as! Dictionary<String, Any>)
                            }
                        }
                        
                    case .failure(let error):
                        failure(error)
                    }
                }
            }
        }*/
    }
    
    class func requestGETURLWithReturnArray(_ strURL: String, success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = responseObject.result.value!
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
}
