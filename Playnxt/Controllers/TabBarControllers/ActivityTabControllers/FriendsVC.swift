//
//  FriendsVC.swift
//  Playnxt
//
//  Created by CP on 17/06/22.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class FriendsVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: - Variable
    var list = [FriendCapsul]()
    var userId:Int?
    var LikeUnlike:String?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // categoryTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        bannerView.adUnitID = Constant.banner_UnitId
          bannerView.rootViewController = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // NotificationCenter.default.addObserver(self, selector: #selector(notification(_:)), name: Notification.Name("tap"), object: nil)
        apiFriendList()
        loadBannerAd()
        let Subscribe = UserDefaults.standard.bool(forKey: "SUBSCRIBED")
        
        if Subscribe == true {
            bannerView.isHidden = true
        }else {
            bannerView.isHidden   = false
        }    }
    
    override func viewWillTransition(to size: CGSize,
                             with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to:size, with:coordinator)
       coordinator.animate(alongsideTransition: { _ in
         self.loadBannerAd()
       })
     }
    //MARK:- Function
    
    /* @objc func notification(_ notification:Notification) {
     self.tblHeight.constant = CGFloat((self.list.count * 170))
     }*/
    
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //        self.tblViewHeight.constant = self.categoryTable.contentSize.height
    //    }
    
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
    func apiFriendList(){
        showActivity(myView: self.view, myTitle: "Loading...")
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_Friend_List, method: .post, parameter: nil, objectClass: FriendList.self, requestCode: Constant.URL_CONSTANT.Get_Friend_List, userToken: nil) { response in
            if response.status == true {
                if response.data.capsul.isEmpty {
                    self.friendTableView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    print("Response---",response)
                    self.list = response.data.capsul
                    //   self.tblHeight.constant = CGFloat((self.list.count * 170))
                    self.friendTableView.reloadData()
                }
                self.removeActivity(myView: self.view)
            }else {
                print("Message-",response.message)
            }
        }
    }
    
   
    
    //MARK: -
    func apiUnFollow(userId:Int){
        
        let param:[String:Any] = ["user_id":userId ]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Unfollow, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Unfollow, userToken: nil) { response in
            if response.status == true {
                print("Response---",response)
                self.apiFriendList()
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
                self.apiFriendList()
            }else {
                print("Message-",response.message)
            }
        }
    }
}

//MARK: - Extension

extension FriendsVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendTableView.dequeueReusableCell(withIdentifier: "cell") as! FriendTableCell
        let data = list[indexPath.row]
        cell.lblName.text = list[indexPath.row].userName
        if data.addedTime == "" || (data.title) + (data.listName) == "" {
            cell.viewHide.isHidden = true
            cell.lblGame.isHidden = true
            cell.lblTime.isHidden = true
            cell.lblTimeStamp.isHidden = true
            cell.viewHeight.constant = 0
            cell.mainViewHeight.constant = 0
        }else {
        cell.viewHide.isHidden = false
        cell.lblGame.isHidden = false
        cell.lblTime.isHidden = false
        cell.lblTimeStamp.isHidden = false
        cell.viewHeight.constant = 50
            cell.mainViewHeight.constant = 145
            cell.lblTime.text = data.addedTime
            cell.lblGame.text = "Added " + (data.title) + " to " + (data.listName)
       
        }
        
        cell.lblLike.text = "\(list[indexPath.row].total_like)"
        if data.like == 0 {
            cell.btnLike.setImage(UIImage(named: "Unlike_btn"), for: .normal)
        }else {
            cell.btnLike.setImage(UIImage(named: "heart"), for: .normal)
        }
        let urlBanner = URL(string: Constant.ImageUrl + (self.list[indexPath.row].userImg))
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
        if sender.isSelected == true {
            LikeUnlike = "like"
            apiLikeUnlike()
        }else {
            LikeUnlike = "unlike"
            apiLikeUnlike()
        }
    }
    @objc func follow(sender: UIButton) {
        print("UserID----",userId ?? 0)
        apiUnFollow(userId: list[sender.tag].userID)
        
    }
    /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 180
     }*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "FriendProfileVC") as! FriendProfileVC
        Singleton.sharedInstance.frndUserID = list[indexPath.row].userID
        vc.userID = list[indexPath.row].userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = list[indexPath.row]
        
        if data.addedTime == "" || (data.title) + (data.listName) == "" {
        return 120
        }else {
            return 170
        }
    }
    
    /* override func viewDidLayoutSubviews() {
     // super.viewDidLayoutSubviews()
     self.tblHeight.constant = CGFloat((list.count * 180))
     }*/
    
}
//MARK: -

class FriendTableCell:UITableViewCell {
    
    @IBOutlet weak var imgProfile: DesignImage!
    @IBOutlet weak var lblGame: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var btnChange: RoundButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewHide: UIView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
}

