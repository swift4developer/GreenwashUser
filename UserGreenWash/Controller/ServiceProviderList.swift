//
//  ServiceProviderList.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 03/11/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import Alamofire

class ServiceProviderList: UIViewController,NVActivityIndicatorViewable {

    var btnFilter = UIButton()
    @IBOutlet weak var tblOfSevices: UITableView!
    let dropDown = DropDown()
    var arryOfData : [Any]  = []
    var childServicedId = ""
    var filterType = 0
    var serviceTitle = ""
    var chache : NSCache<AnyObject,AnyObject>!
    var noDataView = UIView()
    var favFlag = ""
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNaviBackButton()
        navigationDesign()
        self.title = serviceTitle
        self.chache = NSCache()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        btnFilter = UIButton.init(frame: CGRect(x: 0, y:0, width:23,height: 23))
        btnFilter.setImage(UIImage(named:"filter"), for: .normal)
        btnFilter.addTarget(self, action: #selector(btnFilterClick), for: .touchUpInside)
        let editBarButton = UIBarButtonItem(customView: btnFilter)
        let arryOFRightBarButton: Array = [editBarButton]
        let widthConstraint = btnFilter.widthAnchor.constraint(equalToConstant: 23)
        let heightConstraint = btnFilter.heightAnchor.constraint(equalToConstant: 23)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        self.navigationItem.rightBarButtonItems = arryOFRightBarButton
        
        
        //call WS
        getServiceProivderList()
        
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @objc func btnFilterClick(){
        let arryOfSize = ["Price: low to high","Price: high to low", "Highest ratings","Most reviews"]
        dropDown.dataSource = arryOfSize
        dropDown.selectionAction = { [unowned self] (index, item) in
            print("Selected item: ",item)
            self.filterType = index
            self.getServiceProivderList()
        }
        dropDown.anchorView = btnFilter
        dropDown.bottomOffset = CGPoint(x: 0, y:30)
        dropDown.backgroundColor = UIColor.black
        dropDown.textColor = UIColor.white
        
        if dropDown.isHidden    {
            dropDown.show()
        } else        {
            dropDown.hide()
        }
    }
    
    @objc func favClick(_ sender: UIButton?){
        let center = sender?.center
        let rootViewPoint = sender?.superview?.convert(center!, to: self.tblOfSevices)
        let indexPath = self.tblOfSevices.indexPathForRow(at: rootViewPoint!)
        
        callWSOfWSFavUnFav(indexID:(indexPath?.row)!)
    }
}
extension ServiceProviderList : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arryOfData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell", for: indexPath) as! HomeScreenCell
        
        if self.arryOfData.count > 0{
            let dicOfData = arryOfData[indexPath.row] as! [String:Any]
            if dicOfData["serviceProviderName"] as? String != nil {
                cell.lblOfServcProvidrNam.text = dicOfData["serviceProviderName"] as? String
            }else {
                cell.lblOfServcProvidrNam.text = ""
            }
            if dicOfData["rating"] as? String != nil {
                cell.lblOfRatingCount.text = dicOfData["rating"] as? String
            }else {
                cell.lblOfRatingCount.text = ""
            }
            if dicOfData["reviewsCount"] as? String != nil {
                cell.lblOfReviewCount.text = dicOfData["reviewsCount"] as? String
            }else {
                cell.lblOfReviewCount.text = ""
            }
            
            if dicOfData["jobDone"] as? String != nil {
                cell.lblOfJobCOunt.text = dicOfData["jobDone"] as? String
            }else {
                cell.lblOfJobCOunt.text = ""
            }
            
            if dicOfData["serviceCharge"] as? String != nil {
                cell.lblOfPrice.text = dicOfData["serviceCharge"] as? String
            }else {
                cell.lblOfPrice.text = ""
            }
            
            if dicOfData["favouriteFlag"] as? String == "0" {
                cell.imgOfFav.image = UIImage(named:"unfav")
            }else {
                cell.imgOfFav.image = UIImage(named:"fav")
            }
            cell.btnOfFav.tag = indexPath.row + 100
            cell.btnOfFav.addTarget(self, action: #selector(ServiceProviderList.favClick(_:)), for: .touchUpInside)
            
            if dicOfData["image"] as? String != nil {
                
                let imgUrl = dicOfData["image"] as? String
                
                let imgName = self.separateImageNameFromUrl(Url: imgUrl!)
                cell.imgOfProvider.backgroundColor = color.grayColor
                
                if (self.chache.object(forKey: imgName as AnyObject) != nil){
                    cell.imgOfProvider.image = self.chache.object(forKey:imgName as AnyObject) as? UIImage
                }else {
                    if Validation1.checkNotNullParameter(checkStr: imgUrl!) == false {
                        Alamofire.request(imgUrl!).responseImage{ response in
                            if let image = response.result.value {
                                cell.imgOfProvider.image = image
                                self.chache.setObject(image, forKey: imgName as AnyObject)
                            }
                            else {
                                cell.imgOfProvider.backgroundColor = color.grayColor
                            }
                        }
                    }else{
                        cell.imgOfProvider.backgroundColor = color.grayColor
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dicData = arryOfData[indexPath.row] as! [String:Any]
        
        self.appDelegate.postBookingReqDic["serviceProviderId"] = (dicData["serviceProviderId"] as? String)!
        self.appDelegate.postBookingReqDic["serviceCharge"] = (dicData["serviceCharge"] as? String)!
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceProviderDetails") as! ServiceProviderDetails
        vc.serviceProviderId = (dicData["serviceProviderId"] as? String)!
        vc.childServicedId = childServicedId
        vc.servicveName = self.serviceTitle
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - WS_Service_Proivder_List
extension ServiceProviderList {
    
    func getServiceProivderList(){
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
                          "childServicedId": childServicedId,
                          "filterType" : String(self.filterType)
                          ]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getServiceProvidersList?"
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
            self.tblOfSevices.addSubview(self.noDataView)
        }
    }
    
    func callWSOfServiceProivderList(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    let data = JSONResponse["serviceProvidersList"] as! [Any]
                    self.arryOfData = data
                    
                    if self.arryOfData.count > 0{
                        self.tblOfSevices.reloadData()
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

    func callWSOfWSFavUnFav(indexID:Int){
        let currentDic = arryOfData[indexID] as! [String:Any]
        let servicePrvdrId = currentDic["serviceProviderId"] as! String
        if currentDic["favouriteFlag"] as? String == "0" {
            favFlag = "1"
        }else {
            favFlag = "0"
        }
        
        let dictionary = [
            "userId":String(userInfo.userID),
            "userPrivateKey": userInfo.privateKey,
            "related_flag": "1",
            "serviceId" : childServicedId,
            "serviceProviderId" : servicePrvdrId,
            "favouriteFlag" : favFlag,
            ]
        
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "addremovefavsupplier?"
        print(strURL)
        strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
                self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.WSFavUnFav(strURL: strURL, dictionary: dictionary, indexID: indexID )
        }else{
            self.stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    //MARK: WS Fav/UnFav
    func WSFavUnFav(strURL: String, dictionary: Dictionary<String,String> , indexID : Int){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.stopActivityIndicator()
            if JSONResponse["status"] as? String == "1"{
                self.view.makeToast((JSONResponse["message"] as? String)!)
                //var currentDic = self.arryOfData[indexID] as! [String:Any]
                self.getServiceProivderList()
                //self.tblOfSevices.reloadData()
            }
            else{
                self.stopActivityIndicator()
                print("error2: ")
                if JSONResponse["status"] as? String == "0"{
                     //self.view.makeToast((JSONResponse["message"] as? String)!)
                    if (JSONResponse["message"] as? String) == "logout"{
                        self.view.makeToast((JSONResponse["message"] as? String)!)
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is login {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }else {
                        self.view.makeToast((JSONResponse["message"] as? String)!)
                    }
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
