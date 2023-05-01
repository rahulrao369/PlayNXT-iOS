//
//  SearchVC.swift
//  Playnxt
//
//  Created by cano on 27/05/22.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class SearchVC: UIViewController,UITextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var txtsearch: UITextField!
    @IBOutlet weak var btnGame: UIButton!
    @IBOutlet weak var btnUsers: UIButton!
    @IBOutlet weak var btnBacklog: UIButton!
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

      //  txtsearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtsearch.attributedPlaceholder = NSAttributedString(string: "Search Games or Users", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 147/255, green: 147/255, blue: 147/255, alpha: 1.0)])
        let nib = UINib(nibName: "SearchHeaderCell", bundle: nil)
        dataTableView.register(nib, forHeaderFooterViewReuseIdentifier: "SearchHeaderCell")
        txtsearch.delegate = self
          btnGame.isSelected = true
      //  btnUsers.isSelected = true
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
    
    //MARK: -
    
   /* @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == txtsearch {
            print("Result--",txtsearch.text ?? "")
           //self.dataTableView.reloadData()
            if !txtsearch.text!.isEmpty{
                self.dataTableView.reloadData()
                apiSearching()
            }
        }else  {
            print("No Result")
        }
    }*/
    /* func textFieldDidEndEditing(_ textField: UITextField) {
     if textField == txtsearch {
     print("Result--",txtsearch.text ?? "")
     self.dataTableView.reloadData()
     if !txtsearch.text!.isEmpty{
     apiSearching()
     }
     }else  {
     print("No Result")
     }
     }*/
    
    //MARK: - Button Action
    
    @IBAction func btnSearch(_ sender: Any) {
        apiSearching()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnUser(_ sender: UIButton) {
        btnUsers.isSelected = true
        btnGame.isSelected = false
        btnBacklog.isSelected = false
        searchType = "user"
        print("search---",searchType )
        if txtsearch.text?.isEmpty == true {
            print("search")
            self.dataTableView.reloadData()
        }else {
            apiSearching()
        }
    }
    @IBAction func btnGames(_ sender: UIButton) {
        btnGame.isSelected = true
        btnUsers.isSelected = false
        btnBacklog.isSelected = false
        searchType = "game"
        print("search---",searchType )
        if txtsearch.text?.isEmpty == true {
            print("search")
            self.dataTableView.reloadData()
        }else {
            apiSearching()
        }
    }
    
    @IBAction func btnBacklog(_ sender: UIButton) {
        btnGame.isSelected = false
        btnUsers.isSelected = false
        btnBacklog.isSelected = true
    
        searchType = "backlog"
        print("search---",searchType )
        if txtsearch.text?.isEmpty == true {
            print("search")
            self.dataTableView.reloadData()
        }else {
            apiSearching()
        }
    }
    
    @IBAction func btnAdd(_ sender: Any) {
          if Subscribe == false {
                let vc = storyboard!.instantiateViewController(withIdentifier: "AddGameVC") as! AddGameVC
                self.navigationController?.pushViewController(vc, animated: true)
            
        }else  if Subscribe == true  {
            let vc = storyboard!.instantiateViewController(withIdentifier: "AddGameVC") as! AddGameVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    //MARK: - Api calling
    //user
    func apiSearching(){
        
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
    }
    
}
//MARK: - Extension

extension SearchVC : UITableViewDelegate,UITableViewDataSource {
    /*func numberOfSections(in tableView: UITableView) -> Int {
     return 2
     }*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("searchData............",searchData.count)
        return searchData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTableView.dequeueReusableCell(withIdentifier: "cell") as! SearchTableCell
        
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
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
    }
    
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

class SearchTableCell : UITableViewCell {
    
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var spacing: NSLayoutConstraint!
    
}
