//
//  OrderCanclled.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 31/10/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import Alamofire

class OrderCanclled: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet var tblOfOrderCanclled: UITableView!
    var noDataView = UIView()
    var arryOfCanclledData : [Any]  = []
    var chache :NSCache <AnyObject, AnyObject>!
    var pageNumber = 1
    var resPgNumber = 0
    var remaining = 0
    var refreshControl: UIRefreshControl!
    var flgActivity = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chache = NSCache()
        
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblOfOrderCanclled.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Call WS
        pageNumber = 1
        getOrderCanclledList()
    }
    
    @objc func moreClick(_ sender : UIButton?){
        
    }
    
    @objc func refresh(_ sender:AnyObject){
        flgActivity = false
        pageNumber = 1
        remaining = 0
        self.getOrderCanclledList()
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
}

extension OrderCanclled : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arryOfCanclledData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell") as! HomeScreenCell
        cell.btnOfMore.tag = indexPath.row + 100
        cell.btnOfMore.addTarget(self, action: #selector(ActiveOrders.moreClick(_:)), for: .touchUpInside)
        
        let type =  UserDefaults.standard.value(forKey: "Device") as? String
        if type! == "iPad" {
            cell.lblOfBookingStatus.textAlignment = .right
            cell.lblOfBookingStatus.font = UIFont(name:"Raleway-Medium", size:22.0)
        }
        else {
            if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
                cell.lblOfBookingStatus.textAlignment = .left
                cell.lblOfBookingStatus.font = UIFont(name:"Raleway-Medium", size:10.0)
            }else {
                cell.lblOfBookingStatus.textAlignment = .right
                cell.lblOfBookingStatus.font = UIFont(name:"Raleway-Medium", size:12.0)
            }
        }
        
        let currentDic = self.arryOfCanclledData[indexPath.row] as! [String : Any]
        
        if currentDic["serviceProviderName"] as? String != nil{
            cell.lblOfUserName.text = currentDic["serviceProviderName"] as? String
        }else {
            cell.lblOfUserName.text = ""
        }
        if currentDic["serviceStatus"] as? String != nil{
            cell.lblOfBookingStatus.text = currentDic["serviceStatus"] as? String
        }else {
            cell.lblOfBookingStatus.text = ""
        }
        if currentDic["serviceName"] as? String != nil{
            cell.lblOfBookingInfo.text = currentDic["serviceName"] as? String
        }else {
            cell.lblOfBookingInfo.text = ""
        }
        if currentDic["serviceId"] as? String != nil{
            cell.lblOfOrderId.text = "Order Id : \((currentDic["serviceId"] as? String)!)"
                //currentDic["serviceId"] as? String
        }else {
            cell.lblOfOrderId.text = ""
        }
        if currentDic["orderDate"] as? String != nil{
            cell.lblOfOderrDate.text = "Order Date : \((currentDic["orderDate"] as? String)!)"
                //currentDic["orderDate"] as? String
        }else {
            cell.lblOfOderrDate.text = ""
        }
        if currentDic["orderTimeBlock"] as? String != nil{
            cell.lblOfOrderTime.text = "Order Time : \((currentDic["orderTimeBlock"] as? String)!)"
                //currentDic["orderTimeBlock"] as? String
        }else {
            cell.lblOfOrderTime.text = ""
        }
        
        if currentDic["serviceProviderImage"] as? String != nil{
            let imgUrl = currentDic["serviceProviderImage"] as? String
            
            let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
            cell.imgOfUser.image = UIImage(named:"Profilea.png")
            
            if(self.chache.object(forKey: imageName as AnyObject) != nil){
                cell.imgOfUser.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
            }else{
                if Validation1.checkNotNullParameter(checkStr: imgUrl!) == false {
                    Alamofire.request(imgUrl!).responseImage{ response in
                        if let image = response.result.value {
                            cell.imgOfUser.image = image
                            self.chache.setObject(image, forKey: imageName as AnyObject)
                        }
                        else {
                            cell.imgOfUser.image = UIImage(named:"Profilea.png")
                        }
                    }
                }else {
                    cell.imgOfUser.image = UIImage(named:"Profilea.png")
                }
            }
        }else {
            cell.imgOfUser.image = UIImage(named:"Profilea.png")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let currentDic = self.arryOfCanclledData[indexPath.row] as! [String : Any]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OderDetails") as! OderDetails
        vc.falgCallFrm = "OrderCanceled"
        vc.orderId = (currentDic["orderId"] as? String)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if(indexPath.row == self.arryOfCanclledData.count-1){
            if(self.pageNumber <= self.resPgNumber){
                if(remaining != 0){
                    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                    spinner.startAnimating()
                    tableView.tableFooterView = spinner
                    tableView.tableFooterView?.isHidden = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.flgActivity = false
                        self.getOrderCanclledList()
                    }
                }
                else{
                    tableView.tableFooterView?.removeFromSuperview()
                    let view = UIView()
                    view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(5))
                    tableView.tableFooterView = view
                    tableView.tableFooterView?.isHidden = true
                }
            }
            else{
                tableView.tableFooterView?.removeFromSuperview()
                let view = UIView()
                view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(5))
                tableView.tableFooterView = view
                tableView.tableFooterView?.isHidden = true
            }
        }
        else{
            tableView.tableFooterView?.removeFromSuperview()
            let view = UIView()
            view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(5))
            tableView.tableFooterView = view
            tableView.tableFooterView?.isHidden = true
        }
    }
}


//MARK: - WS_OrderCompleted
extension OrderCanclled {
    func getOrderCanclledList(){
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
                          "pageNumber" : String(pageNumber),
                          "Limit" : "10",
                          "orderType" : "2"
        ]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getBookingHistoryList?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfgetOrderCanclledList(strURL: strURL, dictionary: dictionary )
        }else {
            //self.view.makeToast(string.noInternetConnMsg)
            self.stopActivityIndicator()
            refreshControl.endRefreshing()
            self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.noInternetConnMsg, lableNoInternate: string.noInternateMessage2)
            self.tblOfOrderCanclled.addSubview(self.noDataView)
        }
    }
    
    func callWSOfgetOrderCanclledList(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                 DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    
                    if let remaing = JSONResponse["itemRemainings"] as? Int{
                        self.remaining = remaing;
                    }
                    if ((JSONResponse["NextpageNumber"] as? Int) != nil){
                        self.resPgNumber = JSONResponse["NextpageNumber"] as! Int
                    }
                    
                    if let data = JSONResponse["bookingHistoryList"] as? [Any] {
                        
                        print("pageNumber: ",self.pageNumber )
                        if(self.pageNumber == 1){
                            self.pageNumber =  self.pageNumber + 1;
                            self.arryOfCanclledData = data
                            
                            if self.arryOfCanclledData.count != 0{
                                DispatchQueue.main.async{
                                    self.tblOfOrderCanclled.reloadData()
                                }
                            }
                        }
                        else{
                            self.pageNumber =  self.pageNumber + 1;
                            self.arryOfCanclledData =  self.arryOfCanclledData + data
                            if self.arryOfCanclledData.count != 0{
                                DispatchQueue.main.async{
                                    self.tblOfOrderCanclled.reloadData()
                                }
                            }
                        }
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
                        self.refreshControl.endRefreshing()
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: (JSONResponse["message"] as? String)!)
                        self.tblOfOrderCanclled.addSubview(self.noDataView)
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
