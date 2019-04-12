//
//  BookServiceDateTime.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 07/11/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit

class BookServiceDateTime:UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblOfSevicName: UILabel!
    @IBOutlet weak var heightOftTblView: NSLayoutConstraint!
    @IBOutlet weak var viewOfSpecailnstrcn: UIView!
    @IBOutlet weak var txtOfSpecailInstructn: JVFloatLabeledTextView!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    var KeyBoardheight  = 0.0
    var tempSelectArr : [String]!
    var arrayOfTime : [Any] = []
    var childServicedId = ""
    var noDataView = UIView()
    var strDate = Date()
    var serviceProviderId = ""
    var strfromTime = ""
    var strtoTime = ""
    var servicveName = ""
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: -
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.select(Date())
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        
        
        setNaviBackButton()
        navigationDesign()
        self.title = "Book Service"
        self.lblOfSevicName.text = self.servicveName
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        //txtOfSpecailInstructn.placeholder = "Any Specail Instructions?"
        //txtOfSpecailInstructn.placeholderTextColor = UIColor.lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        //call WS
        getTimeBlockList()

    }
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //let keyboardHeight = keyboardSize.height
            KeyBoardheight = Double(keyboardSize.height)
            print("KeyBoardheight : ",KeyBoardheight)
        }
    }
    
    @IBAction func btnContinueClick(_ sender: Any) {
        
        var selctnCount = 0
        for i in (0..<tempSelectArr.count).reversed(){
            if tempSelectArr[i] == "1"{
                selctnCount += 1
            }
        }
        
        if selctnCount == 0{
            self.view.makeToast(NSLocalizedString("Please select the time block", comment: ""))
        }else {
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.viewOfSpecailnstrcn.transform = CGAffineTransform(translationX: 0, y:0)
            })
            self.appDelegate.postBookingReqDic["fromTime"] = strfromTime
            self.appDelegate.postBookingReqDic["toTime"] = strtoTime
            self.appDelegate.postBookingReqDic["specialInstructions"] = txtOfSpecailInstructn.text!
            self.appDelegate.postBookingReqDic["selectedDate"] = self.dateFormatter.string(from: strDate)
            
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewController(withIdentifier:"OrderSummryScreen") as! OrderSummryScreen, animated: true)
        }
    }
    
    deinit {
        print("\(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        //heightOftTblView.constant = tableView.contentSize.height
    }
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.viewOfSpecailnstrcn.transform = CGAffineTransform(translationX: 0, y:0)
        })
        
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    // MARK:- CalendarDelegate
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        strDate = date
        getTimeBlockList()
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        let date = Date()
        strDate = date
        print("current Date: ",self.dateFormatter.string(from: strDate))
        return date
    }
    
    // MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return [2,20][section]
        if section == 0 {
            return 1
        }else {
           return self.arrayOfTime.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //let identifier = ["cell_week","cell"][indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_week")!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeScreenCell
            
            let currentDic = self.arrayOfTime[indexPath.row] as! [String : Any]

            let fromTime = currentDic["fromTime"] as? String
            let toTime = currentDic["toTime"] as? String
            
            cell.lblOfRight.text = fromTime! + " to " +  toTime!
            
            if(tempSelectArr[indexPath.row] == "1"){
                cell.imgOfRight.isHidden = false
            }
            else{
                cell.imgOfRight.isHidden = true
            }
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let type =  UserDefaults.standard.value(forKey: "Device") as? String
        if type! == "iPad" {
            if indexPath.section == 0 {
                return 60
            }else {
                return 80
            }
        }else {
            return 44
        }
    }
    
    
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.viewOfSpecailnstrcn.transform = CGAffineTransform(translationX: 0, y:0)
        })
        
        if indexPath.section == 0 {
            
        }else {
            for i in 0..<tempSelectArr.count{
                if(i == indexPath.row){
                    if(indexPath.row ==  i){
                        tempSelectArr[indexPath.row] = "1"
                        let currentDic = self.arrayOfTime[indexPath.row] as! [String : Any]
                        
                        strfromTime = (currentDic["fromTime"] as? String)!
                        strtoTime = (currentDic["toTime"] as? String)!
                    }
                    else{
                        tempSelectArr[indexPath.row] = "0"
                    }
                }
                else{
                    tempSelectArr[i] = "0"
                }
            }
            tableView.reloadData()
        }
        
        /*tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
            self.calendar.setScope(scope, animated: true)
        }*/
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
extension BookServiceDateTime : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.viewOfSpecailnstrcn.transform = CGAffineTransform(translationX: 0, y: CGFloat( -self.KeyBoardheight))
        })
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.viewOfSpecailnstrcn.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
}

//MARK: - WS_OrderCompleted
extension BookServiceDateTime {
    func getTimeBlockList(){
        let dictionary = ["userId" : String(userInfo.userID),
                          "userPrivateKey" : userInfo.privateKey,
                          "related_flag" : "1",
                          "serviceProviderId" : serviceProviderId,
                          "selectedDate" : self.dateFormatter.string(from: strDate),
                          "chilServicedId" : childServicedId
                          ]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getTimeBlockList?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        self.noDataView.removeFromSuperview()
        if Validation1.isConnectedToNetwork() == true {
            self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfgetTimeBlockList(strURL: strURL, dictionary: dictionary )
        }else {
            //self.view.makeToast(string.noInternetConnMsg)
            self.stopActivityIndicator()
            self.viewOfSpecailnstrcn.isHidden = true
            self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "5", lableNoData: string.noInternetConnMsg, lableNoInternate: string.noInternateMessage2)
            self.tableView.addSubview(self.noDataView)
        }
    }
    
    func callWSOfgetTimeBlockList(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    if let data = JSONResponse["timeBlockList"] as? [Any] {
                        if data.count > 0 {
                            self.noDataView.removeFromSuperview()
                            self.viewOfSpecailnstrcn.isHidden = false
                            self.btnContinue.isHidden = false
                            self.arrayOfTime = data
                            self.tempSelectArr = Array(repeating: "0", count: self.arrayOfTime.count)
                            //self.tempSelectArr[0] = "1"
                            if self.arrayOfTime.count != 0{
                                DispatchQueue.main.async{
                                    self.tableView.reloadData()
                                }
                            }else {
                                self.viewOfSpecailnstrcn.isHidden = true
                                self.btnContinue.isHidden = false
                            }
                        }else {
                            self.stopActivityIndicator()
                            self.viewOfSpecailnstrcn.isHidden = true
                            
                            self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "5", lableNoData:"Choose your service time.", lableNoInternate:"No time block available for selected date, Please choose another date")
                            self.tableView.addSubview(self.noDataView)
                        }
                    }
                }
            }
            else{
                self.stopActivityIndicator()
                print("error2: ")
                if JSONResponse["status"] as? String == "0"{
                    //When Parameter Missing
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
                        self.stopActivityIndicator()
                        self.viewOfSpecailnstrcn.isHidden = true
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "5", lableNoData:"Choose your service time.", lableNoInternate:"No time block available for selected date, Please choose another date")
                        self.tableView.addSubview(self.noDataView)
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
