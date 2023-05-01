//
//  StaffPicksViewVC.swift
//  Playnxt
//
//  Created by CP on 11/11/22.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class StaffPicksViewVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblGame: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: - Variable
    
    var img:String?
    var descrip:String?
    var gameTitle:String?
    var link:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        self.lblGame.text = gameTitle
        self.lblDescription.text = descrip
        let urlBanner = URL(string: Constant.ImageUrl + "/" + (img ?? ""))
        imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "img"), options: .refreshCached, context: nil)
        loadBannerAd()
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

    //MARK: -  Button action
    
    @IBAction func btnBack(_ sender: Any) {
    
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBuy(_ sender: Any) {
        
        if verifyUrl(urlString: link){
            let vc = storyboard!.instantiateViewController(withIdentifier: "ContactUsWebView") as! ContactUsWebView
            vc.urlContact = link
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            showAlert(message: "Invalid URL!!")
        }
        
    }
}
