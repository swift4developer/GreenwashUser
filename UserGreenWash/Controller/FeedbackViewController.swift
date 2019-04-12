//
//  FeedbackViewController.swift
//  MoneyLander
//
//  Created by Apple on 14/08/17.
//  Copyright © 2017 Magneto. All rights reserved.

import UIKit

class FeedbackViewController: UIViewController,NVActivityIndicatorViewable  {

    
    @IBOutlet var lblOfCustomerSupport: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var sendBtntopconst: NSLayoutConstraint!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var ratingView: FloatRatingView!
    @IBOutlet var lblLineTxtView: UILabel!
    @IBOutlet var txtView: UITextView!
    @IBOutlet var lblAveg: UILabel!
    @IBOutlet var imgViewAveg: UIImageView!
    @IBOutlet var lblGud: UILabel!
    @IBOutlet var imgViewGud: UIImageView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblReqID: UILabel!
    
    @IBOutlet weak var lblOfName: UILabel!
    @IBOutlet weak var lblOfServicerInfo: UILabel!
    @IBOutlet weak var lblOfOrderId: UILabel!
    @IBOutlet weak var lblOfDateTime: UILabel!
    
    var serviceId = String()
    var orderId = String()
    var strDate = String()
    var likeUnlikeFlag = String()
    var rating = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviBackButton()
        navigationDesign()
        
        self.title = "Rate Service Provider"
        
        imgViewGud.image = UIImage(named:"Like")
        imgViewAveg.image = UIImage(named:"GrayDisLike")
        lblGud.textColor = color.greenColor
        lblGud.font = UIFont(name:"Raleway-Bold", size: 16.0)
        likeUnlikeFlag = "1"
        
        //Required float rating view params
        self.ratingView.emptyImage = UIImage(named: "gray-star")
        self.ratingView.fullImage = UIImage(named: "star2")
        //Optional params
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 0
        self.ratingView.rating = 2.5
        self.ratingView.editable = true
        self.ratingView.halfRatings = true
        self.ratingView.floatRatings = false
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.navigationController?.navigationBar.isHidden = false;
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    func stopActivityIndicator() {
        self.stopAnimating()
    }

    @IBAction func btnSendPress(_ sender: Any) {
        self.view.endEditing(true)
        if Validation1.isConnectedToNetwork()  {
            let rating  = String(self.ratingView.rating)
            if Validation1.checkNotNullParameter(checkStr: txtView.text!){
                self.view.makeToast("Please enter feedback.")
            }else {
                startActivityIndicator()
                _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                self.sendfeedback(rating:rating,likeUnlikeFlag: likeUnlikeFlag)
               
            }
        }
        else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    @IBAction func btnAvgPress(_ sender: Any) {
        
        self.view.endEditing(true)
        likeUnlikeFlag = "2"
        
        lblAveg.textColor = UIColor.red
        lblAveg.font = UIFont(name:"Raleway-Bold", size: 16.0)
        lblGud.font = UIFont(name:"Raleway-Medium", size: 16.0)
        
        imgViewAveg.image = UIImage(named:"DisLike")
        imgViewGud.image = UIImage(named:"GrayLike")
        lblGud.textColor = UIColor(red: 54.0/255.0, green: 54.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    }
  
    @IBAction func btnGudPress(_ sender: Any){
        self.view.endEditing(true)
        
        likeUnlikeFlag = "1"
        lblGud.textColor = color.greenColor
        lblAveg.font = UIFont(name:"Raleway-Medium", size: 16.0)
        lblGud.font = UIFont(name:"Raleway-Bold", size: 16.0)
        
        imgViewGud.image = UIImage(named:"Like")
        imgViewAveg.image = UIImage(named:"GrayDisLike")
        lblAveg.textColor = UIColor(red: 54.0/255.0, green: 54.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    }
}

// MARK: FloatRatingViewDelegate
extension FeedbackViewController: FloatRatingViewDelegate{
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        self.view.endEditing(true)
        let str = NSString(format: "%.2f", self.ratingView.rating) as String
        print(str)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        self.view.endEditing(true)
        let str = NSString(format: "%.2f", self.ratingView.rating) as String
        print(str)
    }
}

// MARK: - TextViewDelegate Method
extension FeedbackViewController:UITextViewDelegate{
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        textView.resignFirstResponder()
//        return true
//    }
//
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            txtView.resignFirstResponder()
            return false
        }
        return true
    }
}
extension FeedbackViewController {
    func sendfeedback(rating:String,likeUnlikeFlag:String) {
        
        let dictionary = ["userId": String(userInfo.userID),
                          "userPrivateKey": userInfo.privateKey,
                          "serviceId": serviceId,
                          "orderId":orderId,
                          "likeUnlikeFlag":likeUnlikeFlag,
                          "rating":rating,
                          "feedBack" : self.txtView.text,
                          "related_flag" : "1"
            ] as [String : Any]
        
        print("Feed Back i/p: ",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "rateServiceProvider?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfRateUs(strURL: strURL, dictionary: dictionary )
        }else {
            self.view.makeToast(string.noInternetConnMsg)
            self.stopActivityIndicator()
        }
    }
 
    func callWSOfRateUs(strURL: String, dictionary:Dictionary<String,Any>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                    //self.view.makeToast("Feedback submited !!!")
                    let msg = JSONResponse["message"] as? String
                    self.view.makeToast(msg!)
                    print("msg ", msg!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.navigationController?.navigationBar.isHidden = false
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is HomeViewController {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }
            }
            else{
                self.stopActivityIndicator()
                print("error2: ")
                if JSONResponse["status"] as? String == "0"{
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    if (JSONResponse["message"] as? String) == "logout"{
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is login {
                                //isVCFound = true
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }
                }
            }
        }, failure: { (error) in
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
                self.stopActivityIndicator()
            }
        })
    }
}
