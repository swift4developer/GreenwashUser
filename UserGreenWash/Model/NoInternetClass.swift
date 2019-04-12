//
//  NoInternetClass.swift
//  malabes
//
//  Created by Pavan Jadhav on 15/06/17.
//  Copyright © 2017 Intechcreative Pvt. Ltt. All rights reserved.
//

import UIKit

protocol NoInternetClassDelegate
{
   func tryAgain()
}

class NoInternetClass: UIView {

    var flg = "NoConnection"
    
    var delegate: NoInternetClassDelegate?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect)
    {
        super.init(frame: frame)
       
            
           self.backgroundColor = color.barTintColor
        
        //Set Image
           let imgView = UIImageView(frame: CGRect(x: (ScreenSize.SCREEN_WIDTH/2)-90 , y: (ScreenSize.SCREEN_HEIGHT/2)-230, width: 180, height: 180))
        
           imgView.image = UIImage(named:"no_internet_icon.png")
           self.addSubview(imgView)
    
           //Set Label OOps
           let lblOoops = UILabel(frame: CGRect(x: 0, y:  imgView.frame.origin.y+imgView.frame.size.height+25, width: ScreenSize.SCREEN_WIDTH, height: 40))
            lblOoops.text = "Ooops!"
            lblOoops.font = UIFont(name: fontAndSize.menuItemFont, size: 34.0)
        
            lblOoops.textAlignment = .center
            lblOoops.textColor = color.selectionIndicatorColor
            self.addSubview(lblOoops)
        
            //Label NoInternet
    
            let lblNoInternet = UILabel(frame: CGRect(x: 0, y: lblOoops.frame.origin.y+lblOoops.frame.size.height+5, width: ScreenSize.SCREEN_WIDTH, height: 50))
        
            if flg == "NoConnection"
            {
                 lblNoInternet.text = string.noInternetConnMsg;
            }
            else
            {
                lblNoInternet.text = string.someThingWrongMsg;
            }
            
            lblNoInternet.numberOfLines = 2;
            lblNoInternet.font = UIFont(name: fontAndSize.errorFont, size: 18.0)
            lblNoInternet.textAlignment = .center
            lblNoInternet.textColor = color.textPlaceHolderColor

            self.addSubview(lblNoInternet)
        
     
            let btnTryAgain =  UIButton(type: .system)
            btnTryAgain.addTarget(self, action: #selector(btnTryAgain(_:)), for: .touchUpInside)
            btnTryAgain.frame = CGRect(x: (ScreenSize.SCREEN_WIDTH/2)-80, y: lblNoInternet.frame.origin.y+lblNoInternet.frame.size.height+60, width: 160.0, height: 40.0)
            btnTryAgain.setTitle("TRY AGAIN", for: .normal)
            btnTryAgain.titleLabel?.font = UIFont(name: fontAndSize.errorFont, size: 20.0)
            btnTryAgain.tintColor = UIColor.white
            btnTryAgain.backgroundColor = UIColor.black
            self.addSubview(btnTryAgain)
    
    
    
    }
    @objc func btnTryAgain(_ sender: UIButton)
    {
       delegate?.tryAgain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
