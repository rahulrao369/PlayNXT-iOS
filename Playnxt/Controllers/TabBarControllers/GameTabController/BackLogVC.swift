//
//  BackLogVC.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit
import DropDown
import GoogleMobileAds

class BackLogVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var backLogTableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: - Variable
    
    let list = ["Adventure","Action Games"]
    let dropDown = DropDown()
    var backlogData = [Count]()
    var allData : MyBacklogData?
    var deleteId:Int?
    var refreshControl = UIRefreshControl()
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    var total_backlog:Int?
    
    let Subscribe = UserDefaults.standard.bool(forKey: "SUBSCRIBED")
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = Constant.banner_UnitId
          bannerView.rootViewController = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // apiBacklogList()
        apiBacklogList()
        loadBannerAd()
        apiSubscription()
        
        // btnAdd.setImage(UIImage.init(named: "subs_color"), for: .normal)
        
        if self.allData?.backlogRemain == 0 {
            btnAdd.setImage(UIImage.init(named: "subs_color"), for: .normal)
        }else {
            btnAdd.setImage(UIImage.init(named: "add_iconPlay"), for: .normal)
        }
        
        /*if Subscribe == true {
            bannerView.isHidden = true
            
                  btnAdd.setImage(UIImage.init(named: "add_icon"), for: .normal)
             
        }else {
            bannerView.isHidden   = false
           
                  btnAdd.setImage(UIImage.init(named: "add_icon"), for: .normal)
             
        }*/
      /*  if Singleton.sharedInstance.remaning == 0 {
            btnAdd.setImage(UIImage.init(named: "subs_color"), for: .normal)
        }else {
            btnAdd.setImage(UIImage.init(named: "add_icon"), for: .normal)
        }*/
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
    
    //MARK: -  Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddBacklogList(_ sender: Any) {
      
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        if Subscribe == false {
            if allData?.backlogRemain == 0 {
                let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
                navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupAddBacklogVC") as! PopupAddBacklogVC
                vc.modalTransitionStyle = .coverVertical
                vc.screenType = "Create"
                vc.viewController = self
                self.present(vc, animated: true)
                self.removeActivity(myView: self.view)
            }
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupAddBacklogVC") as! PopupAddBacklogVC
            vc.modalTransitionStyle = .coverVertical
            vc.screenType = "Create"
            vc.viewController = self
            self.present(vc, animated: true)
            self.removeActivity(myView: self.view)
       // }
    }
    }
    
    //MARK: -  Api calling
    
    func apiBacklogList() {
        showActivity(myView: self.view, myTitle: "Loading...")
        let param : [String:Any] = [:]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_My_Backlog, method: .post, parameter: param, objectClass: GetMyBackLog.self, requestCode: Constant.URL_CONSTANT.Get_My_Backlog, userToken: nil) { [self] response in
            if response.status == true {
                print("response-----",response)
                self.backlogData = response.data.count
                self.allData = response.data
                if Subscribe == false {
                if self.allData?.backlogRemain == 0 {
                    btnAdd.setImage(UIImage.init(named: "subs_color"), for: .normal)
                }else {
                    btnAdd.setImage(UIImage.init(named: "add_icon"), for: .normal)
                }
                }else {
                    btnAdd.setImage(UIImage.init(named: "add_icon"), for: .normal)
                }
                if response.data.count.isEmpty {
                    self.backLogTableView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    
                    self.backLogTableView.reloadData()
                    
                }
                self.removeActivity(myView: self.view)
                
            }else {
                print("message--",response.message)
            }
        }
    }
    
    //MARK: - 
    
    func apiDeleteBacklogList(id:Int){
        
        let param : [String:Any] = ["type":"backloglist",
                                    "list_id":deleteId ?? 0]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Delete_Backlog_Wishlist, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Delete_Backlog_Wishlist, userToken: nil) { response in
            if response.status == true{
                self.apiBacklogList()
                print("response-----",response)
                
            } else
            {
                print("message--",response.message)
            }
        }
    }
    
    //MARK: -
       
       func apiSubscription(){
           SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Check_Subscription, method: .post, parameter: nil, objectClass: CheckSubsRespo.self, requestCode: Constant.URL_CONSTANT.Check_Subscription, userToken: nil) { [self] response  in
               if response.status == true {
                   print("Response",response)
                   self.subs = response.data
                   print("subs..........",subs)
                   
   //                if subs?.freeBacklog == 0 {
   //                    btnAdd.setImage(UIImage.init(named: "subs_color"), for: .normal)
   //                }else {
   //                    btnAdd.setImage(UIImage.init(named: "add_icon"), for: .normal)
   //                }
   //
                   
                   self.commonSub = response.data.subscription
                   UserDefaults.standard.setValue(response.data.subscribed, forKey: "SUBSCRIBED")
               }else {
                   print("message",response.message)
               }
           }
       }
    
    
}
//MARK: - Extension

extension BackLogVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.backlogData.count == 0{
            self.backLogTableView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
        }else{
            self.backLogTableView.restore()
        }
        
        return backlogData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  backLogTableView.dequeueReusableCell(withIdentifier: "cell") as! BackLogCell
        let data = backlogData[indexPath.row]
        cell.lblCategory.text = data.listName
        cell.lblName.text = String(data.totalGame)
        cell.btnDrop.tag = indexPath.row
        cell.btnDrop.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func connected(sender: UIButton){
        let path = IndexPath(item: sender.tag, section: 0)
        let cell = self.backLogTableView.cellForRow(at: path) as? BackLogCell
        dropDown.anchorView = cell?.btnDrop
        dropDown.dataSource = ["Edit Name","Delete"]
        dropDown.show()
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            if item == "Edit Name"{
                print("backlogid------------",backlogData[sender.tag].id)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupAddBacklogVC") as! PopupAddBacklogVC
                vc.modalTransitionStyle = .coverVertical
                vc.screenType = "Edit"
                vc.viewController = self
                vc.list_name = backlogData[sender.tag].listName
                print("Listname------------",backlogData[sender.tag].listName)
                vc.backlogId = backlogData[sender.tag].id
                self.present(vc, animated: true)
                self.removeActivity(myView: (view)!)
            }else if item == "Delete" {
                print("backlogid------------",backlogData[sender.tag].id)
                deleteId = backlogData[sender.tag].id
                showAlertWithCompletion(title: "Alert", message: "Are you sure you want to delete", completion: {  UIAlertAction in
                    apiDeleteBacklogList(id: self.backlogData[sender.tag].id)
                    
                })
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "XboxVC")
        as! XboxVC
        viewController.List_Id = backlogData[indexPath.row].id
        viewController.list_name = backlogData[indexPath.row].listName
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - Claass

class BackLogCell:UITableViewCell{
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDrop: UIButton!
}

