//
//  HomeScreenCell.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 26/10/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit

class HomeScreenCell: UITableViewCell {

    @IBOutlet var lblOfServiceName: UILabel!
    @IBOutlet var imgOfService: UIImageView!
    
    //Notification
    @IBOutlet var backViewOfCell: CustomView!
    @IBOutlet var imgOfDelete: UIImageView!
    @IBOutlet var lblOfStatus: UILabel!
    @IBOutlet var lblOfStatusDescrptn: UILabel!
    @IBOutlet var lblOfDateTime: UILabel!
    @IBOutlet var backView2: UIView!
    @IBOutlet var btnDelete: UIButton!
    
    
    //Active Orders
    @IBOutlet var imgOfUser: UIImageView!
    @IBOutlet var lblOfUserName: UILabel!
    @IBOutlet var lblOfBookingStatus: UILabel!
    @IBOutlet var lblOfBookingInfo: UILabel!
    @IBOutlet var lblOfOrderId: UILabel!
    @IBOutlet var lblOfOderrDate: UILabel!
    @IBOutlet var lblOfOrderTime: UILabel!
    @IBOutlet var btnOfMore: UIButton!
    @IBOutlet var btnPayNow: UIButton!
    
    
    //Favourite
    @IBOutlet weak var lblOFfServiceName: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    
    
    //Service Provider List
    @IBOutlet weak var lblOfServcProvidrNam: UILabel!
    @IBOutlet weak var imgOfFav: UIImageView!
    @IBOutlet weak var btnOfFav: UIButton!
    @IBOutlet weak var lblOfPrice: UILabel!
    @IBOutlet weak var imgOfProvider: UIImageView!
    @IBOutlet weak var lblOfReviewCount: UILabel!
    @IBOutlet weak var lblOfJobCOunt: UILabel!
    @IBOutlet weak var lblOfRatingCount: UILabel!
    
    //Service Details Screen - Other Services
    @IBOutlet weak var lblOfServiceInfo: UILabel!
    @IBOutlet weak var btnOfServiceCharge: UIButton!
    
    //Service Details Screen - Customer Review
    @IBOutlet weak var imgOfProfile: UIImageView!
    @IBOutlet weak var lblOfCutomerName: UILabel!
    @IBOutlet weak var lblOfReviewDate: UILabel!
    @IBOutlet weak var lblOfReviewDetails: UILabel!
    
    //Calnder cellCalnder
    @IBOutlet weak var imgOfRight: UIImageView!
    @IBOutlet weak var lblOfRight: UILabel!
    
    
    @IBOutlet var CollectnInTblView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension HomeScreenCell{
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        CollectnInTblView.delegate = dataSourceDelegate
        CollectnInTblView.dataSource = dataSourceDelegate
        CollectnInTblView.tag = row
        CollectnInTblView.setContentOffset(CollectnInTblView.contentOffset, animated:false)
        // Stops collection view if it was scrolling.
        CollectnInTblView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { CollectnInTblView.contentOffset.x = newValue }
        get { return CollectnInTblView.contentOffset.x }
    }
}














