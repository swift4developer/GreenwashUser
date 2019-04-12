//
//  OrderSummryScreen.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 08/11/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit

class OrderSummryScreen: UIViewController,NVActivityIndicatorViewable {

    //MARK: - OultLets
    @IBOutlet weak var imgOfProfile: UIImageView!
    @IBOutlet weak var lblOfUserName: UILabel!
    @IBOutlet weak var lblOfServiceInfo: UILabel!
    @IBOutlet weak var lblOfServiceCharge: UILabel!
    
    @IBOutlet weak var ViewOfSpclInstrctn: UIView!
    @IBOutlet weak var imgOfClander: UIImageView!
    @IBOutlet weak var lblOfOrderDate: UILabel!
    @IBOutlet weak var lblOfRatingCount: UILabel!
    @IBOutlet weak var lblOfOrderTime: UILabel!
    @IBOutlet weak var lblOfAddress: UILabel!
    @IBOutlet weak var lblOfSpecaiInstruction: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnTermsNdCondtin: UIButton!
    @IBOutlet weak var btnConfrmNdBook: UIButton!
    
    @IBOutlet weak var bgViewAlert: UIView!
    @IBOutlet weak var imgOfCleanig: UIImageView!
    @IBOutlet weak var lblofOrdePlacedTitle: UILabel!
    @IBOutlet weak var lblOfCongratltn: UILabel!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnViewOrder: UIButton!
    @IBOutlet weak var viewOfAlert: UIView!
    @IBOutlet weak var ViewOfTermsAndCndtn: UIView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var flagForAlert = "1"
    var flagForTermCheck = "1"
    var strOrderID = ""
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setNaviBackButton()
        let btnBack = UIButton(frame: CGRect(x: 0, y:0, width:20,height: 20))
        btnBack.setImage(UIImage(named:"back"), for: .normal)
        btnBack.addTarget(self,action: #selector(backClick), for: .touchUpInside)
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 20)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 20)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        let backBarButtonitem = UIBarButtonItem(customView: btnBack)
        let arrLeftBarButtonItems : Array = [backBarButtonitem]
        self.navigationItem.leftBarButtonItems = arrLeftBarButtonItems
        
        navigationDesign()
        
        self.title = "Order Summary"
        bgViewAlert.isHidden = true
        btnConfrmNdBook.backgroundColor = UIColor(red: 9.0/255.0, green: 143.0/255.0, blue: 8.0/255.0, alpha: 0.5)
        btnConfrmNdBook.isUserInteractionEnabled = false
        ViewOfTermsAndCndtn.isHidden = false
        
        print("dic for post the data: ",appDelegate.postBookingReqDic)
        setData()
        // Do any additional setup after loading the view.
    }
    @objc func backClick(){
        if flagForAlert == "1"{
            self.navigationController?.popViewController(animated: true)
        }else {
            let vc : [UIViewController] = self.navigationController!.viewControllers
            for aViewController in vc {
                if aViewController is HomeViewController {
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }
    }
    
    func setData(){
        imgOfProfile.image = appDelegate.imgOfServiceProvider
        lblOfUserName.text = appDelegate.postBookingReqDic["ProivderName"]
        lblOfServiceInfo.text = appDelegate.postBookingReqDic["serviceInfo"]
        lblOfServiceCharge.text = appDelegate.postBookingReqDic["serviceCharge"]
        lblOfOrderDate.text = appDelegate.postBookingReqDic["selectedDate"]
        lblOfRatingCount.text = appDelegate.postBookingReqDic["ProviderRating"]
        lblOfOrderTime.text = appDelegate.postBookingReqDic["fromTime"]! + " - " + appDelegate.postBookingReqDic["toTime"]!
        lblOfAddress.text = appDelegate.postBookingReqDic["address"]
        
        if Validation1.checkNotNullParameter(checkStr: appDelegate.postBookingReqDic["specialInstructions"]!){
            lblOfSpecaiInstruction.isHidden = true
            ViewOfSpclInstrctn.isHidden = true
        }else {
            lblOfSpecaiInstruction.text = appDelegate.postBookingReqDic["specialInstructions"]
            ViewOfSpclInstrctn.isHidden = false
        }
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @IBAction func btnViewOrderClick(_ sender: Any) {
        btnConfrmNdBook.isUserInteractionEnabled = true
        bgViewAlert.isHidden = true
        ViewOfTermsAndCndtn.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        btnConfrmNdBook.backgroundColor = UIColor.red
        btnConfrmNdBook.setTitle("Cancel", for: .normal)
        flagForAlert = "2"
    }
    
    @IBAction func btnHomeClick(_ sender: Any) {
        bgViewAlert.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        let vc : [UIViewController] = self.navigationController!.viewControllers
        for aViewController in vc {
            if aViewController is HomeViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    
    @IBAction func btnCheckBoxClick(_ sender: Any) {
        if flagForTermCheck == "1"{
             btnConfrmNdBook.backgroundColor = UIColor(red: 9.0/255.0, green: 143.0/255.0, blue: 8.0/255.0, alpha: 1.0)
            flagForTermCheck = "2"
            btnConfrmNdBook.isUserInteractionEnabled = true
            btnCheckBox.setImage(UIImage(named:"check1.png"), for: .normal)
        }else{
             btnConfrmNdBook.backgroundColor = UIColor(red: 9.0/255.0, green: 143.0/255.0, blue: 8.0/255.0, alpha: 0.5)
            flagForTermCheck = "1"
            btnConfrmNdBook.isUserInteractionEnabled = false
            btnCheckBox.setImage(UIImage(named:"square.png"), for: .normal)
        }
    }
    @IBAction func btnTermNdContnlinkClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndCondtion") as! TermsAndCondtion
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnConfmNdBookClick(_ sender: Any) {
        
        if flagForTermCheck == "1"{
            
        }
        else {
            if flagForAlert == "1"{
                PostBookingRequest()
            }else {
                cancelOrder()
            }
        }
     }
}

//MARK: - callWS Post Booking
extension OrderSummryScreen {
    func PostBookingRequest(){
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
                          "chilServicedId": appDelegate.postBookingReqDic["chilServicedId"],
                          "serviceProviderId" : appDelegate.postBookingReqDic["serviceProviderId"],
                          "address" : appDelegate.postBookingReqDic["address"],
                          "fromTime" : appDelegate.postBookingReqDic["fromTime"],
                          "toTime" : appDelegate.postBookingReqDic["toTime"],
                          "longitude" : appDelegate.postBookingReqDic["longitude"],
                          "lattitude" : appDelegate.postBookingReqDic["lattitude"],
                          "selectedDate" : appDelegate.postBookingReqDic["selectedDate"],
                          "specialInstructions" : appDelegate.postBookingReqDic["specialInstructions"]
                          ]
        
        print("Booking data for post I/P: ",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "bookService?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfPostBookingRequest(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else {
            self.view.makeToast(string.noInternetConnMsg)
            self.stopActivityIndicator()
        }
    }
    
    func callWSOfPostBookingRequest(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? Int == 1{
                self.stopActivityIndicator()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.strOrderID = String(JSONResponse["orderId"] as! Int)

                    self.lblOfCongratltn.text = "Congratulations ! Your Order Placed Sccessfully. Order id is \(self.strOrderID) we will kepp upading you by notification."
                    self.bgViewAlert.isHidden = false
                    self.viewOfAlert.layer.cornerRadius = 5.0
                    self.view.bringSubview(toFront: self.bgViewAlert)
                    self.navigationController?.navigationBar.isHidden = true
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
                    }else {
                        self.view.makeToast(string.someThingWrongMsg)
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
    
    //MARK: - Cancle Order
    func cancelOrder(){
        
        let arriveTimestamp = 14
        let date = Date(timeIntervalSince1970: TimeInterval(arriveTimestamp)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy hh:mm:ss"
        let Timestamp = dateFormatter.string(from: date)
        print(Timestamp)
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateTime = formatter.string(from: Date())
        
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
                          "orderId": self.strOrderID,
                          "currDateTime" : dateTime
        ]
        
        print("Cancel I/P: ",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "cancelOrder?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfCancelOrder(strURL: strURL, dictionary: dictionary)
        }else {
            self.view.makeToast(string.noInternetConnMsg)
            self.stopActivityIndicator()
        }
    }
    
    func callWSOfCancelOrder(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                self.stopActivityIndicator()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    self.flagForAlert = "1"
                    let vc : [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in vc {
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

