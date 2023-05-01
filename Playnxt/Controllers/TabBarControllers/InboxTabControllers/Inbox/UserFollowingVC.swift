//
//  UserFollowingVC.swift
//  Playnxt
//
//  Created by CP on 20/06/22.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class UserFollowingVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: - variable
    var following = [Following]()
    var userId:Int?
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
                if response.data.following.isEmpty {
                    self.activityTableView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    print("response-------",response)
                    self.following = response.data.following
                    self.activityTableView.reloadData()
                }
            }else {
                print("message-----",response.message)
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

extension UserFollowingVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Following list count------",following.count)
        return following.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activityTableView.dequeueReusableCell(withIdentifier: "cell") as! UserFollowingCell
        let data = following[indexPath.row]
        cell.lblName.text = data.name
        cell.lblMututal.text =  "\(data.mutual_friend)"
        let urlBanner = URL(string: Constant.ImageUrl + (data.image))
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
        cell.btnChange.tag = indexPath.row
        cell.btnChange.addTarget(self, action: #selector(follow(sender:)), for: .touchUpInside)
        cell.btnMsg.tag = indexPath.row
        cell.btnMsg.addTarget(self, action: #selector(msgAction(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func follow(sender: UIButton){
        
        print("UserID----",userId ?? 0)
        apiUnFollow(userId: following[sender.tag].userID)
        
    }
    @objc func msgAction(sender: UIButton){
        let vc = storyboard!.instantiateViewController(withIdentifier: "ChatWebViewVC") as! ChatWebViewVC
        let data = following[sender.tag]
        Singleton.sharedInstance.reciver_id = data.userID
        vc.frndName = data.name
        vc.img = data.image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "FriendProfileVC") as! FriendProfileVC
        Singleton.sharedInstance.frndUserID = following[indexPath.row].userID
        vc.userID = following[indexPath.row].userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 130
     }
     override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     self.tblHeight.constant = CGFloat((following.count * 130))
     }*/
    
}
//MARK: -

class UserFollowingCell:UITableViewCell {
    
    @IBOutlet weak var imgProfile: DesignImage!
    @IBOutlet weak var lblbFriend: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMututal: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var btnMsg: UIButton!
}
