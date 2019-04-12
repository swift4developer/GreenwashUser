//
//  OderDetails.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 30/10/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import Alamofire
import BraintreeDropIn
import Braintree

class OderDetails: UIViewController,NVActivityIndicatorViewable {

//    var braintree : Braintree?
    
    //MARK: - Out_lets
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewOfScrollView: UIView!
    @IBOutlet var imgOfProfile: UIImageView!
    @IBOutlet var lblOfProfileName: UILabel!
    @IBOutlet var lblOfOrderInfo: UILabel!
    @IBOutlet var lblOfOrderStatus: UILabel!
    
    @IBOutlet var imgOfCalnder: UIImageView!
    @IBOutlet var lblOfOrderDateTitle: UILabel!
    @IBOutlet var lblOfOrderDate: UILabel!
    @IBOutlet var imgOfOrderId: UIImageView!
    @IBOutlet var lblOfOrderId: UILabel!
    @IBOutlet var imgOfOrderTIme: UIImageView!
    @IBOutlet var lblOfOrderIdTitle: UILabel!
    @IBOutlet var lblOfOrderTimeTitle: UILabel!
    @IBOutlet var lblOfOrderTIme: UILabel!
    
    @IBOutlet var lblofAddressTitle: UILabel!
    @IBOutlet var lblOfAddress: UILabel!
    @IBOutlet var viewOfSpecailInstrcutn: UIView!
    @IBOutlet var lblOfSpecailInstructnTitle: UILabel!
    @IBOutlet var lblOFSpecailInstrcutn: UILabel!
    @IBOutlet var viewOfPaymntinfo: UIView!
    @IBOutlet var lblOfPrice: UILabel!
    @IBOutlet var lblOfPaymntStatus: UILabel!
    
    @IBOutlet var btnMkePymnt: UIButton!
    @IBOutlet var hightOfSpecailInstrctnView: NSLayoutConstraint!
    @IBOutlet var hightOfPaymntInfoView: NSLayoutConstraint!
    
    @IBOutlet var viewOfCollectionView: UIView!
    @IBOutlet var collectionOfImges: UICollectionView!
    @IBOutlet var hightOfCollectnVIew: NSLayoutConstraint!
    
    var arryOfWorkImges = Array<Any>()
    @IBOutlet var heightOfMakePymntBtn: NSLayoutConstraint!
    
    var falgCallFrm = ""
    var orderId = ""
    var serviceId = ""
    var noDataView = UIView()
    var arryOfData : [Any] = []
    var chache : NSCache<AnyObject, AnyObject>!
    var dicData : [String:Any] = [:]
    var paymentPrice = ""
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chache = NSCache()
        setNaviBackButton()
        navigationDesign()
        self.title = "Orders Details"
        
        
        //arryOfWorkImges = [UIImage(named:"logo.png")!,UIImage(named:"logo.png")!]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if falgCallFrm == "OrderCompleted" {
            btnMkePymnt.isHidden = true
            viewOfPaymntinfo.isHidden = false
            heightOfMakePymntBtn.constant = 0.0
            viewOfCollectionView.isHidden = false
            
        }else if falgCallFrm == "OrderCanceled" {
            btnMkePymnt.isHidden = true
            viewOfPaymntinfo.isHidden = true
            heightOfMakePymntBtn.constant = 0.0
            viewOfCollectionView.isHidden = true
            
        }else {
            btnMkePymnt.isHidden = false
            viewOfPaymntinfo.isHidden = false
            heightOfMakePymntBtn.constant = 45.0
            viewOfCollectionView.isHidden = false
        }
        
        //Call WS
        getOrderDetails()
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @IBAction func btnMakePymtnClick(_ sender: Any) {
        
        if (self.dicData["serviceStatus"] as? String == "Booking Pending") || (self.dicData["serviceStatus"] as? String == "Booking Accepted"){
            //call cancel the order
            cancelOrder()
        }else if self.dicData["serviceStatus"] as? String == "Work In Progress"{
            self.btnMkePymnt.isUserInteractionEnabled = false
        }else if self.dicData["serviceStatus"] as? String == "Work Stopped"{
            
        }else if self.dicData["serviceStatus"] as? String == "Work Completed"{
            self.viewOfPaymntinfo.isHidden = false
            if self.dicData["paymentStatus"] as? String == "Unpaid" {
                 //"Unpaid"
                //Make Payment here
                getClientToken()
            }else {
               // "Paid"
            }
        }
    }
}

// MARK: ColelctionView Delegete
extension OderDetails : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arryOfWorkImges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgaeCollectionCell", for: indexPath) as! ImgaeCollectionCell
        
        let currentDic = self.arryOfWorkImges[indexPath.row] as! [String : Any]
        
        if (currentDic["image_path"] as? String != nil){
            let imgUrl = currentDic["image_path"] as? String
            
            let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
            cell.imgOfWork.backgroundColor = color.grayColor
            
            if(self.chache.object(forKey: imageName as AnyObject) != nil){
                cell.imgOfWork.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
            }else{
                if Validation1.checkNotNullParameter(checkStr: imgUrl!) == false {
                    Alamofire.request(imgUrl!).responseImage{ response in
                        if let image = response.result.value {
                            cell.imgOfWork.image = image
                            self.chache.setObject(image, forKey: imageName as AnyObject)
                        }
                        else {
                            cell.imgOfWork.backgroundColor = color.grayColor
                        }
                    }
                }else {
                    cell.imgOfWork.backgroundColor = color.grayColor
                }
            }
        }else {
            cell.imgOfWork.backgroundColor = color.grayColor
        }
        
        return cell
    }
}

//MARK: - Call WS
extension OderDetails {
    func getOrderDetails(){
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
                          "orderId" : orderId
        ]
        
        print("Oder Details I/P:",dictionary)
        var strURL = ""
        
        for (key, value) in dictionary {
            strURL=strURL+"&"+key+"="+value
        }
        
        var strURL1 = String(strURL.characters.dropFirst(1))
        strURL1 = Url.baseURL + "getOrderDetails?" + strURL
        strURL1 = strURL1.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfgetOrderDetails(strURL: strURL1)
        }else {
            //self.view.makeToast(string.noInternetConnMsg)
            self.stopActivityIndicator()
            self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.noInternetConnMsg, lableNoInternate: string.noInternateMessage2)
            self.viewOfScrollView.addSubview(self.noDataView)
        }
    }
    
    func callWSOfgetOrderDetails(strURL: String){
        AFWrapper.requestGETURLWithReturnArray(strURL, success: {
            (JSONResponse) -> Void in
            if let array = JSONResponse as? [Any] {
                self.stopActivityIndicator()
                if array.count > 0{
                    print("data: ",array[0])
                    
                    self.dicData = array[0] as! [String : Any]
                    self.lblOfProfileName.text = self.dicData["serviceProviderName"] as? String
                    self.lblOfOrderInfo.text = self.dicData["serviceName"] as? String
                    self.lblOfOrderDate.text = self.dicData["orderDate"] as? String
                    self.serviceId = (self.dicData["serviceId"] as? String)!
                    self.lblOfOrderId.text = self.serviceId
                    self.lblOfOrderTIme.text = self.dicData["orderTimeBlock"] as? String
                    self.lblOfAddress.text = self.dicData["address"] as? String

                    let strng = (self.dicData["serviceStatus"] as? String)!
                    let status = "Order Status - " + strng
                    let stringAttributed = NSMutableAttributedString.init(string: status)
                    let font = UIFont(name: "Helvetica Neue", size: 14.0)
                    stringAttributed.addAttribute(NSAttributedStringKey.font, value:font!, range: NSRange.init(location: 0, length: 15))
                    stringAttributed.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange.init(location: 0, length: 15))
                    
                    self.lblOfOrderStatus?.attributedText = stringAttributed;
                    
                    
                    if (self.dicData["serviceStatus"] as? String == "Booking Pending") || (self.dicData["serviceStatus"] as? String == "Booking Accepted"){
                        self.btnMkePymnt.isHidden = false
                        self.btnMkePymnt.setTitle("Cancel Order", for: .normal)
                        self.btnMkePymnt.backgroundColor = color.redColor
                        self.btnMkePymnt.isUserInteractionEnabled = true
                        self.viewOfPaymntinfo.isHidden = true
                        
                    }else if self.dicData["serviceStatus"] as? String == "Work In Progress"{
                        self.btnMkePymnt.isHidden = false
                        self.btnMkePymnt.setTitle("Cancel Order", for: .normal)
                        self.btnMkePymnt.backgroundColor = color.redColor
                        self.btnMkePymnt.isUserInteractionEnabled = false
                        self.viewOfPaymntinfo.isHidden = true
                        
                    }else if self.dicData["serviceStatus"] as? String == "Work Stopped"{
                        self.btnMkePymnt.isHidden = true
                        self.viewOfPaymntinfo.isHidden = true
                        
                    }else if self.dicData["serviceStatus"] as? String == "Work Completed"{
                        self.viewOfPaymntinfo.isHidden = false
                        self.paymentPrice = (self.dicData["totalCharges"] as? String)!
                        self.lblOfPrice.text = self.paymentPrice
                        if self.dicData["paymentStatus"] as? String == "Unpaid" {
                            self.btnMkePymnt.isHidden = false
                            self.lblOfPaymntStatus.text = "Unpaid"
                        }else {
                            self.btnMkePymnt.isHidden = true
                            self.lblOfPaymntStatus.text = "Paid"
                        }
                    }
                    if (self.dicData["specialInstructions"] as? String != nil){
                        if Validation1.checkNotNullParameter(checkStr: (self.dicData["specialInstructions"] as? String)!){
                            self.lblOFSpecailInstrcutn.text = ""
                            self.viewOfSpecailInstrcutn.isHidden = true
                            self.lblOfSpecailInstructnTitle.isHidden = true
                        }else {
                            self.lblOFSpecailInstrcutn.text = self.dicData["specialInstructions"] as? String
                            self.viewOfSpecailInstrcutn.isHidden = false
                            self.lblOfSpecailInstructnTitle.isHidden = false
                        }
                        
                    }else {
                        self.lblOFSpecailInstrcutn.text = ""
                        self.viewOfSpecailInstrcutn.isHidden = true
                        self.lblOfSpecailInstructnTitle.isHidden = true
                    }
                    
                    if (self.dicData["ordersImagesList"] as? [Any] != nil){
                        self.arryOfWorkImges = (self.dicData["ordersImagesList"] as? [Any])!
                        if self.arryOfWorkImges.count > 0{
                            self.collectionOfImges.reloadData()
                            self.viewOfCollectionView.isHidden = false
                        }else {
                            self.viewOfCollectionView.isHidden = true
                        }
                    }else {
                        self.viewOfCollectionView.isHidden = true
                    }
                }else{
                    self.stopActivityIndicator()
                    self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: "No order details found.")
                    self.viewOfScrollView.addSubview(self.noDataView)
                }
            }
            else{
                DispatchQueue.main.async {
                    //self.view.makeToast(string.someThingWrongMsg)
                    self.stopActivityIndicator()
                    self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: "No order details found.")
                    self.viewOfScrollView.addSubview(self.noDataView)
                }
            }
        }) {
            (error) -> Void in
            DispatchQueue.main.async {
                self.view.makeToast(string.someThingWrongMsg)
                self.stopActivityIndicator()
            }
        }
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
                          "orderId": orderId,
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.view.makeToast((JSONResponse["message"] as? String)!)
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

    
//MARK: - Make Payment
    
    func getClientToken(){
        // TODO: Step 1 : Get Client Token From Server
        //http://27.109.19.234/taskfinder/public/index.php/api/getClientToken?userId=292&userPrivateKey=GD3ZTGECrM7DozT2&related_flag=1
        
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
            ] as [String : Any]

        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getClientToken?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfGetClientToken(strURL: strURL, dictionary: dictionary )
        }else {
            self.view.makeToast(string.noInternetConnMsg)
            self.stopActivityIndicator()
        }
    }
    
    func callWSOfGetClientToken(strURL: String, dictionary:Dictionary<String,Any>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                self.stopActivityIndicator()
                DispatchQueue.main.async {
                    //self.view.makeToast((JSONResponse["message"] as? String)!)
                    //Handle errors
                    guard let clientToken = (JSONResponse["clientToken"] as? String) else { return }
                    print("clientToken : ",clientToken )
                    
                    self.showDropIn(clientTokenOrTokenizationKey: clientToken)
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
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        // TODO: Step 2 : Get nonce From Server
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
                if let nonce = result.paymentMethod?.nonce {
                    print("nonce ",nonce)
                    self.paymentPrice = self.paymentPrice.replacingOccurrences(of: "$", with: "")
                    print("paymentPrice ",self.paymentPrice)
                    self.sendRequestPaymentToServer(nonce: nonce, amount: self.paymentPrice)
                }
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    func sendRequestPaymentToServer(nonce: String, amount: String) {
        
         // TODO: Step 3 : Request Payment To Server
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
                          "orderId": orderId,
                          "nonce": nonce,
                          "amount" : amount
            ] as [String : Any]
        
        print("send Request Payment I/P: ",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "addMakePayment?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfMakePayment(strURL: strURL, dictionary: dictionary )
        }else {
            self.view.makeToast(string.noInternetConnMsg)
            self.stopActivityIndicator()
        }
    }
    
    
    
    func callWSOfMakePayment(strURL: String, dictionary:Dictionary<String,Any>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                self.stopActivityIndicator()
                DispatchQueue.main.async {
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
                    vc.orderId = self.orderId
                    vc.serviceId = self.serviceId
                    self.navigationController?.pushViewController(vc,animated: true)
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
