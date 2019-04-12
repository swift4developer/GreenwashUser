//
//  CustomerReviewList.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 07/11/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import Alamofire


class CustomerReviewList: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var tblOfCutsermRviewList: UITableView!
    var arryOfAllCustomrReview : [Any] = []
    var chache : NSCache<AnyObject,AnyObject>!
    var serviceProviderId = ""
    var noDataView = UIView()
    var pageNumber = 1
    var resPgNumber = 0
    var remaining = 0
    var refreshControl: UIRefreshControl!
    var flgActivity = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNaviBackButton()
        navigationDesign()
        self.chache = NSCache()
        
        tblOfCutsermRviewList.tableFooterView = UIView()
        self.title = "Customer Reviews"
        
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblOfCutsermRviewList.addSubview(refreshControl)
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        //Call_Ws
        pageNumber = 1
        getAllReviewList()
    }
    
    @objc func refresh(_ sender:AnyObject){
        flgActivity = false
        pageNumber = 1
        remaining = 0
        self.getAllReviewList()
    }
    
}

extension CustomerReviewList : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arryOfAllCustomrReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let  cell = tableView.dequeueReusableCell(withIdentifier: "CutomerReviewCell", for: indexPath) as! HomeScreenCell
        
        let currntDic = arryOfAllCustomrReview[indexPath.row] as! [String:Any]
        
        if currntDic["reviewerName"] as? String != nil{
            cell.lblOfCutomerName.text = currntDic["reviewerName"] as? String
        }
        if currntDic["reviewDate"] as? String != nil{
            cell.lblOfReviewDate.text = currntDic["reviewerName"] as? String
        }
        if currntDic["review"] as? String != nil{
            cell.lblOfReviewDetails.text = currntDic["review"] as? String
        }
        if currntDic["image"] as? String != nil{
            
            let imgUrl = currntDic["image"] as? String
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if(indexPath.row == self.arryOfAllCustomrReview.count-1){
            if(self.pageNumber <= self.resPgNumber){
                if(remaining != 0){
                    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                    spinner.startAnimating()
                    tableView.tableFooterView = spinner
                    tableView.tableFooterView?.isHidden = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.flgActivity = false
                        self.getAllReviewList()
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

//MARK: - WS_All_Review_List
extension CustomerReviewList {

    func getAllReviewList(){
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
                          "serviceProviderId": self.serviceProviderId,
                          "pageNumber" : "1",
                          "Limit" : "10",
        ]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getAllReviews?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfgetAllReviewList(strURL: strURL, dictionary: dictionary )
        }else {
            //self.view.makeToast(string.noInternetConnMsg)
            self.stopActivityIndicator()
            refreshControl.endRefreshing()
            self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.noInternetConnMsg, lableNoInternate: string.noInternateMessage2)
            self.tblOfCutsermRviewList.addSubview(self.noDataView)
        }
    }
    
    func callWSOfgetAllReviewList(strURL: String, dictionary:Dictionary<String,String>){
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
                    
                    if let data = JSONResponse["customerReviewsList"] as? [Any] {
                        if(self.pageNumber == 1){
                            self.pageNumber =  self.pageNumber + 1;
                            self.arryOfAllCustomrReview = data
                            
                            if self.arryOfAllCustomrReview.count != 0{
                                DispatchQueue.main.async{
                                    self.tblOfCutsermRviewList.reloadData()
                                }
                            }
                        }
                        else{
                            self.pageNumber =  self.pageNumber + 1;
                            self.arryOfAllCustomrReview =  self.arryOfAllCustomrReview + data
                            if self.arryOfAllCustomrReview.count != 0{
                                DispatchQueue.main.async{
                                    self.tblOfCutsermRviewList.reloadData()
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
                    if (JSONResponse["message"] as? String) == "logout"{
                        self.view.makeToast((JSONResponse["message"] as? String)!)
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is login {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }else {
                        //self.refreshControl.endRefreshing()
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: (JSONResponse["message"] as? String)!)
                        self.tblOfCutsermRviewList.addSubview(self.noDataView)
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

