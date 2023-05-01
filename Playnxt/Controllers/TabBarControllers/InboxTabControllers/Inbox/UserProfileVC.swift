//
//  UserProfileVC.swift
//  Playnxt
//
//  Created by CP on 20/06/22.
//

import UIKit
import LZViewPager
import SDWebImage

class UserProfileVC: UIViewController {
    
    
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
    var userID:Int?
    var frndProfile : FriendProfileData?
    var friendPro : FriendProfile?
    //MARK: -ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiGetProfile()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.hostController = self
        let vc1 = storyboard!.instantiateViewController(withIdentifier: "UserGameVC") as! UserGameVC
        let vc2 = storyboard!.instantiateViewController(withIdentifier: "UserFollowerVC") as! UserFollowerVC
        let vc3 = storyboard!.instantiateViewController(withIdentifier: "UserFollowingVC") as! UserFollowingVC
        vc1.title = "Games"
        vc2.title =   "Followers"
        vc3.title =  "Following"
        subControllers = [vc1,vc2,vc3]
        viewPager.reload()
        
        apiGetProfile()
    }
    
    //MARK: -  Api Calling
    
    func apiGetProfile(){
        
        showActivity(myView: self.view, myTitle: "Loading...")
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_My_Profile, method: .post, parameter: nil, objectClass: GetMyProfile.self, requestCode: Constant.URL_CONSTANT.Get_My_Profile, userToken: nil) { response in
            if response.status == true {
                print("response-------",response)
                self.profileData = response.data
                self.profile = response.data.profile
                self.lblName.text = self.profile?.name
                self.lblFollow.text = String(response.data.totelFollower)
                self.lblFollowing.text = String(response.data.totelFollowing)
                self.lblActivity.text = String(response.data.totelGame)
                let urlBanner = URL(string: Constant.ImageUrl + (self.profile?.image ?? ""))
                self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
                self.removeActivity(myView: self.view)
            }else {
                print("message-----",response.message)
            }
        }
    }
    
    //MARK: - Button Action
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        Singleton.sharedInstance.homeResponse?.removeAll()
        Singleton.sharedInstance.response?.removeAll()
    }
    @IBAction func btnSetting(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnMessage(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "EditVC") as! EditVC
        vc.name = profile?.name
        vc.email = profile?.email
        vc.imgPick = profile?.image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*@IBOutlet weak var imgClick: UIImageView! {
     
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

extension UserProfileVC :LZViewPagerDataSource,LZViewPagerDelegate{
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
