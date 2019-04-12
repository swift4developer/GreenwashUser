//
//  login.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 23/10/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class login: UIViewController, GIDSignInUIDelegate,GIDSignInDelegate,NVActivityIndicatorViewable {

    //MARK: - Outlets
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewOfScroll: UIView!
    @IBOutlet var imgOfAppLogo: UIImageView!
    @IBOutlet var viewOfLogin: CustomView!
    @IBOutlet var viewOfEmail: UIView!
    @IBOutlet var viewOfPass: UIView!
    @IBOutlet var txtFileOfEmail: UITextField!
    @IBOutlet var imgOfPass: UIImageView!
    @IBOutlet var txtFileOfPass: UITextField!
    @IBOutlet var imgOfUserLogin: UIImageView!
    @IBOutlet var btnOfLogin: UIButton!
    @IBOutlet var btnForgotPass: UIButton!
    @IBOutlet var btnShowPass: UIButton!
    @IBOutlet var viewOfFacebook: UIView!
    @IBOutlet var viewOfGoogle: UIView!
    @IBOutlet var btnLoginGoogle: UIButton!
    @IBOutlet var imgOfGoogle: UIImageView!
    @IBOutlet var btnOgFacebook: UIButton!
    @IBOutlet var imgOfFacebbok: UIImageView!
    @IBOutlet var btnSignUp: UIButton!
    
    var isEncrypted = true
    var dict: [String:Any] = [:]
    var loginType = ""
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        //is u not use log out button we need this for the next time u try to login it can't login bcz 1st one is not log out
        GIDSignIn.sharedInstance().signOut()
        
        let type =  UserDefaults.standard.value(forKey: "Device") as? String
        if type! == "iPad" {
            print("iPad")
        }else {
            print("iPhone")
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        txtFileOfEmail.text = "vishalwagh.magneto+8@gmail.com"
        txtFileOfPass.text = "12345678"
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    //MARK: - Custom Actions
    @IBAction func btnShowPassClick(_ sender: Any) {
        if isEncrypted == true {
            txtFileOfPass.isSecureTextEntry = false
            isEncrypted = false
            btnShowPass.setTitle("Hide", for: .normal)
            
        }
        else{
            txtFileOfPass.isSecureTextEntry = true
            isEncrypted = true
            btnShowPass.setTitle("Show", for: .normal)
        }
    }
    
    @IBAction func btnForgotPassClick(_ sender: Any) {
        //flgScreen
        self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        vc.flgScreen = "Password"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLoginclick(_ sender: Any) {
        self.view.endEditing(true)
        if Validation1.checkNotNullParameter(checkStr: txtFileOfEmail.text!){
            self.view.makeToast("Please Enter Email Address.")
        }
        else if Validation1.isValidEmail(testEmail: txtFileOfEmail.text!) && !(txtFileOfEmail.text!.isStringAnInt()){
            self.view.makeToast("Please Enter Valid Email Address.")
        }
        else {
            if Validation1.checkNotNullParameter(checkStr: txtFileOfPass.text!) {
                self.view.makeToast("Please Enter Password.")
            }
            else  if  (txtFileOfPass.text?.characters.count)! < 6  {
                self.view.makeToast("Password must be of mimimum 6 characters")
            }
            else {
                self.loginType = "normal"
                
                let emailAddress = txtFileOfEmail.text
                let password = txtFileOfPass.text
                let devicID = FIRInstanceID.instanceID().token()!
                let deviceId = String(devicID)
                let deviceInfo = "iPhone"
                let deviceType = "1"
                let loginType = "normal"//: fb/gPlus
                print("Device Token",deviceId )
                
                let dictionary = ["emailAddress" : emailAddress,
                                  "password" : password,
                                  "deviceId" : deviceId,
                                  "deviceInfo" : deviceInfo,
                                  "deviceType" : deviceType,
                                  "loginType" : loginType,
                                  "related_flag" : "1",
                                  "fbTokenId" : "",
                                  "gplusTokenId" : "",
                                  "userImage" : "",
                                  "mobileNumber" : "",
                                  "birthDate" : ""] as! [String : String]
                
                print("I/P:",dictionary)
                var strURL = ""
                strURL = String(strURL.characters.dropFirst(1))
                strURL = Url.baseURL + "loginUser?"
                print(strURL)
                strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                
                if Validation1.isConnectedToNetwork() == true {
                    startActivityIndicator()
                    _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                    self.callWSOfLogin(strURL: strURL, dictionary: dictionary )
                }else{
                    self.view.makeToast(string.noInternetConnMsg)
                }
                //self.navigationController?.navigationBar.isHidden = false
                //let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocation") as! SelectLocation
                //self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @IBAction func btnSignUpClick(_ sender: Any) {
        self.view.endEditing(true)
     self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "signup"))!, animated: true)
    }
    
    //MARK: - Google Login
    @IBAction func btnGoogleLoginClick(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()//Remove this line when u signout from ur app
        GIDSignIn.sharedInstance().signIn()
    }
    
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        print("Sign in present")
    }
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            //let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            //let familyName = user.profile.familyName
            let email = user.profile.email
            print("userId: \(String(describing: userId))")
            print("fullName: \(String(describing: fullName))")
            print("givenName: \(String(describing: givenName))")
            print("email: \(String(describing: email))")
            
            let pic = user.profile.imageURL(withDimension: 100)!
            //let userImage = String(contentsOf: (pic)!)
            if user.profile.hasImage{
                print("profile Picture: \(String(describing: pic))")
                //let imgData = NSData(contentsOf: pic!)
                //self.imgOfProfile.image = UIImage(data: imgData as! Data)
            }
            let emailAddress = (email)!
            let password = ""
            let devicID = FIRInstanceID.instanceID().token()!
            let deviceId = String(devicID)
            let deviceInfo = "iPhone"
            let deviceType = "1"
            let loginType = "gPlus﻿"//: fb/gPlus
            let gplusTokenId = String(userId!)
            
            print("Device Token",deviceId )
            
            let dictionary = ["emailAddress" : emailAddress,
                              "password" : password,
                              "deviceId" : deviceId,
                              "deviceInfo" : deviceInfo,
                              "deviceType" : deviceType,
                              "loginType" : loginType,
                              "userImage": "\(String(describing: pic))",
                              "fbTokenId" : "",
                              "gplusTokenId" : gplusTokenId,
                              "mobileNumber" : "",
                              "birthDate" : "",
                              "userName" : String(fullName!),
                              "related_flag" : "1"]
            
            print("I/P: ",dictionary)
            var strURL = ""
            strURL = String(strURL.characters.dropFirst(1))
            strURL = Url.baseURL + "loginUser?"
            print(strURL)
            strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            if Validation1.isConnectedToNetwork() == true {
                self.startActivityIndicator()
                _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                self.callWSOfLogin(strURL: strURL, dictionary: dictionary)
            }else{
                self.view.makeToast(string.noInternetConnMsg)
            }
            
            
        } else{
            print("\(error.localizedDescription)")
        }
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        print("Sign in dismiss ")
        //for google sign outanimated
        //GIDSignIn.sharedInstance().signOut()
    }
    
    @IBAction func SignOutButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        print("Log out successfully")
    }
    

    
    //MARK: - Facebook Login //"email","public_profile","user_friends"
    @IBAction func btnFacebookLoginClick(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email","user_birthday","public_profile"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday, age_range"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : Any]
                    print(result!," n ",self.dict)
                    
                    let FbId = (self.dict["id"] as? String)!
                    //user name
                    let userName = (self.dict["name"] as? String)!
                    _ = self.dict["gender"] as? String
                    //user Image
                    let imgURl = "https://graph.facebook.com/\(FbId)/picture?type=large&return_ssl_resources=1"
                        //NSURL(string: "https://graph.facebook.com/\(FbId)/picture?type=large&return_ssl_resources=1")
                    //All user infromation
                    let userEmail = (self.dict["email"] as? String)!
                    let userDOB = (self.dict["birthday"] as? String)!
                    
                    self.loginType = "fb"
                    let emailAddress = userEmail
                    let password = ""
                    let devicID = FIRInstanceID.instanceID().token()!
                    let deviceId = String(devicID)
                    let deviceInfo = "iPhone"
                    let deviceType = "1"
                    let loginType = "fb"//: fb/gPlus
                    //let fbToken = FBSDKAccessToken.current().tokenString
                    //let fbUserID = result.token.userID
                    
                    
                    print("Device Token",deviceId )
                    let dictionary = ["emailAddress" : emailAddress,
                                      "password" : password,
                                      "deviceId" : deviceId,
                                      "deviceInfo" : deviceInfo,
                                      "deviceType" : deviceType,
                                      "loginType" : loginType,
                                      "userImage": imgURl,
                                      "fbTokenId" : FbId,
                                      "gplusTokenId" : "",
                                      "mobileNumber" : "",
                                      "birthDate" : userDOB,
                                      "userName" : userName,
                                      "related_flag" : "1"]
                    
                    print("I/P: ",dictionary)
                    var strURL = ""
                    strURL = String(strURL.characters.dropFirst(1))
                    strURL = Url.baseURL + "loginUser?"
                    print(strURL)
                    strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                    
                    if Validation1.isConnectedToNetwork() == true {
                        self.startActivityIndicator()
                        _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                        self.callWSOfLogin(strURL: strURL, dictionary: dictionary )
                    }else{
                        self.view.makeToast(string.noInternetConnMsg)
                    }
                    
                    //let fbToken = FBSDKAccessToken.current().tokenString
                    //print("Facebook Current access token: \(FBSDKAccessToken.current().tokenString)")
                    
//                    let fbToken = result.token.tokenString
//                    let fbUserID = resutl.token.userID
//                    self.lblOfFBName?.text = ()
                }
            })
        }
    }
    
}
//MARK: - TextField Delegate
extension login: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFileOfEmail {
            txtFileOfPass.becomeFirstResponder()
        }
        else if textField == txtFileOfPass{
            txtFileOfPass.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}
//MARK: - WS Of Login
extension login {
    func callWSOfLogin(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            var data = [String:Any]()
            data = JSONResponse
            //let response = JSONResponse
            if data["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    if let user_id = data["user_id"] as? Int{
                        if let private_Key = data["userPrivateKey"] as? String {
                            userInfo.userID = user_id
                            userInfo.privateKey = private_Key
                            UserDefaults.standard.set(user_id, forKey: "user_id")
                            UserDefaults.standard.set(private_Key, forKey: "userPrivateKey")
                            
                            if (data["notificationCount"] != nil){
                                let notfictn_count = data["notificationCount"]
                                print("login notifictn_count: ", notfictn_count ?? 0)
                                UserDefaults.standard.set(notfictn_count!, forKey: "notificationCount")
                            }
                            
                            UserDefaults.standard.set(data["userName"] as? String, forKey: "userName")
                            UserDefaults.standard.set(data["userImage"] as? String, forKey: "userImage")
                            UserDefaults.standard.synchronize()
                            print("login responce: ",data)
                            
                            self.navigationController?.navigationBar.isHidden = false
                            if data["activationFlag"] as? Int == 0 {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
                                vc.flgScreen = "Activate"
                                vc.strSignupEmail = self.txtFileOfEmail.text!
                                self.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocation") as! SelectLocation
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        else{
                            self.view.makeToast(string.someThingWrongMsg)
                        }
                    }
                    else{
                        self.view.makeToast(string.someThingWrongMsg)
                    }
                }
            }
            else{
                let status = data["status"] as? String
                self.stopActivityIndicator()
                switch status!{
                case "0":
                    //When Parameter Missing
                    print("error2: ")
                    self.view.makeToast((data["message"] as? String)!)
                    break
                default:
                    print("error1: ");
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




