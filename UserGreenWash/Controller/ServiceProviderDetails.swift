//
//  ServiceProviderDetails.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 06/11/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import Alamofire

class ServiceProviderDetails: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var scrllView: UIScrollView!
    @IBOutlet weak var viewOfScrll: UIView!
    @IBOutlet weak var viewOfProfile: UIView!
    @IBOutlet weak var viewOfRiviewJob: UIView!
    @IBOutlet weak var viewOfOtherServices: UIView!
    @IBOutlet weak var viewOFCustomerReview: UIView!
    @IBOutlet weak var btnOfBookNow: UIButton!
    
    @IBOutlet weak var imgOfProfile: UIImageView!
    @IBOutlet weak var lblOfName: UILabel!
    
    @IBOutlet weak var lblOfReviewCount: UILabel!
    @IBOutlet weak var lblOfjobCount: UILabel!
    @IBOutlet weak var lblOfRatingCount: UILabel!
    @IBOutlet weak var btnOfFavClick: UIButton!
    @IBOutlet weak var imgOfFav: UIImageView!
    @IBOutlet weak var lblOfFav: UILabel!
    
    @IBOutlet weak var lblOfOtherServicesTitle: UILabel!
    @IBOutlet weak var lblOfCustomerReviewTitle: UILabel!
    @IBOutlet weak var tblOfOtherServices: UITableView!
    @IBOutlet weak var tblOfCutmerReview: UITableView!
    
    @IBOutlet weak var lblOfLine: UILabel!
    
    @IBOutlet weak var heightOfCustomrReview: NSLayoutConstraint!
    @IBOutlet weak var heightOfOtherServiceView: NSLayoutConstraint!
    
    @IBOutlet weak var heightOfOtherServiceTbl: NSLayoutConstraint!
    @IBOutlet weak var heightCuomerReviewTbl: NSLayoutConstraint!
    
    @IBOutlet weak var btnViewMoreReview: UIButton!
    
    var flagFrFav = ""
    var serviceProviderId = ""
    var childServicedId = ""
    var chache : NSCache<AnyObject,AnyObject>!
    var noDataView = UIView()
    var arryOfCustomrReview : [Any] = []
    var arryOfOtherServics : [Any] = []
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var servicveName = ""
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setNaviBackButton()
        navigationDesign()
        self.chache = NSCache()
    }
    override func viewWillAppear(_ animated: Bool) {
        //call WS
        getServicProvidrDetails()
    }
    
    override func viewDidLayoutSubviews() {
        //heightCuomerReviewTbl.constant = tblOfCutmerReview.contentSize.height
        let type =  UserDefaults.standard.value(forKey: "Device") as? String
        if type! == "iPad" {
            heightOfOtherServiceTbl.constant = tblOfOtherServices.contentSize.height + 68
            heightCuomerReviewTbl.constant = CGFloat(self.arryOfCustomrReview.count * 160)
            self.heightOfCustomrReview.constant = CGFloat(heightCuomerReviewTbl.constant + 60)
            self.heightOfOtherServiceView.constant = CGFloat(heightOfOtherServiceTbl.constant + 70)
        }else {
            heightOfOtherServiceTbl.constant = tblOfOtherServices.contentSize.height
            heightCuomerReviewTbl.constant = CGFloat(self.arryOfCustomrReview.count * 100)
            self.heightOfCustomrReview.constant = CGFloat(heightCuomerReviewTbl.constant + 32)
            self.heightOfOtherServiceView.constant = CGFloat(heightOfOtherServiceTbl.constant + 32)
        }
       
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @IBAction func btnOfFavClick(_ sender: Any) {
        callWSOfWSFavUnFav()
    }
    
    @IBAction func btnViewMoreReviewClick(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerReviewList") as! CustomerReviewList
        vc.serviceProviderId = serviceProviderId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOfBookNowClick(_ sender: Any) {
        
        self.appDelegate.postBookingReqDic["ProivderName"] = self.lblOfName.text!
        self.appDelegate.postBookingReqDic["ProviderRating"] = self.lblOfRatingCount.text!
        self.appDelegate.imgOfServiceProvider = self.imgOfProfile.image!

        //imgOfServiceProvider
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookServiceDateTime") as! BookServiceDateTime
        vc.childServicedId = childServicedId
        vc.serviceProviderId = serviceProviderId
        vc.servicveName = self.servicveName
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ServiceProviderDetails : UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblOfOtherServices{
            return self.arryOfOtherServics.count
        }
        else  {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tblOfOtherServices{
            let dicData = self.arryOfOtherServics[section] as! [String:Any]
            let arryData = dicData["subServicesList"] as! [Any]
            if arryData.count > 0 {
                return arryData.count
            }else {
                return 0
            }
        }
        else {
            return self.arryOfCustomrReview.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblOfOtherServices{
            let  cell = tableView.dequeueReusableCell(withIdentifier: "OtherServiceCell", for: indexPath) as! HomeScreenCell
            
            let dicData = self.arryOfOtherServics[indexPath.section] as! [String:Any]
            let arryData = dicData["subServicesList"] as! [Any]
            let currntDic = arryData[indexPath.row] as! [String:Any]
            if arryData.count > 0 {
                cell.lblOfServiceInfo.text = currntDic["subServiceName"] as? String
                cell.btnOfServiceCharge.setTitle(currntDic["serviceCharge"] as? String, for: .normal)
            }
            
             return cell
        }
        else {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "CutomerReviewCell", for: indexPath) as! HomeScreenCell
            
            let currntDic = arryOfCustomrReview[indexPath.row] as! [String:Any]
            
            if currntDic["reviewerName"] as? String != nil{
                cell.lblOfCutomerName.text = currntDic["reviewerName"] as? String
            }
            if currntDic["reviewDate"] as? String != nil{
                cell.lblOfReviewDate.text = currntDic["reviewerName"] as? String
            }
            if currntDic["review"] as? String != nil{
                cell.lblOfReviewDetails.text = currntDic["review"] as? String
            }
            if currntDic["reviewerImage"] as? String != nil{
                
                let imgUrl = currntDic["reviewerImage"] as? String
                
                let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                cell.imgOfProfile.backgroundColor = color.grayColor
                
                if (self.chache.object(forKey: imageName as AnyObject) != nil){
                    cell.imgOfProfile.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                }  else {
                    if Validation1.checkNotNullParameter(checkStr: imgUrl!) == false {
                        Alamofire.request(imgUrl!).responseImage{ response in
                            if let image = response.result.value {
                                cell.imgOfProfile.image = image
                                self.chache.setObject(image, forKey: imageName as AnyObject)
                            }
                            else {
                                cell.imgOfProfile.backgroundColor = color.grayColor
                            }
                        }
                    }else {
                        cell.imgOfProfile.backgroundColor = color.grayColor
                    }
                }
            }
             return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tblOfOtherServices{
            let dicData = self.arryOfOtherServics[section] as! [String:Any]
            let titleName = dicData["parentServiceName"] as! String
            return titleName
        }
        else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        if tableView == tblOfOtherServices{
            let headerView = UIView()
            headerView.backgroundColor = UIColor(red: 184.0/255.0, green: 223.0/255.0, blue: 248.0/255.0, alpha: 1.0)
           
            var strngFontSize = 16
            let type =  UserDefaults.standard.value(forKey: "Device") as? String
            if type! == "iPad" {
                strngFontSize = 29
            }else {
                strngFontSize = 16
            }
            
            let headerLabel = UILabel(frame: CGRect(x: 10, y: 8, width:
                tableView.bounds.size.width, height: tableView.bounds.size.height))
            headerLabel.font = UIFont(name: "Raleway-SemiBold", size: CGFloat(strngFontSize))
            headerLabel.textColor = UIColor.black
            headerLabel.text = self.tableView(self.tblOfOtherServices, titleForHeaderInSection: section)
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
            
            headerView.backgroundColor = color.backView1
            
           /* switch section{
            case 0:
                headerView.backgroundColor = color.backView1
            case 1:
                headerView.backgroundColor = color.backView2
            case 2:
                headerView.backgroundColor = color.backView3
            case 3:
                headerView.backgroundColor = color.backView1
            case 4:
                headerView.backgroundColor = color.backView2
            default :
                headerView.backgroundColor = color.backView3
            }*/
            return headerView
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblOfOtherServices{
            let type =  UserDefaults.standard.value(forKey: "Device") as? String
            if type! == "iPad" {
                return 60.0
            }else {
                return 40.0
            }
           
        }else {
            return 0.0
        }
    }
}

//MARK: - WS_ServiceProviderDetails
extension ServiceProviderDetails {
    func getServicProvidrDetails(){
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
                          "childServicedId": childServicedId,
                          "serviceProviderId" : serviceProviderId]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getServiceProviderDetails?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfServiceProivderList(strURL: strURL, dictionary: dictionary )
        }else {
            //self.view.makeToast(string.noInternetConnMsg)
            self.stopActivityIndicator()
            //refreshControl.endRefreshing()
            self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.noInternetConnMsg, lableNoInternate: string.noInternateMessage2)
            self.scrllView.addSubview(self.noDataView)
        }
    }
    
    func callWSOfServiceProivderList(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.arryOfOtherServics = JSONResponse["otherServicesList"] as! [Any]
                    self.arryOfCustomrReview = JSONResponse["customerReviewsList"] as! [Any]
                    
                    if JSONResponse["serviceProviderName"] != nil {
                        self.lblOfName.text = JSONResponse["serviceProviderName"] as? String
                    }
                    if JSONResponse["jobDone"] != nil {
                        self.lblOfjobCount.text = JSONResponse["jobDone"] as? String
                    }
                    if JSONResponse["rating"] != nil {
                        //let number = (JSONResponse["rating"] as? Float)
                        self.lblOfRatingCount.text = JSONResponse["rating"] as? String
                    }else {
                        self.lblOfRatingCount.text = "0"
                    }
                    if JSONResponse["reviewsCount"] != nil {
                        self.lblOfReviewCount.text = JSONResponse["reviewsCount"] as? String
                    }
                    if JSONResponse["favouriteFlg"] as? String == "0" {
                        self.imgOfFav.image = UIImage(named:"unfav")
                        self.flagFrFav = "1"
                        self.lblOfFav.text = "Unfavourite"
                    }else {
                        self.imgOfFav.image = UIImage(named:"fav")
                        self.flagFrFav = "0"
                        self.lblOfFav.text = "Favourite"
                    }
                    
                    if JSONResponse["image"] as? String != nil {
                        
                        let imgUrl = JSONResponse["image"] as? String
                        
                        let imgName = self.separateImageNameFromUrl(Url: imgUrl!)
                        self.imgOfProfile.image = UIImage(named:"Profilea.png")
                        
                        if (self.chache.object(forKey: imgName as AnyObject) != nil){
                            self.imgOfProfile.image = self.chache.object(forKey:imgName as AnyObject) as? UIImage
                        }else {
                            if Validation1.checkNotNullParameter(checkStr: imgUrl!) == false {
                                Alamofire.request(imgUrl!).responseImage{ response in
                                    if let image = response.result.value {
                                        self.imgOfProfile.image = image
                                        self.chache.setObject(image, forKey: imgName as AnyObject)
                                    }
                                    else {
                                        self.imgOfProfile.image = UIImage(named:"Profilea.png")
                                    }
                                }
                            }else{
                                self.imgOfProfile.image = UIImage(named:"Profilea.png")
                            }
                        }
                    }
                    
                    if self.arryOfCustomrReview.count > 0{
                        self.tblOfCutmerReview.isHidden = false
                        
                        let type =  UserDefaults.standard.value(forKey: "Device") as? String
                        if type! == "iPad" {
                            self.heightCuomerReviewTbl.constant = CGFloat(self.arryOfCustomrReview.count * 160)
                            self.lblOfCustomerReviewTitle.isHidden = false
                            self.lblOfCustomerReviewTitle.text = "Customer Review " + String(self.arryOfCustomrReview.count)
                            self.heightOfCustomrReview.constant = CGFloat(self.heightCuomerReviewTbl.constant + 60)
                        }else {
                            self.heightCuomerReviewTbl.constant = CGFloat(self.arryOfCustomrReview.count * 100)
                            self.lblOfCustomerReviewTitle.isHidden = false
                            self.lblOfCustomerReviewTitle.text = "Customer Review " + String(self.arryOfCustomrReview.count)
                            self.heightOfCustomrReview.constant = CGFloat(self.heightCuomerReviewTbl.constant + 32)
                        }
                        
                        if self.arryOfCustomrReview.count > 5{
                            //self.btnViewMoreReview.isHidden = false
                        }else {
                            //self.btnViewMoreReview.isHidden = true
                        }
                    }else {
                        self.tblOfCutmerReview.isHidden = true
                        self.heightCuomerReviewTbl.constant = 0
                        self.heightOfCustomrReview.constant = 0
                        self.lblOfCustomerReviewTitle.isHidden = true
                        self.btnViewMoreReview.isHidden = true
                        self.lblOfLine.isHidden = true
                    }
                    
                    if self.arryOfOtherServics.count > 0{
                        let type =  UserDefaults.standard.value(forKey: "Device") as? String
                        if type! == "iPad" {
                            self.heightOfOtherServiceTbl.constant = CGFloat(self.arryOfOtherServics.count * 76)
                            self.lblOfOtherServicesTitle.isHidden = false
                            self.heightOfOtherServiceView.constant = CGFloat(self.heightOfOtherServiceTbl.constant + 70)
                        }else {
                            self.heightOfOtherServiceTbl.constant = CGFloat(self.arryOfOtherServics.count * 56)
                            self.lblOfOtherServicesTitle.isHidden = false
                            self.heightOfOtherServiceView.constant = CGFloat(self.heightOfOtherServiceTbl.constant + 32)
                        }
                        
                    }else {
                        self.tblOfOtherServices.isHidden = true
                        self.heightOfOtherServiceTbl.constant = 0
                        self.heightOfOtherServiceView.constant = 0
                        self.lblOfOtherServicesTitle.isHidden = true
                    }
                    
                        self.tblOfCutmerReview.reloadData()
                        self.tblOfOtherServices.reloadData()
                }
            }
            else{
                self.stopActivityIndicator()
                print("error2: ")
                if JSONResponse["status"] as? String == "0"{
                    //When Parameter Missing
                    print("error2: ")
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
    
    //MARK: WS Fav/UnFav
    func callWSOfWSFavUnFav(){
        let dictionary = [
            "userId":String(userInfo.userID),
            "userPrivateKey": userInfo.privateKey,
            "related_flag": "1",
            "serviceId" : childServicedId,
            "serviceProviderId" : serviceProviderId,
            "favouriteFlag" : self.flagFrFav,
            ]
        
        print("dictionary:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "addremovefavsupplier?"
        print(strURL)
        strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
            self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.WSFavUnFav(strURL: strURL, dictionary: dictionary )
        }else{
            self.stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func WSFavUnFav(strURL: String, dictionary: Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.stopActivityIndicator()
            if JSONResponse["status"] as? String == "1"{
                self.view.makeToast((JSONResponse["message"] as? String)!)
                
                if (JSONResponse["message"] as? String)! == "This service provider added to your favourite list"{
                    self.imgOfFav.image = UIImage(named:"fav")
                    self.lblOfFav.text = "Favourite"
                    self.flagFrFav = "0"
                }else {
                    self.imgOfFav.image = UIImage(named:"unfav")
                    self.lblOfFav.text = "Unfavourite"
                    self.flagFrFav = "1"
                }
            }
            else{
                self.stopActivityIndicator()
                print("error2: ")
                if JSONResponse["status"] as? String == "0"{
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                }
            }
        }, failure: { (error) in
            print(error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
                self.stopActivityIndicator()
            }
        })
    }
}

