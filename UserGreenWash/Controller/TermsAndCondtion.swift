//
//  TermsAndCondtion.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 03/11/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import WebKit

class TermsAndCondtion: UIViewController,UIGestureRecognizerDelegate,WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    
    var flgNoInternetClass = true
    var noIntetnetClsObj : NoInternetClass?
    var flgWS = ""
    var flgwebLoad = true
    var noDataView = UIView()
    var strngUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNaviBackButton()
        navigationDesign()
        
        self.title = "Terms And Conditions"
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame:CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64), configuration: webConfiguration)
        
        self.view.addSubview(webView)
        self.webView.allowsBackForwardNavigationGestures = true
        
        let urlString  = "https://media.termsfeed.com/pdf/terms-and-conditions-template.pdf"
        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            DispatchQueue.main.async{
                self.webView.load(request)
               
            }
        }
        
    }
    
    

}
