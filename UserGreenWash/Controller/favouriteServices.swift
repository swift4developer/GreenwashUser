//
//  favouriteServices.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 01/11/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import Alamofire

class favouriteServices: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var tblOfService: UITableView!
    var storedOffsets = [Int: CGFloat]()

    var arryFavrteList = Array<Any>()
    var noDataView = UIView()
    var pageNumber = 1
    var refreshControl: UIRefreshControl!
    var flgActivity = true
    var arryOfProivder : [Any] = []
    var chache : NSCache <AnyObject, AnyObject>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chache = NSCache()
        setNaviBackButton()
        navigationDesign()
        self.title = "Favorite Services"
        
        tblOfService.tableFooterView = UIView()
        
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblOfService.addSubview(refreshControl)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //call WS
        getFavrteList()
    }
    
    @objc func refresh(_ sender:AnyObject){
        self.getFavrteList()
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @objc func btnMoreclick(_ sender: UIButton) {
        let center = sender.center
        let rootViewPoint = sender.superview?.convert(center, to: self.tblOfService)
        let indexPath = self.tblOfService.indexPathForRow(at: rootViewPoint!)

        let currentDic = self.arryFavrteList[(indexPath?.row)!] as! [String:Any]
        let serviceList = currentDic["serviceList"] as! [Any]
        let providerList = serviceList[0] as! [String : Any]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteServiceProviderList") as! FavouriteServiceProviderList
        vc.ServicedId = providerList["serviceId"] as! String
        self.navigationController?.pushViewController(vc , animated: true)
    }
}
extension favouriteServices : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arryFavrteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell") as! HomeScreenCell
        cell.btnMore.tag = indexPath.row
        cell.btnMore.addTarget(self, action: #selector(favouriteServices.btnMoreclick), for: .touchUpInside)
        
        let currentDic = self.arryFavrteList[indexPath.row] as! [String:Any]
        
        if (currentDic["parentServiceName"] as? String != nil) {
            cell.lblOFfServiceName.text = currentDic["parentServiceName"] as? String
        }else {
             cell.lblOFfServiceName.text = ""
        }
        
        if (currentDic["serviceList"] as? [Any] != nil) {
            let serviceList = currentDic["serviceList"] as! [Any]
            let providerList = serviceList[0] as! [String : Any]
            if serviceList.count != 0{
                self.arryOfProivder = providerList["serviceProviderList"] as! [Any]
                cell.btnMore.isHidden = false
            }else {
                cell.btnMore.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
       guard let tableCell = cell as? HomeScreenCell else { return }
        
        tableCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableCell = cell as? HomeScreenCell else { return }
        
        storedOffsets[indexPath.row] = tableCell.collectionViewOffset
    }

}

extension favouriteServices: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let currentDic = self.arryFavrteList[collectionView.tag] as! [String:Any]
        if (currentDic["serviceList"] as? [Any] != nil) {
            let serviceList = currentDic["serviceList"] as! [Any]
            let providerList = serviceList[0] as! [String : Any]
            if serviceList.count != 0{
                self.arryOfProivder = providerList["serviceProviderList"] as! [Any]
                return self.arryOfProivder.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCell", for: indexPath) as! favoriteCell
        //cell.backgroundColor = model[collectionView.tag][indexPath.item]
        
        let currentDic = self.arryFavrteList[collectionView.tag] as! [String:Any]
        let serviceList = currentDic["serviceList"] as! [Any]
        let providerList = serviceList[0] as! [String : Any]
        self.arryOfProivder = providerList["serviceProviderList"] as! [Any]
      
        
        let currentdic = self.arryOfProivder[indexPath.item] as! [String : Any]
        
        if (currentdic["serviceProviderName"] as? String != nil) {
            cell.lblOfUserName.text = currentdic["serviceProviderName"] as? String
        }else {
            cell.lblOfUserName.text = ""
        }
        if (currentdic["rating"] as? String != nil) {
             cell.lblOfRadingCount.text = currentdic["rating"] as? String
        }else {
             cell.lblOfRadingCount.text = ""
        }
        
        if currentdic["serviceProviderImage"] as? String != nil{
            let imgUrl = currentdic["serviceProviderImage"] as? String
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceProviderDetails") as! ServiceProviderDetails
        let currentDic = self.arryFavrteList[collectionView.tag] as! [String:Any]
        let serviceList = currentDic["serviceList"] as! [Any]
        let providerArry = serviceList[0] as! [String:Any]
        vc.childServicedId = (providerArry["serviceId"] as? String)!
        let providerList = providerArry["serviceProviderList"] as! [Any]
        let currentdic = providerList[indexPath.item] as! [String : Any]
        vc.serviceProviderId = (currentdic["serviceProviderName"] as? String)!
        self.navigationController?.pushViewController(vc , animated: true)
        //print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}
//MARK: - WS_OrderCompleted
extension favouriteServices {
    func getFavrteList(){
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
        ]
        
        print("favourite ws I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getAllFavouriteList?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfgetFavrteList(strURL: strURL, dictionary: dictionary )
        }else {
            //self.view.makeToast(string.noInternetConnMsg)
            self.stopActivityIndicator()
            refreshControl.endRefreshing()
            self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.noInternetConnMsg, lableNoInternate: string.noInternateMessage2)
            self.tblOfService.addSubview(self.noDataView)
        }
    }
    
    func callWSOfgetFavrteList(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? Int == 1 {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    if let data = JSONResponse["favouriteList"] as? [Any] {
                        self.arryFavrteList = data
                        self.tblOfService.reloadData()
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
                        self.tblOfService.addSubview(self.noDataView)
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







