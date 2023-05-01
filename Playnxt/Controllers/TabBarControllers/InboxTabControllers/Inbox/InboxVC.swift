//
//  InboxVC.swift
//  Playnxt
//
//  Created by cano on 20/05/22.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class InboxVC: UIViewController {
    
    @IBOutlet weak var inboxTableView: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    var inbox : ChatListData?
    var list = [Inbox]()
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //inboxTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        let urlBanner = URL(string: Constant.ImageUrl + (Singleton.sharedInstance.profileImg ?? ""))
        self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
        bannerView.adUnitID = Constant.banner_UnitId
          bannerView.rootViewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiChatList()
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
    
    /*  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
     self.tblHeight.constant = self.inboxTableView.contentSize.height*/
    //}
    
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
    
    
    
    //MARK: - api calling
    
    func apiChatList(){
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Chat_List, method: .post, parameter: nil, objectClass: ChatListResponse.self, requestCode: Constant.URL_CONSTANT.Chat_List, userToken: nil) { response  in
            if response.status == true {
                if response.data.inbox.isEmpty{
                    self.inboxTableView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    print("response",response)
                    self.list = response.data.inbox
                    self.inbox = response.data
                    self.inboxTableView.reloadData()
                }
            }else {
                print("message",response.message)
            }
        }
    }
    
   
    
    //MARK: - Button Action
    
    @IBAction func btnProfile(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - Extension

extension InboxVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = inboxTableView.dequeueReusableCell(withIdentifier: "cell") as! InboxTableCell
        let data = list[indexPath.row]
        cell.lblName.text = data.name
        cell.lblMsg.text = data.message
        // cell.lblDate.text = data.time
        let urlBanner = URL(string: Constant.ImageUrl + (data.image))
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
        return cell
    }
    override func viewDidLayoutSubviews() {
        // self.tblHeight.constant = (8 * 130) + 85
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "ChatWebViewVC") as! ChatWebViewVC
        let data = list[indexPath.row]
        Singleton.sharedInstance.reciver_id = data.id
        vc.frndName = data.name
        vc.img = data.image
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: -

class InboxTableCell:UITableViewCell {
    @IBOutlet weak var imgProfile: DesignImage!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
}
