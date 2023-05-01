//
//  XboxGameInfoVC.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit
import DropDown
import SDWebImage
import GoogleMobileAds

class XboxGameInfoVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: -
    let dropDown = DropDown()
    var list = [Capsul]()
    var gameId:Int?
    var deleteID:Int?
    var profileImg:String?
    var gameList : GameInfoCapsul?
    var gameView:String?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    //MARK: - ViewDidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        bannerView.adUnitID = Constant.banner_UnitId
          bannerView.rootViewController = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiGetNote()
        apiGameInfo()
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
    
    //MARK: - Api Calling
    func apiGetNote(){
        showActivity(myView: self.view, myTitle: "Loading...")
        let param:[String:Any] = ["game_id": gameId ?? 0]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_gameNote, method: .post, parameter: param, objectClass: GetGameNote.self, requestCode: Constant.URL_CONSTANT.Get_gameNote, userToken: nil) { response in
            if response.status == true {
                print("Response----",response)
                if response.data.capsul.isEmpty{
                    self.dataTableView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    self.list = response.data.capsul
                    
                    self.dataTableView.reloadData()
                }
                self.removeActivity(myView: self.view)
            }else {
                print("Message----",response.message)
            }
        }
    }
    

    
    //MARK: -
    func apiDeleteGameNote(id:Int){
        
        let param : [String:Any] = ["game_id":gameId ?? 0,
                                    "note_id":deleteID ?? 0]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Delete_Game_Note, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Delete_Game_Note, userToken: nil) { response in
            if response.status == true{
                print("response-----",response)
                self.apiGetNote()
            } else
            {
                print("message--",response.message)
            }
        }
    }
    //MARK: -
    func apiDeleteGame(){
        
        let param : [String:Any] = ["game_id":gameId ?? 0]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Delete_Game, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Delete_Game, userToken: nil) { response in
            if response.status == true{
                print("response-----",response)
                self.navigationController?.popViewController(animated: true)
                self.showAlert(message: "Delete game successfully")
            } else
            {
                print("message--",response.message)
            }
        }
    }
    //MARK: -
    func apiGameInfo(){
        let param : [String:Any] = ["game_id":gameId ?? 0,
                                    "game_view":"self"]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Game_Info, method: .post, parameter: param, objectClass: GameInfo.self, requestCode: Constant.URL_CONSTANT.Game_Info, userToken: nil) { [self] response in
            if response.status == true{
                print("response-----",response)
                self.gameList = response.data.capsul
                self.lblStatus.text = gameList?.gameStatus
                self.lblTitle.text = gameList?.gTitle
                
                if gameList?.image_type == "thirdparty" {
                    
                    let urlBanner = URL(string: (self.gameList?.gImage ?? ""))
                    self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "splash_icon-1"), options: .refreshCached, context: nil)
                }else {
                    
                    let urlBanner = URL(string: Constant.ImageUrl + (self.gameList?.gImage ?? ""))
                    self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "splash_icon-1"), options: .refreshCached, context: nil)
                }
                
            } else
            {
                print("message--",response.message)
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
    @IBAction func btnMenu(_ sender: Any) {
        
        dropDown.anchorView = btnDrop
        dropDown.dataSource = ["Delete"]
        dropDown.show()
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            if item == "Delete" {
                showAlertWithCompletion(title: "Alert", message: "Are you sure you want to delete", completion: { [self] UIAlertAction in
                    apiDeleteGame()
                })
            }
        }
        
    }
    @IBAction func btnEdit(_ sender: Any) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupSelectStatus") as! PopupSelectStatus
        //  vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.gameID = gameId
        vc.viewController = self
        vc.checkSatus = lblStatus.text
        self.present(vc, animated: true)
        self.removeActivity(myView: self.view)
        
    }
    @IBAction func btnAdd(_ sender: Any) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupEnterNotes") as! PopupEnterNotes
        vc.screenType = "Add"
        vc.gameId = gameId
        vc.viewController = self
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
        self.removeActivity(myView: self.view)
    }
    
}
//MARK: - Extension
extension XboxGameInfoVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTableView.dequeueReusableCell(withIdentifier: "cell") as! XboxGameInfoCell
        let data = list[indexPath.row]
        cell.lblDate.text = data.createOn
        cell.lblNote.text = data.note
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.btnBin.tag = indexPath.row
        cell.btnBin.addTarget(self, action: #selector(binConnected(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func connected(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupEnterNotes") as! PopupEnterNotes
        vc.gameId = gameId
        vc.viewController = self
        vc.noteId = list[sender.tag].noteID
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
        self.removeActivity(myView: self.view)
    }
    @objc func binConnected(sender: UIButton){
        deleteID = list[sender.tag].noteID
        gameId = list[sender.tag].gameID
        showAlertWithCompletion(title: "Alert", message: "Are you sure you want to delete", completion: {  UIAlertAction in
            self.apiDeleteGameNote(id: self.list[sender.tag].noteID)
        })
    }
}
//MARK: - Class

class XboxGameInfoCell:UITableViewCell{
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnBin: UIButton!
}
