//
//  DiscoverVC.swift
//  Playnxt
//
//  Created by cano on 20/05/22.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class DiscoverVC: UIViewController , GADBannerViewDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var dataCollectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: - Variables
    
    var game : [GameDetail] = [GameDetail(name: "GTA Vice City", img: "Discover_icon1"),GameDetail(name: "GTA Vice City", img: "discover_icon-1"),GameDetail(name: "GTA Vice City", img: "Discover_icon1"),GameDetail(name: "GTA Vice City", img: "discover_icon-1"),GameDetail(name: "GTA Vice City", img: "Discover_icon1"),GameDetail(name: "GTA Vice City", img: "discover_icon-1"),GameDetail(name: "GTA Vice City", img: "Discover_icon1"),GameDetail(name: "GTA Vice City", img: "discover_icon-1")]
    var arrStafPics = [StaffPicksCapsul]()
    var buyNowLink:String?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
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
        Singleton.sharedInstance.pass_status?.removeAll()
        loadBannerAd()
        apiStaffPicks()
        let Subscribe = UserDefaults.standard.bool(forKey: "SUBSCRIBED")
        
        if Subscribe == true {
            bannerView.isHidden = true
        }else {
            bannerView.isHidden   = false
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
    
    //MARK: -
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if (NSURL(string: urlString) != nil) {
                return true
            }
        }
        return false
    }
    
    //MARK: - api calling
    
    func apiStaffPicks(){
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Staff_picks, method: .post, parameter: nil, objectClass: StaffPicks.self, requestCode: Constant.URL_CONSTANT.Staff_picks, userToken: nil) { response in
            if response.status == true{
                print("Response---",response)
                if response.data.capsul.isEmpty {
                    self.dataCollectionView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    self.arrStafPics = response.data.capsul
                    //self.buyNowLink = response.data.affiliateLink
                    self.dataCollectionView.reloadData()
                }
            }else {
                print("message",response.message)
            }
        }
    }
    
   
    //MARK: - Button Action
    
    @IBAction func btnSearch(_ sender: Any) {
        
    }
    
}
//MARK: - Extension

extension DiscoverVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrStafPics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dataCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DiscoverCell
        let data = arrStafPics[indexPath.row]
        cell.lblGameName.text = data.title
        let urlBanner = URL(string: Constant.ImageUrl + "/" + (data.image ))
        print("urlBanner...........",urlBanner)
        cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "img"), options: .refreshCached, context: nil)
        cell.btnBuy.tag = indexPath.row
        buyNowLink = data.affiliation
        cell.btnBuy.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func connected(sender: UIButton){
        let data = arrStafPics[sender.tag]
        let vc = storyboard!.instantiateViewController(withIdentifier:  "StaffPicksViewVC") as! StaffPicksViewVC
        vc.descrip = data.capsulDescription
        vc.img = data.image
        vc.gameTitle = data.title
        vc.link = data.affiliation
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
   /* func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(withIdentifier:  "GameInfoVC") as! GameInfoVC
        vc.gameId = arrStafPics[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }*/
}


//MARK: - Extension

extension DiscoverVC:UICollectionViewDelegateFlowLayout {
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

class DiscoverCell:UICollectionViewCell{
    @IBOutlet weak var imgGame: DesignImage!
    @IBOutlet weak var lblGameName: UILabel!
    @IBOutlet weak var btnBuy: RoundButton!
}
