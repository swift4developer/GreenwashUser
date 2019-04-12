//
//  NotificationController.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 26/10/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit

class NotificationController: UIViewController,NVActivityIndicatorViewable{

    var arryData = Array<Any>()
    @IBOutlet var tblOfNotification: UITableView!
    var noDataView = UIView()
    var btnClearAll = UIButton()
    var pageNumber = 1
    var resPgNumber = 0
    var remaining = 0
    var refreshControl: UIRefreshControl!
    var flgActivity = true
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblOfNotification.addSubview(refreshControl)

        tblOfNotification.tableFooterView = UIView()
        
        setNaviBackButton()
        navigationDesign()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /*let type =  UserDefaults.standard.value(forKey: "Device") as? String
        var strFont = 16
        if type! == "iPad" {
            btnClearAll = UIButton(frame: CGRect(x: 0, y:0, width:150,height: 40))
            strFont = 26
        }else {
            btnClearAll = UIButton(frame: CGRect(x: 0, y:0, width:80,height: 30))
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name:"Clear All", size: CGFloat(strFont))!], for: .normal)
            strFont = 16
        }*/
        
        btnClearAll.setTitle("Clear All", for: .normal)
        btnClearAll.addTarget(self,action: #selector(btnClearAllClick), for: .touchUpInside)
        let backBarButtonitem = UIBarButtonItem(customView: btnClearAll)
        let arrRightBarButtonItems : Array = [backBarButtonitem]
        let widthConstraint = btnClearAll.widthAnchor.constraint(equalToConstant: 80)
        let heightConstraint = btnClearAll.heightAnchor.constraint(equalToConstant: 30)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        self.navigationItem.rightBarButtonItems = arrRightBarButtonItems
        
        self.title = "Notifications"
        
        //WS Call
        pageNumber = 1
        self.getNotificationList()
    }
    @objc func refresh(_ sender:AnyObject){
        flgActivity = false
        pageNumber = 1
        remaining = 0
        self.getNotificationList()
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @objc func btnClearAllClick() {
        
        let alertController = UIAlertController(title: "", message: NSLocalizedString("Are you sure you want to clear all notifications?", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: UIAlertActionStyle.destructive, handler:{
            action in
            
            //calling ws
            self.callWSOfDeleteAllNotification()
            
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: UIAlertActionStyle.cancel, handler:nil))
        self.present(alertController,animated: true,completion: nil)
        
    }
    
    
    @objc func deletClick(_ sender: UIButton?){
        let center = sender?.center
        let rootViewPoint = sender?.superview?.convert(center!, to: self.tblOfNotification)
        let indexPath = self.tblOfNotification.indexPathForRow(at: rootViewPoint!)
        
        let alertController = UIAlertController(title: "", message: NSLocalizedString("Are you sure you want to Delete this notification?", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: UIAlertActionStyle.destructive, handler:{
            action in
                self.callWSOfDeleteSignleNotification(indexID: (indexPath?.row)!)
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: UIAlertActionStyle.cancel, handler:nil))
        self.present(alertController,animated: true,completion: nil)
    }
}

//MARK: - TableView Delegate
extension NotificationController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell") as! HomeScreenCell
        cell.btnDelete.tag = indexPath.row + 100
        cell.btnDelete.addTarget(self, action: #selector(NotificationController.deletClick(_:)), for: .touchUpInside)
        
        if self.arryData.count > 0 {
            let currentDic = self.arryData[indexPath.row] as! [String:Any]
            cell.lblOfStatus.text = currentDic["content"] as? String
            cell.lblOfStatusDescrptn.text = currentDic["content"] as? String
            cell.lblOfDateTime.text = currentDic["created_on"] as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if(indexPath.row == self.arryData.count-1){
            if(self.pageNumber <= self.resPgNumber){
                if(remaining != 0){
                    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                    spinner.startAnimating()
                    tableView.tableFooterView = spinner
                    tableView.tableFooterView?.isHidden = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.flgActivity = false
                        self.getNotificationList()                    }
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

//MARK: - WS
extension NotificationController {
    
    //MARK: - WS_Notification_List
    func getNotificationList(){
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
                          "pageNumber" : String(pageNumber),
                          "Limit" : "10"]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getNotificationsList?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfGetNotifctnList(strURL: strURL, dictionary: dictionary )
        }else {
            //self.view.makeToast(string.noInternetConnMsg)
            self.btnClearAll.isHidden = true
            self.tblOfNotification.isHidden = false
            self.stopActivityIndicator()
            refreshControl.endRefreshing()
            self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.noInternetConnMsg, lableNoInternate: string.noInternateMessage2)
            self.tblOfNotification.addSubview(self.noDataView)
        }
    }
    
    func callWSOfGetNotifctnList(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.refreshControl.endRefreshing()
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                self.stopActivityIndicator()
                DispatchQueue.main.async {
                    
                    if let remaing = JSONResponse["itemRemainings"] as? Int{
                        self.remaining = remaing;
                    }
                    if ((JSONResponse["NextpageNumber"] as? Int) != nil){
                        self.resPgNumber = JSONResponse["NextpageNumber"] as! Int
                    }
                    if let data = JSONResponse["NotificationList"] as? [Any] {
                        if(self.pageNumber == 1){
                            self.pageNumber =  self.pageNumber + 1;
                            self.arryData = data
                            
                            if self.arryData.count != 0{
                                DispatchQueue.main.async{
                                    self.tblOfNotification.reloadData()
                                }
                            }
                        }
                        else{
                            self.pageNumber =  self.pageNumber + 1;
                            self.arryData =  self.arryData + data
                            if self.arryData.count != 0{
                                DispatchQueue.main.async{
                                    self.tblOfNotification.reloadData()
                                }
                            }
                        }
                    }
                }
            }else{
                self.stopActivityIndicator()
                print("error2: ")
                if JSONResponse["status"] as? String == "0"{
                    //When Parameter Missing
                    print("error2: ")

                    if (JSONResponse["message"] as? String) == "logout"{
                        self.view.makeToast((JSONResponse["message"] as? String)!)
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is login {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }else {
                        self.btnClearAll.isHidden = true
                        self.refreshControl.endRefreshing()
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: (JSONResponse["message"] as? String)!)
                        self.tblOfNotification.addSubview(self.noDataView)
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
    
    //MARK: - WS_Notification_List
    func callWSOfDeleteSignleNotification(indexID: Int){
        
        let currentDic = arryData[indexID] as! [String:Any]
        let notificationId = currentDic["active_notifications_id"] as! Int
        let dictionary = [
            "userId": String(userInfo.userID),
            "userPrivateKey": userInfo.privateKey,
            "notificationId": String(notificationId),
            "related_flag" : "1"
        ]
        
        print("I/P: ",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "deleteNotification?"
        print(strURL)
        strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
            self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.removeSignlNotifictnWS(strURL: strURL, dictionary: dictionary,index_id:indexID)
        }else{
            self.stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func removeSignlNotifictnWS(strURL: String, dictionary: Dictionary<String,String>, index_id:Int){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.stopActivityIndicator()
            if JSONResponse["status"] as? String == "1"{
                self.view.makeToast((JSONResponse["message"] as? String)!)
                self.arryData.remove(at:(index_id))
                self.tblOfNotification.reloadData()

                if self.arryData.count == 0{
                    self.btnClearAll.isHidden = false
                    self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate:string.noDataFoundMsgForDetal)
                    self.tblOfNotification.addSubview(self.noDataView)
                }
            }
            else{
                self.stopActivityIndicator()
                print("error2: ")
                if JSONResponse["status"] as? String == "0"{
                    //When Parameter Missing
                    if (JSONResponse["message"] as? String) == "logout"{
                        self.view.makeToast((JSONResponse["message"] as? String)!)
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is login {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }else {
                        self.btnClearAll.isHidden = true
                        self.refreshControl.endRefreshing()
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
    
    //MARK: - WS_Notification_List
    func callWSOfDeleteAllNotification(){
        let dictionary = [
            "userId":String(userInfo.userID),
            "userPrivateKey": userInfo.privateKey,
            "related_flag": "1",
            ]
        
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "deleteAllNotifications?"
        print(strURL)
        strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.removAllNotifictnWS(strURL: strURL, dictionary: dictionary)
        }else{
            self.stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func removAllNotifictnWS(strURL: String, dictionary: Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.stopActivityIndicator()
            if JSONResponse["status"] as? String == "1"{
                self.view.makeToast((JSONResponse["message"] as? String)!)
                self.tblOfNotification.reloadData()
                self.btnClearAll.isHidden = false
                self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate:string.noDataFoundMsgForDetal)
                self.tblOfNotification.addSubview(self.noDataView)
            }
            else{
                self.stopActivityIndicator()
                print("error2: ")
                if JSONResponse["status"] as? String == "0"{
                    print("error2: ")
                    
                    if (JSONResponse["message"] as? String) == "logout"{
                        self.view.makeToast((JSONResponse["message"] as? String)!)
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is login {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }else {
                        self.btnClearAll.isHidden = true
                        self.refreshControl.endRefreshing()
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: (JSONResponse["message"] as? String)!)
                        self.tblOfNotification.addSubview(self.noDataView)
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
