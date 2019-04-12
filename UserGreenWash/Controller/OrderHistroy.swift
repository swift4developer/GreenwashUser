//
//  OrderHistroy.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 31/10/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit

class OrderHistroy: UIViewController{

    var pageMenu: CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNaviBackButton()
        navigationDesign()

        self.title = "Orders Histroy"
        // Do any additional setup after loading the view.
        
        let arrMenuTab : Array<String>
            arrMenuTab = ["COMPLETED" , "CANCELED"];

        
        //Add ViewControllers
        var viewController : [UIViewController] = []
        for tbleName in arrMenuTab{
            switch tbleName{
            //Add HomeViewController to MainViewController
            case "COMPLETED":
                let completed : OrderCompleted = self.storyboard?.instantiateViewController(withIdentifier: "OrderCompleted") as! OrderCompleted
                completed.title = NSLocalizedString("COMPLETED", comment: "")
                viewController.append(completed)
                break
            case "CANCELED":
                let canceled : OrderCanclled = self.storyboard?.instantiateViewController(withIdentifier: "OrderCanclled") as! OrderCanclled
                canceled.title = NSLocalizedString("CANCELED", comment: "")
                viewController.append(canceled)
                break
            default:
                print("Nothing")
            }
        }
       
        var menuFont = 15.0
        var selctnIndicatoreHeight = 3.0
        let type =  UserDefaults.standard.value(forKey: "Device") as? String
        if type! == "iPad" {
            menuFont = 22.0
            selctnIndicatoreHeight = 3.5
        }else {
            menuFont = 15.0
            selctnIndicatoreHeight = 3.0
        }
        // Customize menu according to new chnages
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor.black),
            .selectedMenuItemLabelColor(color.orangeColor),
            .selectionIndicatorColor(color.greenColor ),
            .selectionIndicatorHeight(CGFloat(selctnIndicatoreHeight)),
            .menuHeight(60.0),
            .menuItemWidth(self.view.frame.size.width/2.5),
            .centerMenuItems(true),
            .addBottomMenuHairline(true),
            .bottomMenuHairlineColor(UIColor.lightGray),
            .menuItemFont(UIFont(name:"Raleway-Medium", size:CGFloat(menuFont))!),
            .menuItemWidthBasedOnTitleTextWidth(false),
        ]
        
        //UIFont (name: "HelveticaNeue-UltraLight", size: 30)
        //UIFont.boldSystemFont(ofSize: 17)
        // Initialize scroll menu
        self.pageMenu = CAPSPageMenu(viewControllers: viewController, frame: CGRect(x: 0.0, y: 64.0, width: self.view.frame.width, height: self.view.frame.height - 64), pageMenuOptions: parameters)
        self.addChildViewController(self.pageMenu!)
        self.view.addSubview(self.pageMenu!.view)
    }
}
