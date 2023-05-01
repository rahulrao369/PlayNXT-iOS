//
//  UserFollowerVC.swift
//  Playnxt
//
//  Created by CP on 20/06/22.
//

import UIKit
import SDWebImage
import GoogleMobileAds


class UserFollowerVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
    //MARK: - variable
    var follower = [Follow]()
    var userId:Int?
    var followerData : Follower?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        activityTableView.dataSource = self
        activityTableView.delegate = self
        bannerView.adUnitID = Constant.banner_UnitId
          bannerView.rootViewController = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiGetProfile()
        loadBannerAd()
        
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
    
    //MARK: -  Api Calling
    
    func apiGetProfile(){
        let param:[String:Any] = [:]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_My_Profile, method: .post, parameter: param, objectClass: GetMyProfile.self, requestCode: Constant.URL_CONSTANT.Get_My_Profile, userToken: nil) { response in
            if response.status == true {
                if response.data.follower.isEmpty{
                    self.activityTableView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    print("response-------",response)
                    self.follower = response.data.follower
                    self.activityTableView.reloadData()
                }
            }else {
                print("message-----",response.message)
            }
        }
    }
    
    
    
    //MARK: -
    func apiFollow(userId:Int){
        
        let param:[String:Any] = ["user_id":userId ]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.follow_Add_Friend, method: .post, parameter: param, objectClass: FollowUnfollow.self, requestCode: Constant.URL_CONSTANT.follow_Add_Friend, userToken: nil) { response in
            if response.status == true {
                print("Response---",response)
                self.followerData = response.data.follower
                self.apiGetProfile()
            }else {
                print("Message-",response.message)
            }
        }
    }
    //MARK: -
    func apiUnFollow(userId:Int){
        let param:[String:Any] = ["user_id":userId]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Unfollow, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Unfollow, userToken: nil) { response in
            if response.status == true {
                print("Response---",response)
                self.apiGetProfile()
            }else {
                print("Message-",response.message)
            }
        }
    }
}
//MARK: - Extension

extension UserFollowerVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("follower list count------",follower.count)
        return follower.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activityTableView.dequeueReusableCell(withIdentifier: "cell") as! UserFollowerCell
        let data = follower[indexPath.row]
        cell.lblName.text = data.name
        if data.is_followed == 0 {
            cell.btnChange.isSelected = false
            // cell.btnChange.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4196078431, blue: 0.262745098, alpha: 1)
            //              cell.btnChange.setTitle("Follow", for: .normal)
        }else {
            cell.btnChange.isSelected = true
            //cell.btnChange.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
            //              cell.btnChange.setTitle("Unfollow", for: .normal)
        }
        cell.lblMututal.text = String(data.mutual_friend)
        let urlBanner = URL(string: Constant.ImageUrl + (data.image))
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
        cell.btnChange.tag = indexPath.row
        cell.btnChange.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.btnMsg.tag = indexPath.row
        cell.btnMsg.addTarget(self, action: #selector(msgButtonAction(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func connected(sender: UIButton){
        print("UserID----",userId ?? 0)
        let path = IndexPath(item: sender.tag, section: 0)
        let cell = self.activityTableView.cellForRow(at: path) as? UserFollowerCell
        sender.isSelected.toggle()
        if sender.isSelected == true {
            apiFollow(userId: follower[sender.tag].userID)
            cell?.btnChange.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
        }else
        {
            cell?.btnChange.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4196078431, blue: 0.262745098, alpha: 1)
            apiUnFollow(userId: follower[sender.tag].userID)
        }
        //  apiFollow(userId: follower[sender.tag].userID)
        
    }
    @objc func msgButtonAction(sender: UIButton){
        let vc = storyboard!.instantiateViewController(withIdentifier: "ChatWebViewVC") as! ChatWebViewVC
        let data = follower[sender.tag]
        Singleton.sharedInstance.reciver_id = data.userID
        vc.frndName = data.name
        vc.img = data.image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let  viewController = self.storyboard?.instantiateViewController(withIdentifier: "FriendProfileVC") as! FriendProfileVC
        viewController.userID = follower[indexPath.row].userID
        Singleton.sharedInstance.frndUserID = follower[indexPath.row].userID
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 130
     }
     override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     self.tblHeight.constant = CGFloat((follower.count * 130))
     }*/
}

//MARK: -

class UserFollowerCell:UITableViewCell {
    
    @IBOutlet weak var imgProfile: DesignImage!
    @IBOutlet weak var lblbFriend: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMututal: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var btnMsg: UIButton!
}

