//
//  ViewController.swift
//  MoneyLander
//
//  Created by PUNDSK003 on 7/31/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet var btnSend: UIButton!
    @IBOutlet var lblInfo: UILabel!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var btnResend: UIButton!
    
    @IBOutlet var topOfProceedBtn: NSLayoutConstraint!
    
    var flgScreen = ""
    var strSignupEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setNaviBackButton1()
        navigationDesign()
      
        if(flgScreen == "Password") {
            self.title = "Forgot Password"
            txtEmail.placeholder = "Email Address"
            
            //txtEmail.tintColor = color.txtFieldTintColor
            //txtEmail.textColor = color.txtColor;
            let type =  UserDefaults.standard.value(forKey: "Device") as? String
            if type! == "iPad" {
                topOfProceedBtn.constant = 80
            }else {
                topOfProceedBtn.constant = 40
            }
            btnResend.isHidden = true
        }else {
            self.title = "Activate Account"
            txtEmail.placeholder = "OTP"
            
            //txtEmail.keyboardType = UIKeyboardType.numberPad
            //txtEmail.keyboardType = UIKeyboardType.emailAddress
            txtEmail.addDoneButtonOnKeyboard()
            
            //txtEmail.tintColor = color.txtFieldTintColor
            //txtEmail.textColor = color.txtColor;
            let type =  UserDefaults.standard.value(forKey: "Device") as? String
            if type! == "iPad" {
                topOfProceedBtn.constant = 100
            }else {
                topOfProceedBtn.constant = 65
            }
            btnResend.isHidden = false
        }
        btnSend.setTitle("Proceed", for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
         if(flgScreen == "Password") {
            
            lblInfo.text  =  NSLocalizedString("Please enter your email address. You will receive a mail to update your password.", comment: "")
         }
         else {
            lblInfo.text  =  NSLocalizedString("A One-time Password(OTP) will be sent to your registered email address.", comment: "")
        }
        self.navigationController?.navigationBar.isHidden = false;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    func setNaviBackButton1(){
        //Design Of Navigation Bar Back_Button
        var btnBack = UIButton()
        let type =  UserDefaults.standard.value(forKey: "Device") as? String
        if type! == "iPad" {
            btnBack = UIButton(frame: CGRect(x: 0, y:0, width:40,height: 40))
        }else {
            btnBack = UIButton(frame: CGRect(x: 0, y:0, width:20,height: 20))
        }
        
        btnBack.setImage(UIImage(named:"back"), for: .normal)
        btnBack.addTarget(self,action: #selector(backBtn), for: .touchUpInside)
        
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 20)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 20)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        
        let backBarButtonitem = UIBarButtonItem(customView: btnBack)
        let arrLeftBarButtonItems : Array = [backBarButtonitem]
        self.navigationItem.leftBarButtonItems = arrLeftBarButtonItems
        self.navigationController?.navigationBar.backgroundColor = color.greenColor
    }
    
    @objc func backBtn(){
        if(flgScreen == "Password") {
            self.navigationController?.popViewController(animated: true)
        }else{
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is login {
                    //isVCFound = true
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }
        
    }

    @IBAction func btnResendCick(_ sender: Any) {

        let dictionary = [
            "userId": String(userInfo.userID),
            "userPrivateKey" : userInfo.privateKey,
            "emailAddress" : strSignupEmail,
            "related_flag":"1",
            ]
        
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "resendOtp?"
        print(strURL)
        strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if Validation1.isConnectedToNetwork() == true {
            self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.forgotPasswordWS(strURL: strURL, dictionary: dictionary)
        }else{
            self.view.makeToast(string.noInternateMessage2)
            self.stopActivityIndicator()
        }
        
    }
    
    @IBAction func btnSendPress(_ sender: Any) {
        self.view.endEditing(true)
        
        if(flgScreen == "Password") {
            if Validation1.checkNotNullParameter(checkStr: txtEmail.text!){
                self.view.makeToast(NSLocalizedString("Please enter email address.", comment: ""))
            }
            else  if Validation1.isValidEmail(testEmail: txtEmail.text!){
                self.view.makeToast(NSLocalizedString("Please enter proper email address", comment: ""))
            }
            else {
                let dictionary = [
                    "emailAddress" : txtEmail.text!,
                    "related_flag":"1",
                    ]
                
                var strURL = ""
                strURL = String(strURL.characters.dropFirst(1))
                strURL = Url.baseURL + "forgotPassword?"
                print(strURL)
                strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                
                if Validation1.isConnectedToNetwork() == true {
                    self.startActivityIndicator()
                    _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                    self.forgotPasswordWS(strURL: strURL, dictionary: dictionary)
                }else{
                    self.view.makeToast(string.noInternateMessage2)
                    self.stopActivityIndicator()
                }
            }
        }
        else {
            if Validation1.checkNotNullParameter(checkStr: txtEmail.text!){
                self.view.makeToast(NSLocalizedString("Please enter the OTP", comment: ""))
            }
            else {
                let dictionary = [
                    "userId": String(userInfo.userID),
                    "userPrivateKey" : userInfo.privateKey,
                    "otp" : txtEmail.text!,
                    "emailAddress" : strSignupEmail,
                    "related_flag":"1",
                    ]
                
                var strURL = ""
                strURL = String(strURL.characters.dropFirst(1))
                strURL = Url.baseURL + "activateAccount?"
                print(strURL)
                strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                
                if Validation1.isConnectedToNetwork() == true {
                    self.startActivityIndicator()
                    _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                    self.forgotPasswordWS(strURL: strURL, dictionary: dictionary)
                }else{
                    self.view.makeToast(string.noInternateMessage2)
                    self.stopActivityIndicator()
                }
            }
        }
        
        //self.navigationController?.popViewController(animated: true)
    }
}
// MARK: WS
extension ForgetPasswordViewController {
    
    func forgotPasswordWS(strURL: String, dictionary: Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.stopActivityIndicator()
            if JSONResponse["status"] as? String == "1"{
                self.view.makeToast((JSONResponse["message"] as? String)!)
                print("Result",JSONResponse["message"] ?? "0", "responce", JSONResponse)
                
                if(self.flgScreen == "Password") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is login {
                            //isVCFound = true
                            self.navigationController!.popToViewController(aViewController, animated: true)
                        }
                    }
                }
            }
            else{
                let status_code = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                switch status_code!{
                case "0":
                    //Some server error
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    print("error: ",(JSONResponse["message"] as? String)!)
                    break
                default:
                    print("");
                }
            }
        }, failure: { (error) in
            print("error ", error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
                self.stopActivityIndicator()
            }
        })
    }
}
