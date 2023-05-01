//
//  AddGameVC.swift
//  Playnxt
//
//  Created by cano on 21/05/22.
//

import UIKit
import Cosmos
import Alamofire
import SDWebImage
import DropDown
import GoogleMobileAds

class AddGameVC: BaseViewController,UITextFieldDelegate,UITextViewDelegate {
    //MARK: - IBOutlets
    @IBOutlet weak var imgGame: DesignImage!
    @IBOutlet weak var txtGameName: UITextField!
    @IBOutlet weak var txtplatform: UITextField!
    @IBOutlet weak var txtdescription: UITextView!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var txtgenre: UITextField!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgUplod: UIImageView!
    @IBOutlet weak var btnBacklog: RoundButton!
    @IBOutlet weak var btnWishlist: RoundButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var gameView: ViewDesign!
    @IBOutlet weak var searchGameTbl: UITableView!
    @IBOutlet weak var btnDrop1: UIButton!
    @IBOutlet weak var btnDrop2: UIButton!
    @IBOutlet weak var btnTxt: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: - Variable
    
    var categoryType:String?
    var titleName:String?
    var screenType:String?
    var list_id:Int?
    var activePlan:String?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    var platform : GetPlatformData?
    var search = [NewSearch]()
    var game_id : Int?
    let dropDown1 = DropDown()
    let dropDown2 = DropDown()
    var game_type = "manual"
    var pltfrm = [GetPlatform]()
    var gnre = [GetGenre]()
    
    let Subscribe = UserDefaults.standard.bool(forKey: "SUBSCRIBED")
    var arrPlatform : [String] = []
    var arrGenre : [String]  = []
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        btnTxt.isHidden = false
        txtdescription.text = "Description"
        txtdescription.textColor = UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)
        txtdescription.font = UIFont(name: "Nunito-Medium", size: 14)
        txtdescription.returnKeyType = .done
        txtdescription.delegate = self
        bannerView.adUnitID = Constant.banner_UnitId
          bannerView.rootViewController = self
        txtGameName.attributedPlaceholder = NSAttributedString(string: "Search Game", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtplatform.attributedPlaceholder = NSAttributedString(string: "Platform", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtgenre.attributedPlaceholder = NSAttributedString(string: "Genre", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        viewRating.didTouchCosmos = didTouchCosmos
        viewRating.didFinishTouchingCosmos = didFinishTouchingCosmos
        updateRating(requiredRating: nil)
        txtSearch.delegate = self
        
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtSearch.attributedPlaceholder = NSAttributedString(string: "Search Games", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 147/255, green: 147/255, blue: 147/255, alpha: 1.0)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameView.isHidden = true
       apiGetPlatform()
        loadBannerAd()
        
        
        
        if Subscribe == true {
            bannerView.isHidden = true
        }else {
            bannerView.isHidden   = false
        }
        
        
        if screenType == "XboxVC" {
        
            btnWishlist.isHidden = true
        }
        if screenType == "wishlistXbox" {
        
            btnBacklog.isHidden = true
        
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
    
    
    //MARK: - Function
    
    //MARK: - Function
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
            textView.text = ""
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "Nunito-Medium", size: 14)
        }
    }
    
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == txtSearch {
            print("Result--",txtSearch.text ?? "")
            //      self.searchTableView.reloadData()
            if !txtSearch.text!.isEmpty{
                self.searchGameTbl.reloadData()
                apiSearchNewGame()
            }
        }else  {
            print("No Result")
        }
    }
    
    
    private func updateRating(requiredRating: Double?) {
        var newRatingValue: Double = 0
        
        if let nonEmptyRequiredRating = requiredRating {
            newRatingValue = nonEmptyRequiredRating
        } else {
        }
        
        viewRating.rating = newRatingValue
        
        self.lblRating.text = AddGameVC.formatValue(newRatingValue)
    }
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
    private func didTouchCosmos(_ rating: Double) {
        updateRating(requiredRating: rating)
        lblRating.text = AddGameVC.formatValue(rating)
        lblRating.textColor = .lightGray
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        self.lblRating.text = AddGameVC.formatValue(rating)
        lblRating.textColor = .lightGray
    }
    override func didSelectedImage(selectedImage: UIImage) {
        imgProfile.image = selectedImage
    }
    
    //MARK: - Api Calling
    
    func apiSearchNewGame(){
        
      //  showActivity(myView: self.view, myTitle: "Loading...")
        let param : [String:Any] = ["title":txtSearch.text!]
        
        SessionManager.shared.methodForApiCalling(url: Constant.URL_CONSTANT.Search_AddGame, method: .post, parameter: param, objectClass: SearchAddGameResponse.self, requestCode: Constant.URL_CONSTANT.Search_AddGame, userToken: nil) { response  in
            if response.status == true {
                print("response",response)
             self.search = response.data.newdata
                self.searchGameTbl.reloadData()
                //self.removeActivity(myView: self.view)
            }else {
                print("msg--",response.message)
            }
        }
    }
    
    //MARK: -
    
    func apiAddGame(){
        //showActivity(myView: self.view, myTitle: "Loading...")
        let parameters:[String:Any] = ["title":txtGameName.text ?? "",
                                       "platform":txtplatform.text ?? "",
                                       "description":txtdescription.text ?? "",
                                       "genre":txtgenre.text ?? "",
                                       "category":Singleton.sharedInstance.category_type ?? "",
                                       "list_name":Singleton.sharedInstance.list_Name ?? "",
                                       "list_id":Singleton.sharedInstance.List_id ?? 0,
                                       "rate":lblRating.text ?? "",
                                       "game_type":game_type,
                                       "game_id":game_id]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                
                multipartFormData.append((self.imgProfile.image!.jpegData(compressionQuality: 0.1)!), withName: "image" , fileName: "file.jpeg", mimeType: "image/jpeg")
                
                
            },
            to: Constant.URL_CONSTANT.Add_Game, method: .post , headers: SessionManager.shared.getHeader(reqCode:Constant.URL_CONSTANT.Add_Game, userToken: nil))
            .validate(statusCode: 200..<300)
            .response { resp in
                
                switch resp.result{
                case .failure(let error): break
                    
                case.success( _):
                    
                    print(resp.data)
                    let decoder = JSONDecoder()
                    let decoded = try? decoder.decode(CommonResponse.self, from: resp.data!)
                    let data = decoded
                    if !(decoded?.status)!{
                        self.showAlert(message: decoded?.message ?? "")
                        
                    }else {
                        //self.apiGetProfile()
                        self.showAlert(message: decoded?.message ?? "")
                    }
                    
                }
            }
    }
   
    //MARK: -
    
    func apiGetPlatform(){
        arrPlatform.removeAll()
        arrGenre.removeAll()
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_PlatformGenre, method: .post, parameter: nil, objectClass: GetPlatformGenre.self, requestCode: Constant.URL_CONSTANT.Get_PlatformGenre, userToken: nil) { [self] response  in
            if response.status == true {
                print("Response",response)
                self.platform = response.data
                self.pltfrm = response.data.platform
                self.gnre = response.data.genre
            
                for i in 0..<self.pltfrm.count{
                    arrPlatform.append(pltfrm[i].name)
                    print("arrrplatform===",arrPlatform)
                }
                for i in 0..<self.gnre.count{
                    arrGenre.append(gnre[i].name)
                    print("arrrplatform===",arrGenre)
                }
                
            }else {
                print("message",response.message)
            }
        }
    }
    
    //MARK: -
    
    func apiAddBacklogGame(){
        //showActivity(myView: self.view, myTitle: "Loading...")
        let parameters:[String:Any] = ["title":txtGameName.text ?? "",
                                       "platform":txtplatform.text ?? "",
                                       "description":txtdescription.text ?? "",
                                       "genre":txtgenre.text ?? "",
                                       "category":categoryType ?? "",
                                       "list_name":titleName ?? "",
                                       "list_id":list_id ?? 0,
                                       "rate":lblRating.text ?? "",
                                       "game_type":game_type,
                                       "game_id":game_id]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                
                multipartFormData.append((self.imgProfile.image!.jpegData(compressionQuality: 0.1)!), withName: "image" , fileName: "file.jpeg", mimeType: "image/jpeg")
                
                
            },
            to: Constant.URL_CONSTANT.Add_Game, method: .post , headers: SessionManager.shared.getHeader(reqCode:Constant.URL_CONSTANT.Add_Game, userToken: nil))
            .validate(statusCode: 200..<300)
            .response { resp in
                
                switch resp.result{
                case .failure(let error): break
                    
                case.success( _):
                    
                    print("------",resp.data)
                    
                    let decoder = JSONDecoder()
                    let decoded = try? decoder.decode(CommonResponse.self, from: resp.data!)
                    let data = decoded
                    if !(decoded?.status)!{
                        self.showAlert(message: decoded?.message ?? "")
                        
                    }else {
                        //self.apiGetProfile()
                        self.navigationController?.popViewController(animated: true)
                        self.showAlert(message: decoded?.message ?? "")
                    }
                    
                }
            }
    }
    
    
    //MARK: - ButtonAction
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnUploadImg(_ sender: Any) {
        selectPhoto(isCircular: false)
    }
    @IBAction func btnBacklog(_ sender: Any) {
        
        if imgGame.image == UIImage.init(named: "Empty_Icon"){
            showAlert(message: "Upload image")
        }else if txtGameName.text?.isEmpty == true{
            showAlert(message: "Enter game title")
        }
        
            if screenType == "XboxVC" {
                categoryType = "backlog"
                game_type = "manual"
               // btnWishlist.isHidden = true
                apiAddBacklogGame()
            }else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryListPopupVC") as! CategoryListPopupVC
                vc.modalTransitionStyle = .coverVertical
                vc.viewController = self
                vc.screnType = "AddGame"
                vc.categoryType = "backlog"
                Singleton.sharedInstance.category_type = vc.categoryType
                self.present(vc, animated: true)
                self.removeActivity(myView: (view)!)
            }
        //}
    }
    @IBAction func btnWishlist(_ sender: Any) {
        
        if Subscribe == true {
            if imgGame.image == UIImage.init(named: "Empty_Icon"){
                showAlert(message: "Upload image")
            }else if txtGameName.text?.isEmpty == true{
                showAlert(message: "Enter game title")
            }
           /*else if txtdescription.text?.isEmpty == true {
                showAlert(message: "Enter description")
            }else if txtplatform.text?.isEmpty == true {
                showAlert(message: "Enter Platform")
            }else if txtgenre.text?.isEmpty == true {
                showAlert(message: "Enter genre")
            }else {*/
            
                if screenType == "wishlistXbox" {
                    categoryType = "wishlist"
                    game_type = "manual"
                   // btnBacklog.isHidden = true
                    apiAddBacklogGame()
                }else {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "WishlistCreatePopupVc") as! WishlistCreatePopupVc
                    vc.modalTransitionStyle = .coverVertical
                    vc.viewController = self
                    vc.categoryType = "wishlist"
                    vc.screnType = "AddGame"
                    Singleton.sharedInstance.category_type = vc.categoryType
                    self.present(vc, animated: true)
                    self.removeActivity(myView: (view)!)
                }
            //}
        }
    else {
            let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        gameView.isHidden = true
        btnTxt.isHidden =  true
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        gameView.isHidden = true
        btnTxt.isHidden =  true
    }
    
    @IBAction func btnTxtSerch(_ sender: Any) {
        search.removeAll()
        searchGameTbl.reloadData()
        gameView.isHidden = false
    }
    
    @IBAction func btnPlatfrom(_ sender: UIButton) {
    dropDown1.anchorView = btnDrop1
    
        dropDown1.dataSource = arrPlatform
       dropDown1.show()
        dropDown1.direction = .bottom
        dropDown1.selectionAction = { [unowned self] (index: Int, item: String) in
        print("Selected item: \(item) at index: \(index)")
            self.txtplatform.text = item
        }
    }
        
    @IBAction func btnGenre(_ sender: UIButton) {

        dropDown2.anchorView = btnDrop2
        dropDown2.dataSource = arrGenre
        dropDown2.show()
        dropDown2.direction = .bottom
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txtgenre.text = item
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
}

//MARK: - Extension

extension AddGameVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("count----",search.count)
        return search.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchGameTbl.dequeueReusableCell(withIdentifier: "cell") as! SearchAddGame
        let searchData = search[indexPath.row]
        cell.lblName.text = searchData.title
        
        if searchData.type == "thirdparty"{
            let urlBanner = URL(string: (searchData.image))
            print("urllllllll--------",URL(string: (searchData.image)))
            cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "image"), options: .refreshCached, context: nil)
        }else {
            let urlBanner = URL(string: Constant.ImageUrl + "/" + (searchData.image))
            cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "image"), options: .refreshCached, context: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchData = search[indexPath.row]
        game_id = searchData.id
        game_type = "admin_game"
        txtGameName.text = searchData.title
        txtdescription.text = searchData.newdatumDescription
        txtgenre.text = searchData.genre[0]
        txtplatform.text = searchData.platform[0]
        
        if searchData.type == "thirdparty"{
            let urlBanner = URL(string: (searchData.image))
            imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "image"), options: .refreshCached, context: nil)
        }else {
        
        let urlBanner = URL(string: Constant.ImageUrl + "/" +  (searchData.image))
        imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "image"), options: .refreshCached, context: nil)
        }
        txtSearch.text = ""
        
        print("game_id-----",game_id ?? 0)
        gameView.isHidden = true
        
    }
}


//MARK: -  table Classs

class SearchAddGame : UITableViewCell {
    
    @IBOutlet weak var imgGame : DesignImage!
    @IBOutlet weak var lblName : UILabel!
}
