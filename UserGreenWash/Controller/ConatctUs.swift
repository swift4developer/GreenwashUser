//
//  ConatctUs.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 01/11/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit

class ConatctUs: UIViewController {

    @IBOutlet var lblOfTitleName: UILabel!
    @IBOutlet var lblOfInfo: UILabel!
    @IBOutlet var lblOfUserName: UILabel!
    @IBOutlet var lblOdAddress: UILabel!
    
    @IBOutlet var lblOfPhoneNumber: UILabel!
    @IBOutlet var lblOfEmail: UILabel!
    @IBOutlet var btnCall: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setNaviBackButton()
        navigationDesign()
        self.title = "Conatct Us"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCallClick(_ sender: Any) {
        
        let strngContct:Int64 = Int64("9876543210")!
        
        if let url  = URL(string: "tel://\(strngContct)"), UIApplication.shared.canOpenURL(url){
            
            if #available(iOS 10, *){
                UIApplication.shared.open(url)
            }
            else {
                UIApplication.shared.canOpenURL(url)
            }
        }
        
    }
    


}
