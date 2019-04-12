//
//  HowItWork.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 02/11/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit

class HowItWork: UIViewController {
    
    @IBOutlet weak var imgSlideShow: ImageSlideshow!
    @IBOutlet weak var lblInfo: UILabel!
    
    var arrTextInfo = [String]()
    var appDelegate : AppDelegate!
    var currPage : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setNaviBackButton()
        navigationDesign()
        self.title = "How it works"
        
        self.lblInfo.text = NSLocalizedString("Find the service provider\nfor any service", comment: "")
        
        arrTextInfo = ["Find the service provider\nfor any service", "Select date and time slot\nfor service","Confirm and Place Order.\nThat's it."]
        
        imgSlideShow.circular = true
        imgSlideShow.backgroundColor = UIColor.white
        imgSlideShow.pageControlPosition = PageControlPosition.underScrollView
        imgSlideShow.pageControl.currentPageIndicatorTintColor = color.greenColor
        imgSlideShow.pageControl.pageIndicatorTintColor = UIColor.gray
        imgSlideShow.scrollView.bounces = false
        imgSlideShow.contentScaleMode = .center
        self.currPage = 0
        
        imgSlideShow.slideshowInterval = 3.0
        
        imgSlideShow.currentPageChanged  = { page in
            
            if (self.arrTextInfo.count - 1) == page {
                self.currPage = page
            }
            self.lblInfo.text = self.arrTextInfo[page]
        }
        
        
        let localSource =  [ImageSource(imageString:"carWash")!, ImageSource(imageString:"calnder1")!,ImageSource(imageString: "check")!]
        
        imgSlideShow.setImageInputs(localSource)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



