//
//  ViewController_Extension.swift
//  MalaBes
//
//  Created by PUNDSK006 on 4/18/17.
//  Copyright © 2017 Intechcreative Pvt. Ltt. All rights reserved.
//

import Foundation
import UIKit
protocol SortDelegate
{
    func get(SelectedItem : String?)
}

extension UIApplication {
    
    var screenShot: UIImage?  {
        
        if let rootViewController = keyWindow?.rootViewController {
            let scale = UIScreen.main.scale
            let bounds = rootViewController.view.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale);
            if let _ = UIGraphicsGetCurrentContext() {
                rootViewController.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return screenshot
            }
        }
        return nil
    }
    
}
extension UIViewController{
    
    /*func logoutVCCall() {
        userInfo.privateKey = ""
        userInfo.userID = ""
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "private_Key")
        UserDefaults.standard.removeObject(forKey: "FromMyAccount")
        
        var isVCFound = false
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is LoginViewController {
                isVCFound = true
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
        if isVCFound == false{
            self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))!, animated: true)
        }
    }*/
    /*/ MARK:- UIActivityIndicatorView
    
    var activityIndicatorTag : Int {
        return 9999
    }
    var viewTag : Int {
        return 999
    }
    func startActivityIndicator(
        style: UIActivityIndicatorViewStyle? = nil,
        
        location: CGPoint? = nil) {
        let loc = location ?? self.view.center
        let styl = style ?? .whiteLarge
        
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: styl)
            let view1 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            view1.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.2)
            
            //Add the tag so we can find the view in order to remove it later
            activityIndicator.tag = self.activityIndicatorTag
            view1.tag = self.viewTag
            
            //Set the location
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            //Start animating and add the view
            activityIndicator.startAnimating()
            self.view.addSubview(view1)
            
            // self.view.addSubview(view1)
            // view1.addSubview(activityIndicator)
        }
    }
    //StopActivity
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            //            if let activityIndicator = self.view.subviews.filter(
            //                { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
            //                activityIndicator.stopAnimating()
            //                activityIndicator.removeFromSuperview()
            //            }
            
            
            if let view =  self.view.subviews.filter(
                { $0.tag == self.viewTag }).first {
                //activityIndicator.stopAnimating()
                view.removeFromSuperview()
            }
        }
    }*/
    
    func createSettingsAlertController(title: String, message: String) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment:"" ), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment:"" ), style: .default, handler: { action in
            
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                if #available(iOS 10, *){
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                }
                else{
                    _ = UIApplication.shared.openURL(url)
                }
            }
          //  UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        controller.addAction(cancelAction)
        controller.addAction(settingsAction)
        return controller
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    //Add Shake animation and Remove Animation
    func addAnimation1(txtField: UITextField){
        txtField.background = nil
        txtField.layer.borderColor = color.shakeBorderColor.cgColor
        txtField.layer.borderWidth = 1.0
        txtField.shake()
    }
    
    func removeAnimation1(txtField: UITextField){
        txtField.layer.borderColor = nil
        txtField.layer.borderWidth = 0.0
        txtField.layer.borderColor = UIColor.clear.cgColor
        txtField.layer.borderWidth = 0.0
    }
    
    // MARK:- navigationController :- Set TintColor and Title
    
    func setNaviTitleWithBarTintColor(){
        let defaults = UserDefaults.standard
        let type = defaults.value(forKey: "Device") as? String
        if type! == "iPad" {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color.navigationBar,  NSAttributedStringKey.font:UIFont(name: fontAndSizeForIPad.NaviTitleFont, size: fontAndSizeForIPad.NaviTitleFontSize)!]
        } else {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color.navigationBar,  NSAttributedStringKey.font:UIFont(name: fontAndSize.NaviTitleFont, size: fontAndSize.NaviTitleFontSize)!]
        }
        self.navigationController?.navigationBar.barTintColor = color.barTintColor
    }
    
    
    // MARK:- navigationController :- Set Back Button
    
    func setNaviBackButton()
    {
        let defaults = UserDefaults.standard
        let type = defaults.value(forKey: "Device") as? String
        if type! == "iPad" {
            //Design Of Navigation Bar Back_Button
            let btnBack = UIButton(frame: CGRect(x: 0, y:0, width:30,height: 30))
            btnBack.setImage(UIImage(named:"back"), for: .normal)
            btnBack.addTarget(self,action: #selector(back), for: .touchUpInside)
            let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 30)
            let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 30)
            heightConstraint.isActive = true
            widthConstraint.isActive = true
            
            let backBarButtonitem = UIBarButtonItem(customView: btnBack)
            let arrLeftBarButtonItems : Array = [backBarButtonitem]
            self.navigationItem.leftBarButtonItems = arrLeftBarButtonItems
        }
        else {
            //Design Of Navigation Bar Back_Button
            let btnBack = UIButton(frame: CGRect(x: 0, y:0, width:20,height: 20))
            btnBack.setImage(UIImage(named:"back"), for: .normal)
            btnBack.addTarget(self,action: #selector(back), for: .touchUpInside)
            let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 20)
            let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 20)
            heightConstraint.isActive = true
            widthConstraint.isActive = true
            
            let backBarButtonitem = UIBarButtonItem(customView: btnBack)
            let arrLeftBarButtonItems : Array = [backBarButtonitem]
            self.navigationItem.leftBarButtonItems = arrLeftBarButtonItems
        }
    }
    
    
    /*/ MARK:- navigationController :- Set Cirlce Back With Title
    
    func NaviCircleBack(Title: String){
        self.navigationController?.navigationBar.barTintColor = color.barTintColor
        
        //GetWidth
        
        let width = Title.widthOfString(usingFont:UIFont(name: fontAndSize.NaviTitleFont, size: 17)!)
        
        
        // Set Back Button with image  and Add Action
        let btnBack = UIButton(frame: CGRect(x: 0, y:0, width:30,height: 30))
        btnBack.setImage(UIImage(named:"backCircle"), for: .normal)
        btnBack.addTarget(self,action: #selector(btnBack), for: .touchUpInside)
        
        
        //Set Title
        var  btntitle = UIButton()
        
        if width >= ScreenSize.SCREEN_WIDTH
        {
            btntitle = UIButton(frame: CGRect(x:0, y:0, width:100,height: 20))
        }
        else
        {
            btntitle = UIButton(frame: CGRect(x:0, y:0, width:width,height: 20))
        }
       

        btntitle.setTitle(Title, for: .normal)
        btntitle.setTitleColor(color.navigationBar, for: .normal)
        btntitle.titleLabel?.font = UIFont(name: fontAndSize.NaviTitleFont, size: 17)
        btntitle.titleLabel?.textAlignment = .left
        btntitle.addTarget(self,action: #selector(btnBack), for: .touchUpInside)
        
        
        let menuBarButtonitem = UIBarButtonItem(customView: btnBack)
        let titleBarButtonitem = UIBarButtonItem(customView: btntitle)
        
        let arrLeftBarButtonItems : Array = [menuBarButtonitem,titleBarButtonitem]
        self.navigationItem.leftBarButtonItems = arrLeftBarButtonItems
        
    }*/
    
    // MARK:- navigationController :- Set Design
    func navigationDesign(){
        setNaviTitleWithBarTintColor()
    }
    // MARK:- navigationController :- Set Back Action
    @objc func back(){
        //stopActivityIndicator()
        self.navigationController?.popViewController(animated: true)
    }
     // MARK:- default sharing
    func defaultShareTextWithImage(text:String) {
        // image and text to share
        let text = text
        
        // set up activity view controller
        let imageToShare = [text ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }

    /*func customPop(imgeFlag:String , labelOfMsg1:String, labelOfMsg2:String, flagForOkBtn:String)-> UIView
    {
        
        var alertViewHight = 0
        if imgeFlag == "4" {
            alertViewHight = 200
        }
        else {
            alertViewHight = 160
        }
        
        let screenSize: CGRect = UIScreen.main.bounds
        let popMainView = UIView(frame:CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height))
        popMainView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        popMainView.isOpaque = false
        popMainView.isUserInteractionEnabled = true
        
        let alertView = UIView(frame: CGRect(x:20, y: 100, width : Int(screenSize.width - 40), height: alertViewHight))
        alertView.backgroundColor = UIColor.white
        popMainView.addSubview(alertView)
        alertView.center.x = popMainView.center.x
        alertView.center.y = popMainView.center.y
        
        
        //close_button
        let closebtn = UIButton()
        closebtn.frame = CGRect.init(x:alertView.frame.size.width - 32,y:8,width:22, height: 22)
        closebtn.setImage(UIImage(named:"colse"), for: .normal)
        closebtn.addTarget(self, action:#selector(btnCloseClick) , for: .touchUpInside)
        alertView.addSubview(closebtn)
        
        //no_button
        let yesbtn = UIButton()
        yesbtn.frame = CGRect.init(x:alertView.frame.size.width - 32,y:8,width:22, height: 22)
        yesbtn.setImage(UIImage(named:"colse"), for: .normal)
        yesbtn.addTarget(self, action:#selector(btnYesClick) , for: .touchUpInside)
        
        //no_button
        let nobtn = UIButton()
        nobtn.frame = CGRect.init(x:alertView.frame.size.width - 32,y:8,width:22, height: 22)
        nobtn.setImage(UIImage(named:"colse"), for: .normal)
        nobtn.addTarget(self, action:#selector(btnNoClick) , for: .touchUpInside)

        //label sucess
        let lblNew1 = UILabel()
        lblNew1.text = labelOfMsg1
        lblNew1.textColor = UIColor.darkGray
        lblNew1.frame = CGRect.init(x: 15, y: 70, width: alertView.frame.size.width - 30, height: 75)
        lblNew1.textAlignment = .center
        lblNew1.numberOfLines = 0
        alertView.addSubview(lblNew1)
        
        //label info
        let lblNew = UILabel()
        lblNew.frame = CGRect.init(x: 15, y: 120, width: alertView.frame.size.width - 30, height: 75)
        lblNew.text = labelOfMsg2
        lblNew.textColor = UIColor.darkGray
        lblNew.textAlignment = .center
        lblNew.numberOfLines = 0
        alertView.addSubview(lblNew)
        
        //Image
        var imageName = UIImage(named: "")
        
        if imgeFlag == "1" {
            imageName = UIImage(named: "check-icon")
        }
        else if imgeFlag == "2" {
            imageName = UIImage(named: "CVV")
        }
        else if imgeFlag == "3" {
            imageName = UIImage(named: "check-icon") // No Data/Somthing wents Wrong with Back Button
        }
        else if imgeFlag == "4" {
            lblNew1.textColor = UIColor.init(red: 68/255, green: 153/255, blue: 220/255, alpha: 1.0)
            imageName = UIImage(named: "check-icon") // No Intenate wents Wrong with Back Button
            lblNew.textAlignment = .center
        }
        else if imgeFlag == "5"{
            imageName = UIImage(named: "check-icon")
        }
        else if imgeFlag == "6"{
            imageName = UIImage(named: "")
            alertView.addSubview(yesbtn)
            alertView.addSubview(nobtn)
        }
        
        let imageView = UIImageView(image:imageName!)
        imageView.frame = CGRect.init(x: 30, y: 15, width: alertView.frame.size.width - 40, height: 60)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        alertView.addSubview(imageView)
        
        return popMainView
    }

    @objc func btnYesClick()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @objc @objc func btnNoClick()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnCloseClick()
    {
        self.navigationController?.popViewController(animated: true)
    }*/
    func separateImageNameFromUrl(Url:String) -> String {
        let ownerImgUrl = Url
        let array = ownerImgUrl.components(separatedBy: "/")
        var imgName = ""
        if (array.count) > 0{
            imgName = (array.last)!
        }
        return imgName
    }
    
    func isValidDecimal(_ currText: String, _ range : NSRange, _ string: String) -> Bool {
        let replacementText = (currText as NSString).replacingCharacters(in: range, with: string)
        
        // Validate
        return replacementText.isValidDecimal(maximumFractionDigits: 2)
    }
    
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return  dateFormatter.string(from: date!)
        
    }
    
    //MARK:- - NO Internate and No Data Found View
    
    func noInternatViewWithReturnView(imgeFlag:String, lableNoData:String, lableNoInternate: String)-> UIView{
        
        let screenSize: CGRect = UIScreen.main.bounds
        let noIntenateView = UIView(frame: CGRect(x:0, y:0, width: screenSize.width, height: screenSize.height))
        noIntenateView.backgroundColor = UIColor.white
        // self.view.addSubview(noIntenateView)
        noIntenateView.isUserInteractionEnabled = false
        
        //Button
        let backButton = UIButton()
        backButton.frame = CGRect.init(x: 15, y: 40, width: 30, height: 30)
        backButton.setImage(UIImage(named:"backBalck"), for: .normal)
        backButton.addTarget(self,action: #selector(back), for: .touchUpInside)
        
        var topOfbgView:CGFloat = 100
        var imageName = UIImage(named: "")
        if imgeFlag == "1" {
            imageName = UIImage(named: "noInternate")
        }
        else if imgeFlag == "0" {
            topOfbgView = 150
            imageName = UIImage(named: "white")
        }
        else if imgeFlag == "2" {
            imageName = UIImage(named: "sad_face")
        }
        else if imgeFlag == "3" {
            imageName = UIImage(named: "sad_face") // No Data/Somthing wents Wrong with Back Button
            noIntenateView.addSubview(backButton)
            noIntenateView.isUserInteractionEnabled = true
        }
        else if imgeFlag == "4" {
            imageName = UIImage(named: "noInternate") // No Intenate wents Wrong with Back Button
            noIntenateView.addSubview(backButton)
            noIntenateView.isUserInteractionEnabled = true
        }
        else if imgeFlag == "5"{
            topOfbgView = 150
        }
        else if imgeFlag == "6"{
            imageName = UIImage(named: "sad_face")
        }
        
        let bgView = UIView(frame: CGRect(x:0, y:(noIntenateView.frame.size.width/2.0) - 100, width: screenSize.width, height:220))
        bgView.backgroundColor = UIColor.white
        // self.view.addSubview(noIntenateView)
        bgView.isUserInteractionEnabled = false
        noIntenateView.addSubview(bgView)
        
        bgView.center = CGPoint.init(x: noIntenateView.frame.size.width  / 2, y: (noIntenateView.frame.size.height / 2) - topOfbgView)
        
        
        /*/Image
        let imageView = UIImageView(image: imageName!)
        imageView.frame = CGRect.init(x: 140, y: 0, width: noIntenateView.frame.size.width - 280, height: 100)
        bgView.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.scaleAspectFit*/
        
        //label for no Data
        let lblNew = UILabel()
        lblNew.text = lableNoData
        lblNew.textColor = UIColor.darkGray
        lblNew.frame = CGRect.init(x: 50, y: 100 , width: noIntenateView.frame.size.width - 100, height: 30)
        lblNew.textAlignment = .center
        bgView.addSubview(lblNew)
        
        //label no internet
        let lblNew1 = UILabel()
        lblNew1.text = lableNoInternate
        lblNew1.textColor = UIColor.darkGray
        lblNew1.frame = CGRect.init(x: 30, y: lblNew.frame.origin.y + lblNew.frame.size.height + 10, width: noIntenateView.frame.size.width - 60, height: 50)
        lblNew1.numberOfLines = 0
        lblNew1.textAlignment = .center
        bgView.addSubview(lblNew1)
        return noIntenateView
    }
}

extension String{
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat{
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func isStringAnInt() -> Bool {
        
        if let _ = Int(self) {
            return true
        }
        return false
    }
        
    func widthOfString(usingFont font: UIFont) -> CGFloat{
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func strstr(needle: String, beforeNeedle: Bool = false) -> String? {
        guard let range = self.range(of: needle) else { return nil }
        
        if beforeNeedle {
            return self.substring(to: range.lowerBound)
        }
        return self.substring(from: range.upperBound)
    }
    
    
    private static let decimalFormatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()
    
    private var decimalSeparator:String{
        return String.decimalFormatter.decimalSeparator ?? "."
    }
    
    func isValidDecimal(maximumFractionDigits:Int)->Bool{
        
        // Depends on you if you consider empty string as valid number
        guard self.isEmpty == false else {
            return true
        }
        
        // Check if valid decimal
        if let _ = String.decimalFormatter.number(from: self){
            
            // Get fraction digits part using separator
            let numberComponents = self.components(separatedBy: decimalSeparator)
            let fractionDigits = numberComponents.count == 2 ? numberComponents.last ?? "" : ""
            return fractionDigits.characters.count <= maximumFractionDigits
        }
        
        return false
    }
    mutating func until(_ string: String) {
        var components = self.components(separatedBy: string)
        self = components[0]
    }
    mutating func nxtUntil(_ string: String) {
        var components = self.components(separatedBy: string)
        self = components[1]
    }
    
    func isValidDecimalWithNumber(maximumFractionDigits:Int)->Bool{
        
        // Depends on you if you consider empty string as valid number
        guard self.isEmpty == false else {
            return true
        }
        
        // Check if valid decimal
        if let _ = String.decimalFormatter.number(from: self){
            
            // Get fraction digits part using separator
            let numberComponents = self.components(separatedBy: decimalSeparator)
            let fractionDigits = numberComponents.count == 9 ? numberComponents.first ?? "" : ""
            return fractionDigits.characters.count <= maximumFractionDigits
        }
        
        return false
    }
    
}


extension NSMutableAttributedString{
    func widthOfString(usingFont font: UIFont) -> CGFloat{
        _ = [NSAttributedStringKey.font: font]
        let size = self.size()
        return size.width
    }
}

extension UIImageView{
    public func maskCircle(anyImage: UIImage){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
}



extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

extension UIProgressView {
    @IBInspectable var barHeight : CGFloat {
        get {
            return transform.d * 2.0
        }
        set {
            // 2.0 Refers to the default height of 2
            let heightScale = newValue / 2.0
            let c = center
            //transform = CGAffineTransformMakeScale(1.0, heightScale)
            transform = CGAffineTransform(scaleX: 1.0, y: heightScale)
            center = c
        }
    }
}

extension UIView{
    func shake(){
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [ 0, 10, -10, 10, 0 ]
        animation.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 1.0 / 6.0), NSNumber(value: 3.0 / 6.0), NSNumber(value: 5.0 / 6.0), NSNumber(value: 1.0)]
        animation.duration = 0.4;
        animation.isAdditive = true
        
        layer.add(animation, forKey: "shake")
    }
}

extension Float{
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}

public extension LazyMapCollection{
    func toArray() -> [Element]{
        return Array(self)
    }
}




