//
//  UpadtePassword.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 27/10/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit

class UpadtePassword: UIViewController,NVActivityIndicatorViewable{

    //MARK: - Out_Lets
    @IBOutlet var txtOfCurrentPasswrd: UITextField!
    @IBOutlet var txtOfNewPasswrd: UITextField!
    @IBOutlet var imgOfHidePass: UIImageView!
    @IBOutlet var btnOfHidePass: UIButton!
    @IBOutlet var imgOfHideNewPass: UIImageView!
    @IBOutlet var btnOfHideNewPass: UIButton?
    @IBOutlet var btnUpdatePass: UIButton!
    
    var isEncrypted1 = true
    var isEncrypted2 = true
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNaviBackButton()
        navigationDesign()
        self.title = "Update Password"
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    //MARK: - Custom Methods
    @IBAction func btnHideCurrntPassclick(_ sender: Any) {
        if isEncrypted1 == true {
            txtOfCurrentPasswrd.isSecureTextEntry = false
            isEncrypted1 = false
            imgOfHidePass.image = UIImage(named:"private-eye")
        }
        else{
            txtOfCurrentPasswrd.isSecureTextEntry = true
            isEncrypted1 = true
            imgOfHidePass.image = UIImage(named:"invisible")
        }
    }
    
    @IBAction func btnOfHideNewPassClick(_ sender: Any) {
        if isEncrypted2 == true {
            txtOfNewPasswrd.isSecureTextEntry = false
            isEncrypted2 = false
            imgOfHideNewPass.image = UIImage(named:"private-eye")
            
        }
        else{
            txtOfNewPasswrd.isSecureTextEntry = true
            isEncrypted2 = true
            imgOfHideNewPass.image = UIImage(named:"invisible")
        }
    }
    @IBAction func btnUpdatePassClick(_ sender: Any) {
        self.view.endEditing(true)
        if Validation1.checkNotNullParameter(checkStr: txtOfCurrentPasswrd.text!){
            self.view.makeToast("Please Enter Current Password.")
        }
        else if Validation1.checkNotNullParameter(checkStr: txtOfNewPasswrd.text!){
            self.view.makeToast("Please Enter New Password.")
        }
        else  if  (txtOfCurrentPasswrd.text?.characters.count)! < 6  {
            self.view.makeToast("Current Password must be of mimimum 6 characters")
        }
        else  if  (txtOfNewPasswrd.text?.characters.count)! < 6  {
            self.view.makeToast("New Password must be of mimimum 6 characters")
        }
        else {
            let dictionary = [
                "userId": String(userInfo.userID),
                "userPrivateKey" : userInfo.privateKey,
                "oldPassword" : txtOfCurrentPasswrd.text!,
                "newPassword" : txtOfNewPasswrd.text!,
                "related_flag" : "1",
                ]
            
            var strURL = ""
            strURL = String(strURL.characters.dropFirst(1))
            strURL = Url.baseURL + "changePassword?"
            print(strURL)
            strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            if Validation1.isConnectedToNetwork() == true {
                self.startActivityIndicator()
                _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                self.CallWSUpadtePassword(strURL: strURL, dictionary: dictionary)
            }else{
                self.view.makeToast(string.noInternateMessage2)
                self.stopActivityIndicator()
            }
        }
    }
}
extension UpadtePassword: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtOfCurrentPasswrd {
            txtOfNewPasswrd.becomeFirstResponder()
        }
        else if textField == txtOfNewPasswrd{
            txtOfNewPasswrd.resignFirstResponder()
        }
        else{
            txtOfNewPasswrd.resignFirstResponder()
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
// MARK: WS UpadtePassword
extension UpadtePassword {
    
    func CallWSUpadtePassword(strURL: String, dictionary: Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.stopActivityIndicator()
            if JSONResponse["status"] as? String == "1"{
                self.view.makeToast((JSONResponse["message"] as? String)!)
                print("Result",JSONResponse["message"] ?? "0", "responce", JSONResponse)
                
                userInfo.privateKey = (JSONResponse["newUserPrivateKey"] as? String)!

                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                for aViewController in viewControllers {
                    if aViewController is HomeViewController {
                        //isVCFound = true
                        self.navigationController!.popToViewController(aViewController, animated: true)
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
