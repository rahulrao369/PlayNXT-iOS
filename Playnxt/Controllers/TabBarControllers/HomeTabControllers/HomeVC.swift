//
//  HomeVC.swift
//  Playnxt
//
//  Created by cano on 20/05/22.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class HomeVC: UIViewController , GADBannerViewDelegate{
    
    //MARK:- IBOutlets
    @IBOutlet weak var frndCollcetionVieww: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var lblFrnd: UILabel!
    //MARK: - Variables
    
    let frnd : [FriendsImage] = [FriendsImage(img: "frnd_img"),FriendsImage(img: "frnd_img1"),FriendsImage(img: "frnd_img"),FriendsImage(img: "frnd_img1"),FriendsImage(img: "frnd_img")]
    var homeData : HomeData?
    var pro : HomeProfile?
    var frndData = [HomeFollowing]()
    var buttonData : HomeButtonData?
    var btnResponse : HomeButton?
    var strToken:String?
    var passStatus:String?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    //MARK: - Viewdidloads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frndCollcetionVieww.dataSource = self
        frndCollcetionVieww.delegate = self
        btnSeeAll.isHidden = false
        lblFrnd.isHidden = false
        bannerView.adUnitID = Constant.banner_UnitId
          bannerView.rootViewController = self
    }
   
    override func viewWillTransition(to size: CGSize,
                             with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to:size, with:coordinator)
       coordinator.animate(alongsideTransition: { _ in
         self.loadBannerAd()
       })
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBannerAd()
        apiSubscription()
        Singleton.sharedInstance.pass_status?.removeAll()
        print("subscribed-----",UserDefaults.standard.bool(forKey: "SUBSCRIBED"))
        apiHome()
        
        let Subscribe = UserDefaults.standard.bool(forKey: "SUBSCRIBED")
        
        if Subscribe == true {
            bannerView.isHidden = true
        }else {
            bannerView.isHidden  = false
        }
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
    func apiHome(){
        showActivity(myView: self.view, myTitle: "Loading...")
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Home, method: .post, parameter: nil, objectClass: HomeResponse.self, requestCode: Constant.URL_CONSTANT.Home, userToken: nil) { [self] response in
            if response.status == true {
                self.pro = response.data.profile
                self.frndData = response.data.following
                print("Response",response)
                self.removeActivity(myView: self.view)
                self.homeData = response.data
                if frndData.isEmpty {
                    btnSeeAll.isHidden = true
                    lblFrnd.isHidden = true
                }else {                     btnSeeAll.isHidden = false
                    lblFrnd.isHidden = false
                }
                self.lblName.text = "Hi, " + (pro?.name ?? "")
                let urlBanner = URL(string: Constant.ImageUrl + (pro?.image ?? ""))
                self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
                Singleton.sharedInstance.profileImg = pro?.image ?? ""
                self.frndCollcetionVieww.reloadData()
            }else {
                print("message",response.message)
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
                UserDefaults.standard.setValue(response.data.subscribed, forKey: "SUBSCRIBED")

            }else {
                print("message",response.message)
            }
        }
    }
    
    //MARK: -
    
    func apiHomeButton(){
        
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Home_Button, method: .post, parameter: nil, objectClass: HomeButton.self, requestCode: Constant.URL_CONSTANT.Home_Button, userToken: nil) { [self] response  in
            if response.status == true {
                print("response",response)
                self.buttonData = response.data
                self.btnResponse = response.self
                if btnResponse?.presence == 1 {
                    let vc = storyboard!.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    let vc = storyboard!.instantiateViewController(withIdentifier: "XboxGameInfoVC") as! XboxGameInfoVC
                    vc.gameId = buttonData?.gameID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else {
                print("message",response.message)
            }
        }
    }
    
    
    
    //MARK: - Button Action
    @IBAction func btnSeeAll(_ sender: Any) {
        tabBarController?.selectedIndex = 3
        Singleton.sharedInstance.pass_status = "SeeAll"
        print("PassStatus----",Singleton.sharedInstance.pass_status ?? "")
        
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnProfile(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        vc.screenType = "Home"
        Singleton.sharedInstance.homeResponse = vc.screenType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnPlay(_ sender: Any) {
        //tabBarController?.selectedIndex = 1
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        apiHomeButton()
    }
}
//MARK: - Extension

extension HomeVC: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frndData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = frndCollcetionVieww.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionCell
        let data = frndData[indexPath.row]
        let urlBanner = URL(string: Constant.ImageUrl + ( data.image ))
        cell.imgFrnd.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgFrnd.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let  viewController = self.storyboard?.instantiateViewController(withIdentifier: "FriendProfileVC") as! FriendProfileVC
        viewController.userID = frndData[indexPath.row].userID
        
        Singleton.sharedInstance.frndUserID = frndData[indexPath.row].userID
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
//MARK: - CollectionView Class

class HomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgFrnd: DesignImage!
    
}
