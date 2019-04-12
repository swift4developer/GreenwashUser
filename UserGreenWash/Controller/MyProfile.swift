//
//  MyProfile.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 27/10/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import Alamofire

class MyProfile: UIViewController,NVActivityIndicatorViewable {

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
    @IBOutlet var btnSendMeUpdate: UIButton!
    @IBOutlet var lblSendMeUpdate: UILabel!
    @IBOutlet var btnCreateAccnt: UIButton!
    @IBOutlet var btnUpdatePass: UIButton!
    @IBOutlet var btnProfile: UIButton!
    
    var btnEdit : UIButton!
    var strStatEdit = "2"
    var strCheck = "0"
    var cache:NSCache<AnyObject, AnyObject>!
    var flag = true
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cache = NSCache()
        setNaviBackButton()
        navigationDesign()
        
        rightNavbtn(widthOfBtn:23)
        
        txtOfName.isUserInteractionEnabled = false
        textOfEmail.isUserInteractionEnabled = false
        textOfMobile.isUserInteractionEnabled = false
        textOfDOB.isUserInteractionEnabled = false
        btnSendMeUpdate.isUserInteractionEnabled = false
        btnUpdatePass.isUserInteractionEnabled = false
        btnProfile.isUserInteractionEnabled = false
        ImgOfCamera.isHidden = true
    
        // Do any additional setup after loading the view.
    }
    
    func rightNavbtn(widthOfBtn:Int){
        btnEdit = UIButton.init(frame: CGRect(x: 0, y:0, width:widthOfBtn,height: 23))
        btnEdit.setImage(UIImage(named:"edit-white"), for: .normal)
        btnEdit.addTarget(self, action: #selector(editBtn), for: .touchUpInside)
        let editBarButton = UIBarButtonItem(customView: btnEdit)
        let arryOFRightBarButton: Array = [editBarButton]
        let widthConstraint = btnEdit.widthAnchor.constraint(equalToConstant: CGFloat(widthOfBtn))
        let heightConstraint = btnEdit.heightAnchor.constraint(equalToConstant: 23)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        self.navigationItem.rightBarButtonItems = arryOFRightBarButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "My Profile"
        
        //Call WS
        if flag {
            self.getProfile()
        }
        
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
    @objc func editBtn() {
        if strStatEdit == "1" {
            
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
            else {
                strStatEdit = ""
                rightNavbtn(widthOfBtn:23)
                btnEdit.setImage(UIImage(named:"edit-white"), for: .normal)
                txtOfName.isUserInteractionEnabled = false
                textOfEmail.isUserInteractionEnabled = false
                textOfMobile.isUserInteractionEnabled = false
                textOfDOB.isUserInteractionEnabled = false
                btnSendMeUpdate.isUserInteractionEnabled = false
                btnUpdatePass.isUserInteractionEnabled = false
                btnProfile.isUserInteractionEnabled = false
                ImgOfCamera.isHidden = true
                
                //Call WS
                updateProfile()
            }
        }
        else {
            strStatEdit = "1"
            //btnEdit.setImage(UIImage(named:"edit-check"), for: .normal)
            rightNavbtn(widthOfBtn:65)
            btnEdit.setImage(UIImage(named:""), for: .normal)
            btnEdit.setTitle("Update", for: .normal)
            txtOfName.isUserInteractionEnabled = true
            textOfEmail.isUserInteractionEnabled = false
            textOfMobile.isUserInteractionEnabled = true
            textOfDOB.isUserInteractionEnabled = true
            btnSendMeUpdate.isUserInteractionEnabled = true
            btnUpdatePass.isUserInteractionEnabled = true
            btnProfile.isUserInteractionEnabled = true
            ImgOfCamera.isHidden = false
        }
    }
    @IBAction func btnCreateAccntClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: "", message: NSLocalizedString("Are you sure you want to delete account?", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: UIAlertActionStyle.destructive, handler:{
            action in
            let dictionary = [
                "userId": String(userInfo.userID),
                "userPrivateKey" : userInfo.privateKey,
                "related_flag" : "1",
                ]
            
            var strURL = ""
            strURL = String(strURL.characters.dropFirst(1))
            strURL = Url.baseURL + "deleteUserProfile?"
            print(strURL)
            strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            if Validation1.isConnectedToNetwork() == true {
                self.startActivityIndicator()
                _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                self.callWSOfDeleteProfile(strURL: strURL, dictionary: dictionary)
            }else{
                self.view.makeToast(string.noInternateMessage2)
                self.stopActivityIndicator()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: UIAlertActionStyle.cancel, handler:nil))
        self.present(alertController,animated: true,completion: nil)
    }
    
    @IBAction func updatePasswordclick(_ sender: Any) {
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpadtePassword") as! UpadtePassword
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnProfileClick(_ sender: Any) {
        alertCameraGallary()
    }
}

// MARK: textField Delegate
extension MyProfile: UITextFieldDelegate{
    
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
        else {
            textOfDOB.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textOfDOB{
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            
            var components = DateComponents()
            components.year = -100
            //let minDate = Calendar.current.date(byAdding: components, to: Date())
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
extension MyProfile{
    
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
extension MyProfile : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
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
        flag = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage : UIImage
        
        if let possibleImg = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = possibleImg
            imgOfProfile.image = newImage
            flag = false
        }
        else if let possibleImg = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //imageOfPRofile1.image = possibleImg
            newImage = possibleImg
            imgOfProfile.image = newImage
            flag = false
        }
        else{
            flag = false
            return
        }
        print("New Image Size Is: ",newImage.size)
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - WS GetMyProfile/Update Profile
extension MyProfile {
    // MARK: - WS GetMyProfile
    func getProfile(){
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1"]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getProfile?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfgetProfile(strURL: strURL, dictionary: dictionary )
        }else {
            self.view.makeToast(string.noInternetConnMsg)
        }
    }
    
    func callWSOfgetProfile(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            var data = [String:String]()
            data = JSONResponse as! [String : String]
            //let response = JSONResponse
            if data["status"] == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.txtOfName.text = data["userName"]
                    self.textOfMobile.text = data["mobileNumber"]
                    self.textOfDOB.text = data["birthDate"]
                    self.textOfEmail.text = data["emailAddress"]
                    let updatesByEmailFlag = data["updatesByEmailFlag"]
                    if updatesByEmailFlag == "1"{
                        self.btnSendMeUpdate.setImage(UIImage(named:"check1"), for: .normal)
                        self.strCheck = "1"
                    }else {
                        self.btnSendMeUpdate.setImage(UIImage(named:"square"), for: .normal)
                        self.strCheck = "0"
                    }
                    
                    let imgUrl = data["userImage"]
                    let imgName = self.separateImageNameFromUrl(Url: imgUrl!)
//                    self.imgOfProfile.image = UIImage.init(named: "Profilea.png")
                    if (self.cache.object(forKey: imgName as AnyObject) != nil){
                        self.imgOfProfile.image = self.cache.object(forKey: imgName as AnyObject) as? UIImage
                    }
                    else{
                        let imgurl = imgUrl
                        if Validation1.checkNotNullParameter(checkStr: imgurl!) == false {
                            Alamofire.request(imgUrl!).responseImage{ response in
                                if let image = response.result.value {
                                    self.imgOfProfile.image = image
                                    self.cache.setObject(image, forKey: imgName as AnyObject)
                                }
                                else {
                                    self.imgOfProfile.image = UIImage.init(named: "Profilea.png")
                                }
                            }
                        }else {
                            self.imgOfProfile.image = UIImage.init(named: "Profilea.png")
                        }
                    }
                }
            }
            else{
                let status = data["status"]
                self.stopActivityIndicator()
                switch status!{
                case "0":
                    //When Parameter Missing
                    print("error2: ")
                    self.view.makeToast((data["message"])!)
                    if (data["message"]) == "logout"{
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is login {
                                //isVCFound = true
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }
                    
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
    
    // MARK: - WS Update Profile
    func updateProfile(){
        
        /*let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date: Date? = dateFormatter.date(from: textOfDOB.text!)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let strDate: String = dateFormatter.string(from: date!)*/

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date: Date? = dateFormatter.date(from: textOfDOB.text!)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let birthDate: String = dateFormatter.string(from: date!)
        
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "loginType" : "normal",
                          "emailAddress" : textOfEmail.text!,
                          "related_flag" : "1",
                          "name" : txtOfName.text!,
                          "mobileNumber" : textOfMobile.text!,
                          "birthDate" : birthDate,
                          "updatesByEmailFlag" : strCheck]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "updateProfile?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfUpdateProfile(strURL: strURL, dictionary: dictionary )
        }else {
            self.view.makeToast(string.noInternetConnMsg)
        }
        
    }
    
    func callWSOfUpdateProfile(strURL: String, dictionary:Dictionary<String,String>){
        _ = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: true, fileName: "userImage", params: dictionary as [String : AnyObject], image: imgOfProfile.image!, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            var data = [String:String]()
            data = JSONResponse as! [String : String]
            if data["status"] == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    UserDefaults.standard.set(JSONResponse["userImage"] as? String, forKey: "userImage")
                    self.strStatEdit = "0"
                    self.view.makeToast((data["message"])!)
                }
            }
            else{
                let status = data["status"]
                self.stopActivityIndicator()
                switch status!{
                case "0":
                    //When Parameter Missing
                    print("error2: ")
                    self.view.makeToast((data["message"])!)
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
    
    //MARK: -  WS Delete Profile
    func callWSOfDeleteProfile(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            var data = [String:String]()
            data = JSONResponse as! [String : String]
            if data["status"] == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.view.makeToast((data["message"])!)
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
                let status = data["status"]
                self.stopActivityIndicator()
                switch status!{
                case "0":
                    //When Parameter Missing
                    print("error2: ")
                    self.view.makeToast((data["message"])!)
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
