//
//  HomeViewController.swift
//  MoneyLander
//
//  Created by PUNDSK006 on 8/1/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController,NVActivityIndicatorViewable {

    var appDelegate : AppDelegate!
    
    @IBOutlet weak var imgOfBackDrawer: UIImageView!
    @IBOutlet var noPostLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var viewNavBar: UIView!
    
    @IBOutlet var menuImgView: UIImageView!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var slideView: UIView!
    var cellImgArr : [String] = []
    var cellTitleArr : [String] = []
    var lblelForImg = UILabel()
    var popView = UIView()
    
    @IBOutlet var bgViewOfAlert: UIView!
    @IBOutlet var viewOfAlert: UIView!
    @IBOutlet var lblOfLogutTitle: UILabel!
    @IBOutlet var btnNo: UIButton!
    @IBOutlet var btnYes: UIButton!
    
    //Notification
    @IBOutlet var lblOFmyLocatn: UILabel!
    @IBOutlet var lblOfLocatnName: UILabel!
    @IBOutlet var imgOfDropDown: UIImageView!
    @IBOutlet var btnOflocation: UIButton!
    @IBOutlet var btnOfNotification: UIButton!
    
    @IBOutlet var tblOfServicesList: UITableView!
    var noDataView = UIView()
    var arryOfData : [Any] = []
    var chache:NSCache<AnyObject, AnyObject>!
    //let myNotification = Notification.Name(rawValue:"MyNotification")
    // MARK:- Custom Method
    override func viewDidLoad(){
        super.viewDidLoad()

        self.chache = NSCache()
        //NotificationCenter.default.addObserver(self, selector: #selector(self.catchNotification(_:)), name: NSNotification.Name(rawValue: "MyNotification"), object: nil)
        
        // Hide SlideMenu
        self.slideView.isHidden = true
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.slideView.backgroundColor = UIColor.clear
        
        let type =  UserDefaults.standard.value(forKey: "Device") as? String
        if type! == "iPad" {
            imgOfBackDrawer.image = UIImage(named:"drawer-453x1024")
        }else {
            imgOfBackDrawer.image = UIImage(named:"drawer-453x960")
        }
        
        //
        cellImgArr = ["Active","24","favGreen","myProfile","howItWork","contactUs","logout"];
        cellTitleArr = ["Active Orders","Orders History","Favourite Services","My Profile","How it works","Contact Us","Logout"];
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        //tblView.backgroundColor = UIColor.white
        tblView.tableFooterView = view
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        menuImgView.isUserInteractionEnabled = true
        menuImgView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    override func viewWillAppear(_ animated: Bool){
        //tblView.reloadData()
        
        self.navigationController?.navigationBar.isHidden = true
        self.titleLbl.textColor = UIColor.white
        self.titleLbl.text = "Green Wash"
        
        let type =  UserDefaults.standard.value(forKey: "Device") as? String
        if type! == "iPad" {
            self.titleLbl.font = UIFont(name: "Raleway-SemiBold",size:28.0)
            lblOFmyLocatn.font = UIFont(name: "Raleway",size:22.0)
            lblOfLocatnName.font = UIFont(name: "Raleway",size:22.0)
        }else {
            if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
                self.titleLbl.font = UIFont(name: "Raleway-SemiBold",size:14.0)
                lblOFmyLocatn.font = UIFont(name: "Raleway",size:11.0)
                lblOfLocatnName.font = UIFont(name: "Raleway",size:11.0)
            }else {
                self.titleLbl.font = UIFont(name: "Raleway-SemiBold",size:18.0)
                lblOFmyLocatn.font = UIFont(name: "Raleway",size:13.0)
                lblOfLocatnName.font = UIFont(name: "Raleway",size:13.0)
            }
        }
        
        //Call WS
        getServiceList()
        
        bgViewOfAlert.isHidden = true
        lblOfLogutTitle.text =  NSLocalizedString("Are you sure you want to logout?", comment: "")
    }
    
    override func viewWillDisappear(_ animated: Bool){
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.isHidden = false
    }
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        // let tappedImage = tapGestureRecognizer.view as! UIImageView
        menuOpen()
    }
    func notificationViewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        menuHide()

    }
    @objc func profileViewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        menuHide()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile") as! MyProfile
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnNoClick(_ sender: Any) {
        bgViewOfAlert.isHidden = true
    }
    @IBAction func btnYesClick(_ sender: Any) {
        bgViewOfAlert.isHidden = true
        if Validation1.isConnectedToNetwork()  {
            //startActivityIndicator()
            //_ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            //callLogOutWS()//user.user_id
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "login") as! login
            //self.navigationController?.pushViewController(vc, animated: true)
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is login {
                    //isVCFound = true
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }
        else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    @IBAction func btnMenuPress(_ sender: Any){
        menuOpen()
    }
    
    
    
    func menuOpen(){
        
        // Set Profile Pic with Circle
        self.view.endEditing(true)
        
        //profileImg.image = UIImage(named:"photo.jpg")
        
        //profileImg.maskCircle(anyImage: UIImage(named:"photo.jpg")!)
        
        //        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleprofileTapGestureTapGesture(_ :)))
        //
        //        profileTapGesture.numberOfTapsRequired = 1
        //        profileImg.addGestureRecognizer(profileTapGesture)
        //        profileImg.isUserInteractionEnabled = true
        
        self.view.bringSubview(toFront: slideView)
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.slideView.layer.add(transition, forKey: kCATransition)
        
        self.slideView.tag = 11
        self.slideView.isHidden = false
    }
    
    func menuHide(){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromRight, animations:{
            self.slideView.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            
            // //Once the label is completely invisible, set the text and fade it back in
            //self.birdTypeLabel.text = "Bird Type: Swift"
            
            // Fade in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
                self.slideView.alpha = 1.0
                
                self.slideView.isHidden = true
            }, completion: nil)
        })
    }
    
    @IBAction func bb(_ sender: Any){
        menuHide()
    }

    func removeView(){
        self.popView.removeFromSuperview()
        //self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btnNotificationClick(_ sender: Any) {
        //NotificationController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController") as! NotificationController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnMyLocatnClick(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocation") as! SelectLocation
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - WS_ServiceList
extension HomeViewController {
    
    func getServiceList(){
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1"]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "serviceslist?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfgetServiceList(strURL: strURL, dictionary: dictionary )
        }else {
            //self.view.makeToast(string.noInternetConnMsg)
            self.tblOfServicesList.isHidden = false
            self.stopActivityIndicator()
            //refreshControl.endRefreshing()
            self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.noInternetConnMsg, lableNoInternate: string.noInternateMessage2)
            self.tblOfServicesList.addSubview(self.noDataView)
        }
    }
    
    func callWSOfgetServiceList(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    let data = JSONResponse["servicesList"] as! [Any]
                    self.arryOfData = data
                    print("arryOfData: ", self.arryOfData)
                    print("arry Of count: ", self.arryOfData.count)

                    if self.arryOfData.count > 0{
                        self.tblOfServicesList.reloadData()
                        self.tblView.reloadData()
                    }
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
                        self.noPostLbl.isHidden = true
                        self.noPostLbl.text = JSONResponse["message"] as? String
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


// MARK: - TableView Delegate and DataSource
extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tblView{
            if (section == 0){
                return cellImgArr.count;
            }
            else {
                return 0
            }
        }else {
            return self.arryOfData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == tblView{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftMenuCell") as! LeftMenuCell
            cell.selectionStyle = .none
            
            cell.imgIcon.image = UIImage(named:cellImgArr[indexPath.row])
            cell.titleLbl.text = cellTitleArr[indexPath.row];
            
            /*if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
             cell.imgBottomConst.constant = 5
             }*/
            
            return cell
        }
        else {
            noPostLbl.isHidden = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell") as! HomeScreenCell
                        
            if self.arryOfData.count > 0{
                let dicOfData = arryOfData[indexPath.row] as! [String:Any]
                if dicOfData["parentServiceName"] as? String != nil {
                    cell.lblOfServiceName.text = dicOfData["parentServiceName"] as? String
                }
                if dicOfData["parentServiceImage"] as? String != nil {
                    
                    let imgUrl = dicOfData["parentServiceImage"] as? String
                    
                    let imgName = self.separateImageNameFromUrl(Url: imgUrl!)
                    cell.imgOfService.backgroundColor = color.grayColor
                    
                    if (self.chache.object(forKey: imgName as AnyObject) != nil){
                        cell.imgOfService.image = self.chache.object(forKey:imgName as AnyObject) as? UIImage
                    }else {
                        if Validation1.checkNotNullParameter(checkStr: imgUrl!) == false {
                            Alamofire.request(imgUrl!).responseImage{ response in
                                if let image = response.result.value {
                                    cell.imgOfService.image = image
                                    self.chache.setObject(image, forKey: imgName as AnyObject)
                                }
                                else {
                                    cell.imgOfService.backgroundColor = color.grayColor
                                }
                            }
                        }else{
                            cell.imgOfService.backgroundColor = color.grayColor
                        }
                    }
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == tblView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header1") as! LeftMenuHeader1Cell
            if (section == 0){
                cell.selectionStyle = .none
                
                cell.nameLbl.text = UserDefaults.standard.value(forKey: "userName") as? String
                let url = UserDefaults.standard.value(forKey: "userImage")
                if (url != nil){
                    let imgUrl = url as? String
                    
                    let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                    cell.profImg.image = UIImage(named:"Profilea.png")
                    
                    if(self.chache.object(forKey: imageName as AnyObject) != nil){
                        cell.profImg.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                    }else{
                        if Validation1.checkNotNullParameter(checkStr: imgUrl!) == false {
                            Alamofire.request(imgUrl!).responseImage{ response in
                                if let image = response.result.value {
                                    cell.profImg.image = image
                                    self.chache.setObject(image, forKey: imageName as AnyObject)
                                }
                                else {
                                    cell.profImg.image = UIImage(named:"Profilea.png")
                                }
                            }
                        }else {
                            cell.profImg.image = UIImage(named:"Profilea.png")
                        }
                    }
                }else {
                    cell.profImg.image = UIImage(named:"Profilea.png")
                }
                
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped(tapGestureRecognizer:)))
                cell.contentView.isUserInteractionEnabled = true
                cell.contentView.addGestureRecognizer(tapGestureRecognizer)
                
            }
            return cell
        }
        else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuHide()
        
        if tableView == tblView{
            
            switch indexPath.row{
            case 0:
                //ActiveOrders
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActiveOrders") as! ActiveOrders
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 1:
                //OrderHistroy
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderHistroy") as! OrderHistroy
                self.navigationController?.pushViewController(vc,animated: true)
                
            case 2:
                //favouriteServices
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "favouriteServices") as! favouriteServices
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 3:
                //MyProfile
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile") as! MyProfile
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            case 4:
                //HowItWork
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HowItWork") as! HowItWork
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 5:
                //ConatctUs
                
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
//                self.navigationController?.pushViewController(vc,animated: true)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConatctUs") as! ConatctUs
                self.navigationController?.pushViewController(vc,animated: true)
                
                /*let StrcontactNo = "14168008081"
                 let myInt:UInt64 = UInt64(StrcontactNo)!
                 if let url = URL(string: "tel://\(myInt)"), UIApplication.shared.canOpenURL(url) {
                 if #available(iOS 10, *) {
                 UIApplication.shared.open(url)
                 } else {
                 UIApplication.shared.openURL(url)
                 }
                 }*/
            case 6:
                
                //for google sign outanimated
                //GIDSignIn.sharedInstance().signOut()
                
                bgViewOfAlert.isHidden = false
                viewOfAlert.layer.cornerRadius = 5.0
                self.view.bringSubview(toFront: bgViewOfAlert)
                self.navigationController?.navigationBar.isHidden = true
            default:
                menuHide()
            }
        }
        else {
            let dicOfData = arryOfData[indexPath.row] as! [String:Any]
            if let data = dicOfData["Child"] as? [Any] {
                if data.count > 0{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeChildServiceList") as! HomeChildServiceList
                    vc.arryOfData = data
                    vc.serviceTitle = (dicOfData["parentServiceName"] as? String)!
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.view.makeToast("This service is not available at this moment")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if tableView == tblView{
            if (section == 0){
                let type =  UserDefaults.standard.value(forKey: "Device") as? String
                if type! == "iPad" {
                    return 218
                }else {
                    return 135
                }
            }
            else{
                return 0
            }
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if tableView == tblView{
            let type =  UserDefaults.standard.value(forKey: "Device") as? String
            if type! == "iPad" {
                return 100
            }else {
                return 57
            }
        }
        else {
            let type =  UserDefaults.standard.value(forKey: "Device") as? String
            if type! == "iPad" {
               return 400
            }else {
                return 215
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
