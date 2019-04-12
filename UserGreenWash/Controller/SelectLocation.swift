//
//  SelectLocation.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 25/10/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import GoogleMaps


class SelectLocation: UIViewController , GMSMapViewDelegate ,NVActivityIndicatorViewable{

    //MARK: - Out_lets
    @IBOutlet var txtOfSerch: UITextField!
    @IBOutlet var mapView: UIView!
    private var map_View: GMSMapView!
    var arrayOfLocations =  [Any]()
    let dropDown = DropDown()
    var selectedAdd = "0"
    var appDelegate : AppDelegate!
    var isMapMove = false
    
    @IBOutlet weak var centreMapImg: UIImageView!
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.lat == nil {
            appDelegate.lat = "18.590959"
        }
        
        if appDelegate.long == nil {
            appDelegate.long = "73.753122"
        }

        txtOfSerch.setLeftIcon(UIImage(named:"search")!)
     
        if Validation1.isConnectedToNetwork()  {
            let camera = GMSCameraPosition.camera(withLatitude:Double(appDelegate.lat)!, longitude: Double(appDelegate.long)!, zoom: 9.0)
            map_View = GMSMapView.map(withFrame: CGRect(x: 0,y: 0 , width: self.view.frame.width , height:self.view.frame.height - 20), camera: camera)
            map_View.delegate = self
            map_View.isMyLocationEnabled = true
            
            // Creates a marker in the center of the map.
            //let marker = GMSMarker()
            //marker.position = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
            //marker.map = map_View
            
            mapView.addSubview(map_View)
            mapView.addSubview(centreMapImg)
            mapView.bringSubview(toFront: centreMapImg)
            mapView.bringSubview(toFront: txtOfSerch)
        }
        
        //loadMap(latitude:Double(appDelegate.lat)!, longitude:Double(appDelegate.long)!)
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        print("Lat:1 ",appDelegate.lat,"long:1 ",appDelegate.long)
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNaviBackButton()
        navigationDesign()
        
        let btnDone = UIButton(frame: CGRect(x: 0, y:0, width:50,height: 30))
        btnDone.setTitle("DONE", for: .normal)
        btnDone.addTarget(self,action: #selector(doneButton), for: .touchUpInside)
        let backBarButtonitem = UIBarButtonItem(customView: btnDone)
        let arrRightBarButtonItems : Array = [backBarButtonitem]
        
        let widthConstraint = btnDone.widthAnchor.constraint(equalToConstant: 50)
        let heightConstraint = btnDone.heightAnchor.constraint(equalToConstant: 30)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        self.navigationItem.rightBarButtonItems = arrRightBarButtonItems
        self.title = "Select Location"
        
        getAdrressFromLatLong(Double(appDelegate.lat)!,Double(appDelegate.long)!)
        
    }
    
    
    @objc func doneButton() {
        
        self.view.endEditing(true)
        if selectedAdd == "0" || Validation1.checkNotNullParameter(checkStr: self.txtOfSerch.text!){
            self.view.makeToast("Please enter the address")
        }else {
            let dictionary = ["userId" : String(userInfo.userID),
                              "userPrivateKey" : userInfo.privateKey,
                              "related_flag" : "1",
                              "lat" : String(appDelegate.lat),
                              "long" : String(appDelegate.long),
                              "addressDetails" : self.txtOfSerch.text ?? ""]
            
            print("I/P:",dictionary)
            var strURL = ""
            strURL = String(strURL.characters.dropFirst(1))
            strURL = Url.baseURL + "updateLocation?"
            print(strURL)
            strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            if Validation1.isConnectedToNetwork() == true {
                startActivityIndicator()
                _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                self.callWSOfupdateLocation(strURL: strURL, dictionary: dictionary )
            }else{
                self.view.makeToast(string.noInternetConnMsg)
            }
        }
    }
    
    //MARK: - Map methods
    func loadMap(latitude:Double,longitude:Double) {
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2D(latitude:26.066479, longitude: -80.219765)
        //        marker.title = "Florida"
        //        marker.snippet = "USA"
        //        marker.map = map_view
        //        marker.opacity = 0.85
        //        marker.isFlat = true
        //        marker.appearAnimation = GMSMarkerAnimation.pop
        //      //  map_view.selectedMarker = marker
        //        marker.icon = self.imageWithImage(image: UIImage(named: "locationMarker.png")!, scaledToSize: CGSize(width: 50.0, height: 50.0))
        //Double(appDelegate.long)
        appDelegate.lat = String(latitude)
        appDelegate.long = String(longitude)
        
        let position = CLLocationCoordinate2DMake(latitude, longitude)
        let newCamera = GMSCameraPosition.camera(withTarget: position,
                                                 zoom: map_View.camera.zoom)
        let update = GMSCameraUpdate.setCamera(newCamera)
        map_View.moveCamera(update)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude;
        let longitude = mapView.camera.target.longitude;
        
        if isMapMove == true {
            isMapMove = false
                DispatchQueue.main.async {
                    self.loadMap(latitude: latitude, longitude: longitude)
                }
        }
        
        _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
        getAdrressFromLatLong(latitude, longitude)
        //getAdrressFromLatLong(latitude, longitude)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("Move Map success")
        isMapMove = true
    }
    
}
//MARK: - TextFiled Delegate
extension SelectLocation : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtOfSerch.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        filterContentForSearchText(txtOfSerch.text!)
        return true
    }
}
extension SelectLocation {
    
    func filterContentForSearchText(_ searchText: String) {
        
        var strURL : String =  Url.autocompleteLocationApi + searchText
        print(strURL)
        strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        AFWrapper.requestGETURL(strURL, success: {
            (JSONResponse) -> Void in
            
            if let status = JSONResponse["status"] as? String
            {
                if status == "OK"
                {
                    if let data = JSONResponse["predictions"] as? [Any]
                    {
                        self.arrayOfLocations =  [Any]()
                        var arrayOfDescription =  [Any]()
                        
                        for i in 0..<data.count {
                            let value1 = data[i] as! NSDictionary
                            self.arrayOfLocations .append(value1)
                            arrayOfDescription.append(value1.object(forKey: "description") as? String ?? "")
                        }
                        DispatchQueue.main.async {
                            self.dropDown.dataSource = arrayOfDescription as! [String]
                            self.dropDown.selectionAction = { [unowned self] (index, item) in
                                let dict = self.arrayOfLocations[index] as! NSDictionary
                                let refKey = dict.object(forKey: "reference") as? String ?? ""
                                self.txtOfSerch.text = item
                                self.selectedAdd = "1"
                                _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                                self.getLatLongFromAddressRefrenceKey(refKey)
                                
                            }
                            self.dropDown.anchorView = self.txtOfSerch
                            self.dropDown.bottomOffset = CGPoint(x:30, y:self.txtOfSerch.bounds.height)
                            self.dropDown.width = self.txtOfSerch.frame.width - 60// 7+
                            
                            if self.dropDown.isHidden
                            {
                                self.dropDown.show()
                            } else
                            {
                                self.dropDown.hide()
                            }
                        }
                    }
                }
            }
            
        }) {
            (error) -> Void in
            DispatchQueue.main.async {
                self.view.makeToast(string.someThingWrongMsg)
                //self.stopActivityIndicator()
            }
        }
    }
    
    func getAdrressFromLatLong(_ lattitude: Double,_ logitude: Double) {
        
        // https://maps.googleapis.com/maps/api/geocode/json?latlng=23.012688745481114,72.52159282565117&key=AIzaSyCdSToqCL7b-aADjEL_GJv8_qUDQU49Bi8
        
        let latLong = "\(lattitude),\(logitude)"
        print("Current lat_long: ",latLong)
        
        var strURL : String =  Url.getAddressApi + latLong
        // print(strURL)
        strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        AFWrapper.requestGETURL(strURL, success: {
            (JSONResponse) -> Void in
            
            if let status = JSONResponse["status"] as? String
            {
                if status == "OK"
                {
                    if let data = JSONResponse["results"] as? [Any]
                    {
                        var arrayOfCurrentLocation =  [Any]()
                        for i in 0..<data.count {
                            let value1 = data[i] as! NSDictionary
                            arrayOfCurrentLocation.append(value1.object(forKey: "formatted_address") as? String ?? "")
                        }
                        
                        DispatchQueue.main.async {
                            if arrayOfCurrentLocation.count > 0{
                                self.txtOfSerch.text = arrayOfCurrentLocation[0] as? String
                                self.selectedAdd = "1"
                            }
                        }
                    }
                }
            }
            
        }) {
            (error) -> Void in
            DispatchQueue.main.async {
                self.view.makeToast(string.someThingWrongMsg)
                //self.stopActivityIndicator()
            }
        }
    }
    
    func getLatLongFromAddressRefrenceKey(_ refKey: String) {
        
        // https://maps.googleapis.com/maps/api/place/details/json?reference=ChIJN1t_tDeuEmsRUsoyG83frY4&key=YOUR_API_KEY&sensor=false
        
        var strURL : String =  Url.getLatLongApi + refKey
        print(strURL)
        strURL = strURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        AFWrapper.requestGETURL(strURL, success: {
            (JSONResponse) -> Void in
            if let status = JSONResponse["status"] as? String
            {
                if status == "OK"
                {
                    if let data = JSONResponse["result"] as? NSDictionary
                    {
                        // let geometry = data.object["geometry"]["location"]["lat"] as String
                        let geometry = data.object(forKey: "geometry") as? NSDictionary
                        let location = geometry?.object(forKey: "location") as? NSDictionary
                        let lat = location?.object(forKey: "lat") as! Double
                        let lng = location?.object(forKey: "lng") as! Double
                        
                        DispatchQueue.main.async {
                            if Validation1.isConnectedToNetwork()  {
                                self.loadMap(latitude: lat, longitude: lng)
                            }
                            else{
                                self.view.makeToast(string.noInternetConnMsg)
                            }
                        }
                    }
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
}

// MARK: WS UpdateLocation
extension SelectLocation {
    
    func callWSOfupdateLocation(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            var data = [String:Any]()
            data = JSONResponse
            //let response = JSONResponse
            if data["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.view.makeToast((data["message"] as? String)!)
                    self.selectedAdd = "0"
                    self.appDelegate.postBookingReqDic["address"] = self.txtOfSerch.text!
                    self.appDelegate.postBookingReqDic["lattitude"] = self.appDelegate.lat!
                    self.appDelegate.postBookingReqDic["longitude"] = self.appDelegate.long!
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else{
                let status = data["status"] as? String
                self.stopActivityIndicator()
                switch status!{
                case "0":
                    //When Parameter Missing
                    print("error2: ")
                    self.view.makeToast((data["message"] as? String)!)
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
