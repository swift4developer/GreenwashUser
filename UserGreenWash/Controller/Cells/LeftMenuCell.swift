//
//  LeftMenuCell.swift
//  MoneyLander
//
//  Created by PUNDSK006 on 8/1/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit

class LeftMenuCell: UITableViewCell {

    @IBOutlet var imgBottomConst: NSLayoutConstraint!
    @IBOutlet var imgArrow: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var imgIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class LeftMenuHeader1Cell: UITableViewCell {
    
    @IBOutlet var lblSub: UILabel!
    @IBOutlet var imgArr: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var profImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class LeftMenuHeader2Cell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }
    @IBOutlet var notiView: UIView!
    
    @IBOutlet var lblWidth: NSLayoutConstraint!
    @IBOutlet var lblCount: UILabel!
    @IBOutlet var imgNoti: UIImageView!
    @IBOutlet var notiLbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
