//
//  FriendProfileVC.swift
//  Playnxt
//
//  Created by cano on 23/05/22.
//

import UIKit
import LZViewPager
import SDWebImage

class FriendProfileVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewPager: LZViewPager!
    @IBOutlet weak var lblHeadline: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var lblFollow: UILabel!
    @IBOutlet weak var btnMessage: RoundButton!
    @IBOutlet weak var btnSettinng: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    //MARK: - Variable
    var subControllers : [UIViewController] = []
    var screenType:String?
    var profileData : GetMyProfileData?
    var profile : Profile?
    var followerData : Follower?
    var userID:Int?
    var friendPro : FriendProfile?
    var frndProfile : FriendProfileData?
    //MARK: -ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        apiGetFriendProfile()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.hostController = self
        let vc1 = storyboard!.instantiateViewController(withIdentifier: "FriendActivityVC") as! FriendActivityVC
        vc1.userID = userID
        let vc2 = storyboard!.instantiateViewController(withIdentifier: "FriendFollowerVC") as! FriendFollowerVC
        vc2.userId = userID
        let vc3 = storyboard!.instantiateViewController(withIdentifier: "FriendFollowingVC") as! FriendFollowingVC
        vc3.userId = userID
        vc1.title = "Games"
        vc2.title =   "Followers"
        vc3.title =  "Following"
        subControllers = [vc1,vc2,vc3]
        
        viewPager.reload()
        if screenType == "Activity"{
            btnMessage.setTitle("Follow", for: .normal)
        }
        
    }
    
    //MARK: -
    
    func apiGetFriendProfile(){
        
        showActivity(myView: self.view, myTitle: "Loading...")
        let param:[String:Any] = ["user_id":userID ?? 0]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_Friend_Profile, method: .post, parameter: param, objectClass: GetFriendProfile.self, requestCode: Constant.URL_CONSTANT.Get_Friend_Profile, userToken: nil) { frndResponse in
            if frndResponse.status == true {
                print("response-------",frndResponse)
                self.frndProfile = frndResponse.data
                self.friendPro = frndResponse.data.profile
                self.lblName.text = self.friendPro?.name
                self.lblFollow.text = String(frndResponse.data.totelFollower)
                self.lblFollowing.text = String(frndResponse.data.totelFollowing)
                self.lblActivity.text = String(frndResponse.data.totelGame)
                let urlBanner = URL(string: Constant.ImageUrl + (self.friendPro?.image ?? ""))
                self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
                self.removeActivity(myView: self.view)
            }else {
                print("message-----",frndResponse.message)
            }
        }
    }
    
    //MARK: -
    func apiFollow(userID:Int){
        
        let param:[String:Any] = ["user_id":userID]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.follow_Add_Friend, method: .post, parameter: param, objectClass: FollowUnfollow.self, requestCode: Constant.URL_CONSTANT.follow_Add_Friend, userToken: nil) { [self] response in
            if response.status == true {
                print("Response1233---",response)
                self.followerData = response.data.follower
                screenType = "MSG"
                print("screenType-------",screenType)
                btnMessage.setTitle("Message", for: .normal)
               
            }else {
                print("Message-",response.message)
            }
        }
    }
    
    //MARK: - Button Action
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        Singleton.sharedInstance.frndUserID = 0
    }
    @IBAction func btnMessage(_ sender: UIButton) {
        print("Message")
        if screenType == "Activity" {
            apiFollow(userID: friendPro?.id ?? 0)
        }else  if self.btnMessage.titleLabel?.text == "Message" {
            let vc = storyboard!.instantiateViewController(withIdentifier: "ChatWebViewVC") as! ChatWebViewVC
            Singleton.sharedInstance.reciver_id = frndProfile?.profile.id
            vc.frndName = frndProfile?.profile.name
            vc.img = frndProfile?.profile.image
            self.navigationController?.pushViewController(vc, animated: true)
        }else if screenType == "MSG" {
            let vc = storyboard!.instantiateViewController(withIdentifier: "ChatWebViewVC") as! ChatWebViewVC
            Singleton.sharedInstance.reciver_id = frndProfile?.profile.id
            vc.frndName = frndProfile?.profile.name
            vc.img = frndProfile?.profile.image
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = storyboard!.instantiateViewController(withIdentifier: "ChatWebViewVC") as! ChatWebViewVC
            Singleton.sharedInstance.reciver_id = frndProfile?.profile.id
            vc.frndName = frndProfile?.profile.name
            vc.img = frndProfile?.profile.image
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
        
    }
    /*  @IBOutlet weak var imgClick: UIImageView! {
     
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

extension FriendProfileVC :LZViewPagerDataSource,LZViewPagerDelegate{
    func colorForIndicator(at index: Int) -> UIColor {
        return #colorLiteral(red: 0.9604150653, green: 0.5574101806, blue: 0.2842411101, alpha: 1)
    }
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }
}
