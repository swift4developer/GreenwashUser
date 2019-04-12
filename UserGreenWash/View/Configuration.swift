//
//  Configuration.swift
//  MalaBes
//
//  Created by PUNDSK006 on 4/18/17.
//  Copyright © 2017 Intechcreative Pvt. Ltt. All rights reserved.
//

import Foundation
import UIKit

// URL Struct
struct Url{
    //static let baseURL = ""
    static let baseURL = "http://27.109.19.234/taskfinder/public/api/"
    //"http://192.168.2.11/taskfinder/public/api/"
    
    static let autocompleteLocationApi = "https://maps.googleapis.com/maps/api/place/autocomplete/json?types=establishment&language=eng&key=\(string.googleAPIKeyForGeoCode)&input="
    
    static let getAddressApi = "https://maps.googleapis.com/maps/api/geocode/json?key=\(string.googleAPIKeyForGeoCode)&latlng="
    static let getLatLongApi = "https://maps.googleapis.com/maps/api/place/details/json?key=\(string.googleAPIKeyForGeoCode)&sensor=false&reference="
}

// MARK: static String Data
struct string{
    //MARK: TabMenu Array
    //Toast Msg
    static var noInternetConnMsg = NSLocalizedString("No Internet", comment: "")
    static var noInternateMessage2 = NSLocalizedString("Please check your network connection.", comment: "")
    static var noDataFoundMsg = NSLocalizedString("We didn't find any properties", comment: "")
    static var noDataFoundMsgForMyPost = NSLocalizedString("We didn't find any Post", comment: "")
    static var noDataFoundMsgForDetal = NSLocalizedString("We didn't find any Notification", comment: "")
    static var oppsMsg = NSLocalizedString("OOPS!", comment: "")
    static var someThingWrongMsg = NSLocalizedString("Something went wrong. Please try again later.", comment: "")
    
    static let googleAPIKey = "AIzaSyAGQ2I-WDdvkqR3IGUIbNYiNYBvtmfQFMQ" //"AIzaSyC33uHNkqBJV4KTVgUN5cX9Oem_yl6yJ7A"
    static let googleAPIKeyForGeoCode = "AIzaSyAGQ2I-WDdvkqR3IGUIbNYiNYBvtmfQFMQ" //"AIzaSyBJMf03e66En0D08uW3mybyFfjz8mn6KZc"
    
    static let txtFiledMsg = " is blank"
}

struct userInfo {
    static var langID = "1"
    static var userID = 0
    static var privateKey = ""
    
}

struct fontAndSizeForIPad{
    
    static let menuItemFont = "System Bold"
    static let menuItemFontSize : CGFloat = 30.0
    static let NaviTitleFont = "Raleway-Medium"
    static let NaviTitleFontSize : CGFloat = 34.0
    static let errorFont = "System Medium"
    
}



// MARK: Color--------------------------------------------------
struct color{
    
    //TextField BorderColor
    static let shakeBorderColor = UIColor.red
    static let theamColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0)
    
    //PageMenu
    static let pgeMenuBorderColor = UIColor(red: 193.0/255.0, green: 193.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    static let unSeleMenu = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.8)
    static let selectedMenu = UIColor.black
    
    //MainViewController Color
    static let ImgborderCoor = UIColor(red: 134.0/255.0, green: 135.0/255.0, blue: 136.0/255.0, alpha: 1.0)
    static let viewBgColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

    static let selectionIndicatorColor = UIColor.black
    static let navigationColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let navigationDarkColor = UIColor(red: 17.0/255.0, green: 54.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    static let drawerSelectedCellColor = UIColor(red: 2.0/255.0, green: 94.0/255.0, blue: 166.0/255.0, alpha: 1.0)
    
    static let navigationBar =  UIColor.white
    static let barTintColor = UIColor(red: 9.0/255.0, green: 143.0/255.0, blue: 8.0/255.0, alpha: 1.0)
        //UIColor(red: 37.0/255.0, green: 107.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    
    //TextField Color
    
    static let placeHolderClr = UIColor(red: 68.0/255.0, green: 153.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    static let txtFieldBorderColor = UIColor(red: 68.0/255.0, green: 153.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    static let txtFieldTintColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0)
    static let txtColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0)
    // static let txtBgColor = UIColor(red: 23.0/255.0, green: 23.0/255.0, blue: 23.0/255.0, alpha: 0.9);
    
    //Error Color
    static let textPlaceHolderColor =  UIColor(red: 68.0/255.0, green: 153.0/255.0, blue: 220.0/255.0, alpha: 1.0)

    //rgb(184,223,248) 1
    //rgb(249,226,187) 2
    //rgb(176,234,221) 3
    static let backView1 = UIColor(red: 184.0/255.0, green: 223.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    static let backView2 = UIColor(red: 249.0/255.0, green: 226.0/255.0, blue: 187.0/255.0, alpha: 1.0)
    static let backView3 = UIColor(red: 176.0/255.0, green: 234.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    
    static let smallView1 = UIColor(red: 184.0/255.0, green: 223.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    static let smallView2 = UIColor(red: 249.0/255.0, green: 226.0/255.0, blue: 187.0/255.0, alpha: 1.0)
    static let smallView3 = UIColor(red: 176.0/255.0, green: 234.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    
    //Menu color
    //rgb(243,92,72)
    static let selectionColor = UIColor(red: 243.0/255.0, green: 92.0/255.0, blue: 72.0/255.0, alpha: 1.0)
    //rgb(194,67,50)
    static let UnSelectionColor = UIColor(red: 194.0/255.0, green: 67.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    static let verylightGray = UIColor(red: 236.0/255.0, green: 243.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    //#6a318f; rgb(106,49,143)
    static let purpleColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 143.0/255.0, alpha: 1.0)
    
    //rgb(162,205,58)
    static let greenColor = UIColor(red: 9.0/255.0, green: 143.0/255.0, blue: 8.0/255.0, alpha: 1.0)
    
    //rgb(255,152,0) FF9800
    static let orangeColor = UIColor(red: 255.0/255.0, green: 152.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    //rgb(230,230,230) e6e6e6
    static let grayColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    //rgb(255,0,0) #FF0000
    static let redColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
}


// MARK: FontAndSize-------------------------------------------------
struct fontAndSize{
    static let menuItemFont = "System Bold"
    static let menuItemFontSize : CGFloat = 15.0
    static let NaviTitleFont = "Raleway-Medium"
    static let NaviTitleFontSize : CGFloat = 17.0
    static let errorFont = "System Medium"
}




// MARK:  Device  Detection------------------------------------------------


enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}



// MARK:  Device OS Version  Detection

struct Version
{
    
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
}


