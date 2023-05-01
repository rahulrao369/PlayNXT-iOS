//
//  CommunityVC.swift
//  Playnxt
//
//  Created by CP on 17/06/22.
//

import UIKit
import SDWebImage
import Alamofire
import GoogleMobileAds

class CommunityVC: UIViewController {
    
 
    //MARK: - IBOutlets
    @IBOutlet weak var communityTableData: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: - Variable
    
    var list = [CommunityCapsul]()
    var followerData : Follower?
    var userId:Int?
    var LikeUnlike:String?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        bannerView.adUnitID = Constant.banner_UnitId
          bannerView.rootViewController = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBannerAd()
        apiCommunity()
        
        let Subscribe = UserDefaults.standard.bool(forKey: "SUBSCRIBED")
        
        if Subscribe == true {
            bannerView.isHidden = true
        }else {
            bannerView.isHidden   = false
        }
    }
    
    override func viewWillTransition(to size: CGSize,
                             with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to:size, with:coordinator)
       coordinator.animate(alongsideTransition: { _ in
         self.loadBannerAd()
       })
     }
    
    //MARK: - Function
    
    func loadBannerAd() {
        let frame = { () -> CGRect in
         
          if #available(iOS 11.0, *) {
            return view.frame.inset(by: view.safeAreaInsets)
          } else {
            return view.frame
          }
        }()
        let viewWidth = frame.size.width
        
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

        bannerView.load(GADRequest())
      }
    
    
    //MARK: - Api Calling
    func apiCommunity(){
        showActivity(myView: self.view, myTitle: "Loading...")
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Community_List, method: .post, parameter: nil, objectClass: Community.self, requestCode: Constant.URL_CONSTANT.Community_List, userToken: nil) { response in
            if response.status == true {
                if response.data.capsul.isEmpty {
                    self.communityTableData.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    print("Response---",response)
                    self.list = response.data.capsul
                    self.communityTableData.reloadData()
                }
                self.removeActivity(myView: self.view)
            }else {
                print("Message-",response.message)
            }
        }
    }
    
   
    //MARK: -
    func apiLikeUnlike(){
        
        let param:[String:Any] = ["user_id":userId ?? 0,
                                  "status": LikeUnlike ?? ""]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Like_Unlike, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Like_Unlike, userToken: nil) { response in
            if response.status == true {
                print("Response---",response)
                self.apiCommunity()
                self.communityTableData.reloadData()
            }else {
                print("Message-",response.message)
            }
        }
    }
    
    //MARK: -
    
    func apiFollow(userID:Int){
        
        let param:[String:Any] = ["user_id":userID]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.follow_Add_Friend, method: .post, parameter: param, objectClass: FollowUnfollow.self, requestCode: Constant.URL_CONSTANT.follow_Add_Friend, userToken: nil) { response in
            if response.status == true {
                print("Response---",response)
                self.followerData = response.data.follower
                self.apiCommunity()
                self.communityTableData.reloadData()
            }else {
                print("Message-",response.message)
            }
        }
    }
    
}

//MARK: - Extension

extension CommunityVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = communityTableData.dequeueReusableCell(withIdentifier: "cell") as! CommunityTableCell
        let data = list[indexPath.row]
        cell.lblName.text = list[indexPath.row].name
        cell.lblTime.text = data.addedTime
        
       /* if data.title == "" || data.listName == "" {
            cell.lblGame.isHidden = true
            cell.lblAddedTime.isHidden = true
        }else {
            cell.lblGame.isHidden = false
            cell.lblAddedTime.isHidden = false
        }*/
        
        cell.lblGame.text = "Added " + (data.title) + " to " + (data.listName)
        if data.like == 0 {
            cell.btnLike.setImage(UIImage(named: "Unlike_btn"), for: .normal)
        }else {
            cell.btnLike.setImage(UIImage(named: "heart"), for: .normal)
        }
        cell.lblLike.text = "\(data.total_like)"
        let urlBanner = URL(string: Constant.ImageUrl + (self.list[indexPath.row].image))
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.btnChange.tag = indexPath.row
        cell.btnChange.addTarget(self, action: #selector(follow(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func connected(sender: UIButton){
        sender.isSelected.toggle()
        userId = list[sender.tag].userID
        print("UserID----",userId ?? 0)
        if sender.isSelected == true{
            LikeUnlike = "like"
            print("Like----",LikeUnlike ?? "")
            apiLikeUnlike()
        }else {
            LikeUnlike = "unlike"
            print("Unlike----",LikeUnlike ?? "")
            apiLikeUnlike()
        }
        
    }
    @objc func follow(sender: UIButton){
        // let path = IndexPath(item: sender.tag, section: 0)
        // let cell = self.communityTableData.cellForRow(at: path) as? CommunityTableCell
        // sender.isSelected.toggle()
        //  userId = list[sender.tag].userID
        // print("UserID----",userId ?? 0)
        apiFollow(userID: list[sender.tag].userID)
        //        if sender.isSelected == true {
        //            cell?.btnChange.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4196078431, blue: 0.262745098, alpha: 1)
        //
        //
        //        }else
        //        {
        //            cell?.btnChange.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
        //        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "FriendProfileVC") as! FriendProfileVC
        vc.screenType = "Activity"
        Singleton.sharedInstance.response = vc.screenType
        Singleton.sharedInstance.frndUserID = list[indexPath.row].userID
        vc.userID = list[indexPath.row].userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: -
protocol TableViewCellDelegate: AnyObject {
    func levelTableViewCell(_ levelTableViewCell: CommunityTableCell, didEndEditingWithText: String?)
}
class CommunityTableCell:UITableViewCell {
    @IBOutlet weak var imgProfile: DesignImage!
    @IBOutlet weak var lblGame: UILabel!
    @IBOutlet weak var lblAddedTime: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnChange: RoundButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblName: UILabel!
    var delegate: TableViewCellDelegate?
    
}
