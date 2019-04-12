//
//  HomeChildServiceList.swift
//  UserGreenWash
//
//  Created by PUNDSK003 on 03/11/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import Alamofire

class HomeChildServiceList: UIViewController {

    @IBOutlet weak var collectnViewOfSrvces: UICollectionView!
    var arryOfData : [Any] = []
    var serviceTitle = ""
    var chache : NSCache<AnyObject,AnyObject>!
    var appDelegate : AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNaviBackButton()
        navigationDesign()
        self.title = serviceTitle
        self.chache = NSCache()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
}

extension HomeChildServiceList: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arryOfData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! favoriteCell
        
        let currntDic = arryOfData[indexPath.row] as! [String: Any]
        cell.lblOfSefviceInfo.text = currntDic["child_name"] as? String
        
        let imgUrl = currntDic["child_image"] as? String
        
        let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
        cell.imgOfService.backgroundColor = color.grayColor
        
        if (self.chache.object(forKey: imageName as AnyObject) != nil){
            cell.imgOfService.image = self.chache.object(forKey:imageName as AnyObject) as? UIImage
        }else{
            if Validation1.checkNotNullParameter(checkStr: imgUrl!) == false {
                Alamofire.request(imgUrl!).responseImage{ response in
                    if let image = response.result.value{
                        cell.imgOfService.image = image
                        self.chache.setObject(image, forKey: imageName as AnyObject)
                    }else {
                        cell.imgOfService.backgroundColor = color.grayColor
                    }
                }
            }else{
                cell.imgOfService.backgroundColor = color.grayColor
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dicOfData = arryOfData[indexPath.row] as! [String:Any]
        self.appDelegate.postBookingReqDic["chilServicedId"] = String(dicOfData["child_id"] as! Int)
        self.appDelegate.postBookingReqDic["serviceInfo"] = String(dicOfData["child_name"] as! String)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceProviderList") as! ServiceProviderList
        vc.childServicedId = String(dicOfData["child_id"] as! Int)
        vc.serviceTitle = (dicOfData["child_name"] as? String)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let type =  UserDefaults.standard.value(forKey: "Device") as? String
        if type! == "iPad" {
            //let width = (UIScreen.main.bounds.size.width - 20/2)
            //print("width cell ",width)
            return CGSize(width: (self.view.frame.size.width/2) - 20, height:(self.view.frame.size.width/2) - 20)
        }else {
            //let width = (UIScreen.main.bounds.size.width - 15/2)
            return CGSize(width: (self.view.frame.size.width/2) - 20, height:(self.view.frame.size.width/2) - 20)
        }
    }
}
