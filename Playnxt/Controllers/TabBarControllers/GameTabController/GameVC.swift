//
//  GameVC.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class GameVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var dataCollectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var lblBacklogCount: UILabel!
    @IBOutlet weak var lblRecent: UILabel!
    @IBOutlet weak var lblWishCount: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var btnSubs1: RoundButton!
    @IBOutlet weak var btnSubs2: RoundButton!
    @IBOutlet weak var btnSubs3: RoundButton!
    
    //MARK: - Variables
    
    var arrRecent = [RecentGameCapsul]()
    var recent : RecentGameData?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    let Subscribe = UserDefaults.standard.bool(forKey: "SUBSCRIBED")
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        dataCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        bannerView.adUnitID = Constant.banner_UnitId
          bannerView.rootViewController = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiRecentGame()
        apiSubscription()
        loadBannerAd()
        if subs?.subscribed == "Yes" {
            btnSubs1.isHidden = true
            btnSubs2.isHidden = true
            btnSubs3.isHidden = true
            //bannerView.isHidden = true
        }else {
            btnSubs1.isHidden = false
            btnSubs2.isHidden = false
            btnSubs3.isHidden = false
            //bannerView.isHidden = false
        }
        
        if Subscribe == true {
            bannerView.isHidden = true
        }else {
            bannerView.isHidden = false
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
    
    func apiRecentGame(){
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Recent_Game, method: .post, parameter: nil, objectClass: RecentGame.self, requestCode: Constant.URL_CONSTANT.Recent_Game, userToken: nil) { [self] response  in
            if response.status == true{
                print( "Response--",response)
                self.arrRecent = response.data.capsul
                self.recent = response.data
                if arrRecent.isEmpty == true {
                    lblRecent.isHidden = true
                }else {
                    lblRecent.isHidden = false
                }
                self.lblWishCount.text = "(\(response.data.wishCount))"
                self.lblBacklogCount.text = "(\(response.data.backlogCount))"
                self.dataCollectionView.reloadData()
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
    
    //MARK: - Button Action
    
    @IBAction func btnBackLog(_ sender: Any) {
        /*if subs?.subscribed == "No" {
            if subs?.freeBacklog == 1 {
                let vc = storyboard!.instantiateViewController(withIdentifier: "BackLogVC") as! BackLogVC
                //vc.total_backlog = commonSub?.totalBacklog
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if subs?.subscribed == "Yes"{
            let vc = storyboard!.instantiateViewController(withIdentifier: "BackLogVC") as! BackLogVC
           // vc.total_backlog = commonSub?.totalBacklog
            self.navigationController?.pushViewController(vc, animated: true)
        }else  {
            let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        let vc = storyboard!.instantiateViewController(withIdentifier: "BackLogVC") as! BackLogVC
        Singleton.sharedInstance.remaning = subs?.freeBacklog
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnWishlist(_ sender: Any) {
        if Subscribe == true {
            let vc = storyboard!.instantiateViewController(withIdentifier: "WishlistVC") as! WishlistVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else{
            let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnCalender(_ sender: Any) {
        if Subscribe == true {
            let vc = storyboard!.instantiateViewController(withIdentifier: "CalenderViewVC") as! CalenderViewVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else  {
            let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnStats(_ sender: Any) {
        if Subscribe == true {
            
            let vc = storyboard!.instantiateViewController(withIdentifier: "StatusVC") as! StatusVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK: - Function
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.collectionHeight.constant = self.dataCollectionView.contentSize.height
    }
}

//MARK: - Extension

extension GameVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrRecent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dataCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GameCollectionCell
        let recent = arrRecent[indexPath.row]
        cell.lblGameName.text = recent.title
        cell.viewController = self
        
        if recent.image_type == "thirdparty"{
            let urlBanner = URL(string: (recent.gameImage))
            cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "image"), options: .refreshCached, context: nil)
        }else {
            let urlBanner = URL(string: Constant.ImageUrl + (recent.gameImage))
            cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "image"), options: .refreshCached, context: nil)
        }
               
        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func connected(sender: UIButton){
        let vc = storyboard!.instantiateViewController(withIdentifier: "XboxGameInfoVC") as! XboxGameInfoVC
        vc.gameId = arrRecent[sender.tag].gameID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Extension

extension GameVC:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth =  collectionView.frame.size.width
        return CGSize(width: collectionWidth/2, height: 266)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
}

//MARK: - CollectionView Class

class GameCollectionCell:UICollectionViewCell{
    @IBOutlet weak var imgGame: DesignImage!
    @IBOutlet weak var lblGameName: UILabel!
    @IBOutlet weak var btnView: UIButton!
    var viewController:GameVC?
    
}
