//
//  GameInfoVC.swift
//  Playnxt
//
//  Created by cano on 23/05/22.
//

import UIKit
import Cosmos
import SDWebImage
import Alamofire
import GoogleMobileAds

class GameInfoVC: UIViewController {
    
    //MARK: - Iboutlets
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblPlatform: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var gameInfo : FriendGameInfoCapsul?
    var info:FriendGameInfoData?
    var gameId:Int?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    var remaning_backlog:Int?
    let Subscribe = UserDefaults.standard.bool(forKey: "SUBSCRIBED")
    //MARK: - viewdidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.adUnitID = Constant.banner_UnitId
        bannerView.rootViewController = self
        // Do any additional setup after loading the view.
        // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiGameInfo()
        apiSubscription()
        loadBannerAd()
        
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
    
    func apiGameInfo(){
        let param : [String:Any] = ["game_id":gameId ?? 0,
                                    "game_view":"user"]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Game_Info, method: .post, parameter: param, objectClass: FriendGameInfo.self, requestCode: Constant.URL_CONSTANT.Game_Info, userToken: nil) { [self] response in
            if response.status == true{
                print("response-----",response)
                self.gameInfo = response.data.capsul
                self.info = response.data
                self.lblName.text = gameInfo?.gTitle
                self.lblDescription.text = gameInfo?.capsulDescription ?? ""
                //self.lblDescription.attributedText = htmlToString(strDescription: gameInfo?.capsulDescription ?? "")
                self.lblCategory.text = gameInfo?.genre
                self.lblPlatform.text = gameInfo?.platform
                self.viewRating.rating = gameInfo?.rating ?? 0.0
                self.lblRating.text = "\(gameInfo?.rating ?? 0.0)"
                print("Rating----",gameInfo?.rating ?? 0.0)
                Singleton.sharedInstance.gameRating = gameInfo?.rating
                Singleton.sharedInstance.gameName = gameInfo?.gTitle
                
                if gameInfo?.image_type == "thirdparty" {
                    let urlBanner = URL(string: (gameInfo?.gImage ?? ""))
                    self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "splash_icon-1"), options: .refreshCached, context: nil)
                }else {
                    let urlBanner = URL(string: Constant.ImageUrl + (self.gameInfo?.gImage ?? ""))
                    self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "splash_icon-1"), options: .refreshCached, context: nil)
                }
            } else
            {
                print("message--",response.message)
            }
        }
    }
    //MARK: -
    
    func apiSubscription(){
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Check_Subscription, method: .post, parameter: nil, objectClass: CheckSubsRespo.self, requestCode: Constant.URL_CONSTANT.Check_Subscription, userToken: nil) { response  in
            if response.status == true {
                print("Response",response)
                self.subs = response.data
                self.commonSub = response.data.subscription
            }else {
                print("message",response.message)
            }
        }
    }
    //MARK: -
    
    func apiAddFriendGame(){
        //showActivity(myView: self.view, myTitle: "Loading...")
        let parameters:[String:Any] = ["game_id": gameId ?? "",
                                       "category":Singleton.sharedInstance.category_type ?? "",
                                       "list_name":Singleton.sharedInstance.list_Name ?? "",
                                       "list_id": Singleton.sharedInstance.List_id ?? 0,
                                       "rate": "\(Singleton.sharedInstance.gameRating ?? 0.0)" ]
        
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Add_Friend_Game, method: .post, parameter: parameters, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Add_Friend_Game, userToken: nil) { response  in
            if response.status == true {
                print("response",response)
                self.showAlert(message: "Game added Sucessfully")
            }else {
                print("message",response.message)
            }
        }
    }
    
    //MARK: - function
    
    /* @objc func shareTapped() {
     guard let image = imgProfile.image?.jpegData(compressionQuality: 0.8) else {
     print("No image found")
     return
     }
     
     let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
     vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
     present(vc, animated: true)
     }*/
    
    //MARK: - Button Action
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //    @IBAction func btnShare(_ sender: Any) {
    //        shareTapped()
    //    }
    
    @IBAction func btnAddBackLog(_ sender: Any) {
        if Subscribe == false {
            if subs?.freeBacklog == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryListPopupVC") as! CategoryListPopupVC
                vc.modalTransitionStyle = .coverVertical
                vc.Controller = self
                vc.categoryType = "backlog"
                vc.screnType = "GameInfo"
                Singleton.sharedInstance.category_type = vc.categoryType
                self.present(vc, animated: true)
            }else {
                let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if Subscribe == true {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryListPopupVC") as! CategoryListPopupVC
            vc.modalTransitionStyle = .coverVertical
            vc.Controller = self
            vc.categoryType = "backlog"
            vc.screnType = "GameInfo"
            Singleton.sharedInstance.category_type = vc.categoryType
            self.present(vc, animated: true)
        }else {
            let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnWishList(_ sender: Any) {
        
        if subs?.subscribed == "Yes" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WishlistCreatePopupVc") as! WishlistCreatePopupVc
            vc.modalTransitionStyle = .coverVertical
            vc.Controller = self
            vc.categoryType = "wishlist"
            vc.screnType = "WishlistGameInfo"
            Singleton.sharedInstance.category_type = vc.categoryType
            self.present(vc, animated: true)
        }else {
            let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
/* @IBOutlet weak var imgClick: UIImageView! {
 
 didSet {
 let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
 imgClick.addGestureRecognizer(imageTapGestureRecognizer)
 imgClick.isUserInteractionEnabled = true
 }
 }
 @objc func imageTapped() {
 let vc = storyboard?.instantiateViewController(withIdentifier: "PopupImageVC") as? PopupImageVC
 vc?.modalPresentationStyle = .overFullScreen
 vc?.modalTransitionStyle = .crossDissolve
 vc?.image = imgProfile.image
 present(vc!, animated: true)
 }*/

