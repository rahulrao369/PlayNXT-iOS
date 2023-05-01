//
//  UserGameVC.swift
//  Playnxt
//
//  Created by CP on 20/06/22.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class UserGameVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var activityCollection: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: - variable
    var games = [Game]()
    var frndGame = [FriendGame]()
    var screenType:String?
    var userID:Int?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    //MARK: - viewdidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        activityCollection.dataSource = self
        activityCollection.delegate = self
        apiGetProfile()
        
        bannerView.adUnitID = Constant.banner_UnitId
          bannerView.rootViewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                if response.data.games.isEmpty{
                    self.activityCollection.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    print("response-------",response)
                    self.games = response.data.games
                    self.activityCollection.reloadData()
                }
            }else {
                print("message-----",response.message)
            }
        }
    }
    
    
}


//MARK: - Extension

extension UserGameVC : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = activityCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserGameCollectionCell
        let data = games[indexPath.row]
        cell.lblGameName.text = data.title
        
        if data.image_type == "thirdparty"{
            let urlBanner = URL(string: (data.image))
            cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "splash_icon-1"), options: .refreshCached, context: nil)
        }else {
            let urlBanner = URL(string: Constant.ImageUrl + (data.image))
            cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "splash_icon-1"), options: .refreshCached, context: nil)
        }
        
        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action: #selector(GameAction(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func GameAction(sender: UIButton){
        let vc = storyboard!.instantiateViewController(withIdentifier: "XboxGameInfoVC") as! XboxGameInfoVC
        vc.gameId = games[sender.tag].gameID
        print("GameId----",games[sender.tag].gameID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Extension

extension UserGameVC:UICollectionViewDelegateFlowLayout {
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

class UserGameCollectionCell:UICollectionViewCell{
    @IBOutlet weak var imgGame: DesignImage!
    @IBOutlet weak var lblGameName: UILabel!
    @IBOutlet weak var btnView: UIButton!
}
