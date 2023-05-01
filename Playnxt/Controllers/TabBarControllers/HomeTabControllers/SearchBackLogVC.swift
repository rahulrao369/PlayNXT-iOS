//
//  SearchBackLogVC.swift
//  Playnxt
//
//  Created by CP on 21/04/23.
//

import UIKit
import GoogleMobileAds
import SDWebImage

class SearchBackLogVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: - Variable
    
    let header:[String] = ["Games","Users"]
    var searchType = "game"
    var searchData = [SearchResult]()
    var search : SearchResponseData?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    let Subscribe = UserDefaults.standard.bool(forKey: "SUBSCRIBED")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView.adUnitID = Constant.banner_UnitId
        bannerView.rootViewController = self
        
        
        print("subscribe......",Subscribe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
   
    //MARK: - Api calling
    //user
   /* func apiSearching(){
        
        showActivity(myView: self.view, myTitle: "Loading...")
        
        let param:[String:Any] = ["key":txtsearch.text ?? "",
                                  "type":searchType ]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Search, method: .post, parameter: param, objectClass: SearchResponse.self, requestCode: Constant.URL_CONSTANT.Search, userToken: nil) { response  in
            if response.status == true{
                print("Response.........",response)
                self.searchData = response.data.result
                print("Count***",self.searchData.count)
                self.search = response.data
                
                self.dataTableView.reloadData()
                self.removeActivity(myView: self.view)
            }else {
                print("message",response.message)
            }
        }
    }*/
    
}
//MARK: - Extension

extension SearchBackLogVC : UITableViewDelegate,UITableViewDataSource {
    /*func numberOfSections(in tableView: UITableView) -> Int {
     return 2
     }*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("searchData............",searchData.count)
        return searchData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTableView.dequeueReusableCell(withIdentifier: "cell") as! SearchBackLogTableCell
        
        let data = searchData[indexPath.row]
        
        if data.type == "backlog" {
            cell.width.constant = 0
            cell.spacing.constant = 10
        }else {
            cell.width.constant = 60
            cell.spacing.constant = 20
        }
        
        if data.image_type == "thirdparty" {
            let urlBanner = URL(string: (data.image))
            cell.imgSearch.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgSearch.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
        }else {
            
            let urlBanner = URL(string: Constant.ImageUrl + "/" + (data.image))
            cell.imgSearch.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgSearch.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
        }

        if data.type == "backlog"{
            cell.imgSearch.isHidden = true
        }else {
            cell.imgSearch.isHidden = false
        }
        
        cell.lblName.text = data.type == "user" ? data.name : data.type == "game" ? data.title : data.listName
        
       
        
        return cell
    }
   /* func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = self.dataTableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchHeaderCell")  as! SearchHeaderCell
        //headerView.lblHeader.text = header[section]
        headerView.viewController = self
        if btnUsers.isSelected == true {
            headerView.lblHeader.text = "Users"
        }else if btnGame.isSelected == true {
            headerView.lblHeader.text = "Games"
        }else {
            headerView.lblHeader.text = "Backlog"
        }
        
        return headerView
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let gameData = searchData[indexPath.row]
        
        if gameData.type == "game" {
            let vc = storyboard!.instantiateViewController(withIdentifier: "GameInfoVC") as! GameInfoVC
            vc.gameId = gameData.gameID
            self.navigationController?.pushViewController(vc, animated: true)
        }else if gameData.type == "user" {
            let vc = storyboard!.instantiateViewController(withIdentifier: "FriendProfileVC") as! FriendProfileVC
            vc.screenType = "Activity"
            // Singleton.sharedInstance.response = vc.screenType
            // Singleton.sharedInstance.frndUserID = list[indexPath.row].userID
            vc.userID = gameData.id
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = storyboard!.instantiateViewController(withIdentifier: "XboxVC") as! XboxVC
            vc.List_Id = gameData.id
            vc.list_name = gameData.listName
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
//MARK: - Classs

class SearchBackLogTableCell : UITableViewCell {
    
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var spacing: NSLayoutConstraint!
    
}
