//
//  CommanClass.swift
//  MoneyLander
//
//  Created by PUNDSK003 on 15/09/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import Foundation
import UIKit

class buttonDesign : UIButton {
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor(red: 9.0/255.0, green: 143.0/255.0, blue: 8.0/255.0, alpha: 1.0)
        self.setTitleColor(UIColor.white , for: .normal)
    }
}
class buttonOnlyTitleDesign : UIButton {
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.white
        self.setTitleColor(UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0) , for: .normal)
    }
}

class lbleDesign : UILabel {
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.textColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0)
        
    }
}

class textFiledDesign : UITextField {
    required public init?(coder aDecoder: NSCoder) {
        
        //#bdbdbd; rgb(189,189,189)
        super.init(coder: aDecoder)
        self.textColor = UIColor(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0, alpha: 1.0)
        //self.font = UIFont(name: "Raleway-Medium", size: 20)
    }
}

class textViewDesign : UITextView {
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.textColor = UIColor(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0, alpha: 1.0)
         //self.textColor.font = UIFont(name: "NameOfTheFont", size: 20)
        //self.font = UIFont(name: "Raleway-Medium", size: 20)
    }
}

class viewDesign : UIView {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.backgroundColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}

@IBDesignable
class RoundedEndsView: UIView {
    
    override func layoutSubviews() { setup() } // "layoutSubviews" is best
    
    func setup() {
        //let r = self.bounds.size.height / 2
        let r = 2
        let path = UIBezierPath(roundedRect: self.bounds,  byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: r, height: r))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask

    }
}

@IBDesignable
class FundingdateBackView: UIView {
    
    override func layoutSubviews() {
        
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:[.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 50, height:  50))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}


@IBDesignable
class viewOfShadow: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 5
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 2
    @IBInspectable var shadowColor: UIColor? = UIColor.white
    @IBInspectable var shadowOpacity: Float = 3
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    };
}



@IBDesignable
class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 8.0
    @IBInspectable var rightInset: CGFloat = 8.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
    override func layoutSubviews() { setup() } // "layoutSubviews" is best
    
    func setup() {
        let r = self.bounds.size.height / 2
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius:r)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

@IBDesignable
class CustomView: UIView{
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

@IBDesignable
class RoundedImageView:UIImageView {
    @IBInspectable
    var borderColor:UIColor = UIColor.white {
        willSet {
            layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        willSet {
            layer.borderWidth = borderWidth
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

@IBDesignable
class SquarBordeImageView:UIImageView {
    @IBInspectable
    var borderColor:UIColor = UIColor.white{
        willSet {
            layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        willSet {
            layer.borderWidth = borderWidth
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

@IBDesignable
class RoundedLbl :UILabel{
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.height / 2
    }
}



