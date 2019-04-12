//
//  signup.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 24/10/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import Firebase

class signup: UIViewController,NVActivityIndicatorViewable {

    //MARK: - Outlets
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewOfScrollView: UIView!
    @IBOutlet var backViewOfPreofile: UIView!
    @IBOutlet var imgOfProfile: UIImageView!
    @IBOutlet var ImgOfCamera: UIImageView!
    @IBOutlet var txtOfName: UITextField!
    @IBOutlet var textOfEmail: UITextField!
    @IBOutlet var textOfMobile: UITextField!
    @IBOutlet var textOfDOB: UITextField!
    @IBOutlet var textOfPassword: UITextField!
    @IBOutlet var btnSendMeUpdate: UIButton!
    @IBOutlet var lblSendMeUpdate: UILabel!
    @IBOutlet var btnCreateAccnt: UIButton!
    @IBOutlet var btnTrmAndCndtns: UIButton!
    @IBOutlet var btnSelectProfile: UIButton!
    
    var strCheck = "0"

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

        setNaviBackButton()
        navigationDesign()
        self.title = "Sign Up"
    }
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    //MARK: - Custom Action
    @IBAction func btnSendUpadteClick(_ sender: Any) {
        
        if strCheck == "0" {
            strCheck = "1"
            btnSendMeUpdate.setImage(UIImage(named:"check1"), for: .normal)
        }else {
            strCheck = "0"
            btnSendMeUpdate.setImage(UIImage(named:"square"), for: .normal)
        }
    }
    
    @IBAction func btnCreateAccntClick(_ sender: Any) {
        
        if Validation1.checkNotNullParameter(checkStr: txtOfName.text!){
            self.view.makeToast(NSLocalizedString("Please enter name", comment: ""))
        }
        else if Validation1.checkNotNullParameter(checkStr: textOfEmail.text!){
            self.view.makeToast(NSLocalizedString("Please enter Email address", comment: ""))
        }
        else  if Validation1.isValidEmail(testEmail: textOfEmail.text!){
            self.view.makeToast(NSLocalizedString("Please enter the proper email address", comment: ""))
        }
        else  if Validation1.checkNotNullParameter(checkStr: textOfMobile.text!){
            self.view.makeToast(NSLocalizedString("Please enter mobile number", comment: ""))
        }
        else  if  (textOfMobile.text?.characters.count)! < 10  {
            self.view.makeToast(NSLocalizedString("Please enter valid mobile number", comment: ""))
        }
        else  if Validation1.checkNotNullParameter(checkStr: textOfDOB.text!){
            self.view.makeToast(NSLocalizedString("Please select date of birth", comment: ""))
        }
        else  if Validation1.checkNotNullParameter(checkStr: textOfPassword.text!){
            self.view.makeToast(NSLocalizedString("Please enter password", comment: ""))
        }
        else  if  (textOfPassword.text?.characters.count)! < 6  {
            self.view.makeToast(NSLocalizedString("Password must be of minimum 6 characters.", comment: ""))
        }
        else {
            
            let name = txtOfName.text!
            let emailAddress = textOfEmail.text!
            let password = textOfPassword.text!
            let devicID = FIRInstanceID.instanceID().token()!
            let deviceId = String(devicID)
            let deviceInfo = "iPhone"
            let deviceType = "1"
            let loginType = "normal"//: fb/gPlus
            let signupType = ""
            let mobileNumber = textOfMobile.text!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date: Date? = dateFormatter.date(from: textOfDOB.text!)
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let birthDate: String = dateFormatter.string(from: date!)
            
            print("Device Token",deviceId )
            
            let dictionary = ["name" : name,
                              "emailAddress" : emailAddress,
                              "password" : password,
                              "deviceId" : deviceId,
                              "deviceInfo" : deviceInfo,
                              "deviceType" : deviceType,
                              "loginType" : loginType,
                              "fbTokenId" : "",
                              "gplusTokenId" : "",
                              "mobileNumber" : mobileNumber,
                              "birthDate" : birthDate,
                              "related_flag" : "1",
                              "signupType" : signupType,
                              "updatesByEmailFlag" : strCheck]
            
            print("I/P: ",dictionary)
            var strURL = ""
            strURL = String(strURL.characters.dropFirst(1))
            strURL = Url.baseURL + "registerUser?"
            print(strURL)
            strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            if Validation1.isConnectedToNetwork() == true {
                self.startActivityIndicator()
                _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                self.callWSOfSignup(strUrl: strURL, dictionary: dictionary )
            }else{
                self.view.makeToast(string.noInternetConnMsg)
            }
        }
    }
    
    @IBAction func btnTermsAndCndtnclick(_ sender: Any) {
        /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        vc.flgScreen = "Activate"
        self.navigationController?.pushViewController(vc, animated: true)*/
    }
    
    @IBAction func btnSelectProfileClick(_ sender: Any) {
        alertCameraGallary()
    }
}

extension signup: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtOfName{
            textOfEmail.becomeFirstResponder()
        }
        else if textField == textOfEmail{
            textOfMobile.becomeFirstResponder()
        }
        else if textField == textOfMobile{
            textOfDOB.becomeFirstResponder()
        }
        else if textField == textOfDOB{
            textOfPassword.becomeFirstResponder()
        }
        else {
            textOfPassword.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textOfDOB{
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            
            var components = DateComponents()
            components.year = -100
            //let maxDate = Calendar.current.date(byAdding: components, to: Date())
            let maxDate = Date()
            //datePickerView.minimumDate = minDate
            datePickerView.maximumDate = maxDate
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
            crateToolBar()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

// MARK: Calnder Delegate
extension signup{

    func crateToolBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = color.barTintColor
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica-Light", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select Date of birth"
        label.textAlignment = NSTextAlignment.center
        
        toolBar.setItems([flexSpace,doneButton], animated: true)
        textOfDOB.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(_ sender: UIBarButtonItem){
        textOfDOB.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        //dateTxtField.text = dateFormatter.string(from: sender.date)
        
        //conversion of custom date formate
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        textOfDOB.text = dateFormatter.string(from: sender.date)
        //date = textOfDOB.text!
    }
}

// MARK: UIImagePicker Delegete
extension signup : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func alertCameraGallary() {
        let alertController = UIAlertController(title:  NSLocalizedString("Profile Photo", comment: ""), message: "", preferredStyle: UIAlertControllerStyle.alert)
        //Button 1 On Alert
        alertController.addAction(UIAlertAction(title:  NSLocalizedString("Camera", comment: ""), style: UIAlertActionStyle.default, handler: {
            action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                
                let imgPicker = UIImagePickerController()
                imgPicker.delegate = self
                imgPicker.sourceType = UIImagePickerControllerSourceType.camera
                imgPicker.allowsEditing = true
                self.present(imgPicker, animated: true, completion: nil)
            }
        }))
        //Button 2 On Alert
        alertController.addAction(UIAlertAction(title:  NSLocalizedString("Gallery", comment: ""), style: UIAlertActionStyle.default, handler: {
            
            action in
            let imgPicker = UIImagePickerController()
            imgPicker.allowsEditing = true
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imgPicker, animated: true, completion: nil)
        }))
        //Button 3 On Alert
        alertController.addAction(UIAlertAction(title:  NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.default, handler:nil))
        
        //Show Alert
        present(alertController,animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage : UIImage
        
        if let possibleImg = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = possibleImg
            imgOfProfile.image = newImage

        }
        else if let possibleImg = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //imageOfPRofile1.image = possibleImg
            newImage = possibleImg
            imgOfProfile.image = newImage
        }
        else{
            return
        }
        print("New Image Size Is: ",newImage.size)
        dismiss(animated: true, completion: nil)
    }
}
// MARK: WS SignUP
extension signup{
    func callWSOfSignup(strUrl : String , dictionary : Dictionary<String,String> ) {
        //userImage
        //
        _ = UIImage()
        AFWrapper.requestPostURLForUploadImage(strUrl, isImageSelect: true, fileName: "userImage", params: dictionary as [String : AnyObject], image: imgOfProfile.image! , success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            var data = [String:Any]()
            data = JSONResponse
            let status = data["status"] as? String
            if status == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    if let user_id = data["userId"] as? Int{
                        if let private_Key = data["userPrivateKey"] as? String {
                            userInfo.userID = user_id
                            userInfo.privateKey = private_Key
                            UserDefaults.standard.set(user_id, forKey: "user_id")
                            UserDefaults.standard.set(private_Key, forKey: "userPrivateKey")
                            
                            UserDefaults.standard.synchronize()
                            self.view.makeToast((data["message"] as? String)!)
                            print("login responce: ",data)
                            
                            self.navigationController?.navigationBar.isHidden = false
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
                            vc.flgScreen = "Activate"
                            vc.strSignupEmail = self.textOfEmail.text!
                            self.navigationController?.pushViewController(vc, animated: true)
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
                    print("error2: ",(data["message"] as? String)!)
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
