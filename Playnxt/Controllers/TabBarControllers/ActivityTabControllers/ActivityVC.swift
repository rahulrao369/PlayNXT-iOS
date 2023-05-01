//
//  ActivityVC.swift
//  Playnxt
//
//  Created by cano on 20/05/22.
//

import UIKit
import SDWebImage
import LZViewPager
import NotificationCenter


class ActivityVC: UIViewController,LZViewPagerDelegate,LZViewPagerDataSource {
    //MARK: - Variable
    @IBOutlet weak var viewPager: LZViewPager!
    var subControllers : [UIViewController] = []
    @IBOutlet weak var imgProfile: UIImageView!
    var screenType:String?
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Singleton.sharedInstance.pass_status?.removeAll()
        let urlBanner = URL(string: Constant.ImageUrl + (Singleton.sharedInstance.profileImg ?? ""))
        // NotificationCenter.default.addObserver(self, selector: #selector(notification(_:)), name: Notification.Name("tap"), object: nil)
        self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Singleton.sharedInstance.pass_status == "SeeAll"{
            viewPager.dataSource = self
            viewPager.delegate = self
            viewPager.hostController = self
            
            let vc1 = storyboard!.instantiateViewController(withIdentifier: "CommunityVC") as! CommunityVC
            let vc2 = storyboard!.instantiateViewController(withIdentifier: "FriendsVC") as! FriendsVC
            vc1.title = "Community"
            vc2.title = "Friends"
            subControllers = [vc1,vc2]
            viewPager.reload()
            viewPager.select(index: 1)
        }else {
            viewPager.dataSource = self
            viewPager.delegate = self
            viewPager.hostController = self
            
            let vc1 = storyboard!.instantiateViewController(withIdentifier: "CommunityVC") as! CommunityVC
            let vc2 = storyboard!.instantiateViewController(withIdentifier: "FriendsVC") as! FriendsVC
            vc1.title = "Community"
            vc2.title = "Friends"
            subControllers = [vc1,vc2]
            viewPager.reload()
            viewPager.select(index: 0)
        }
    }
    
    //MARK:-
    /* func userNotificationCenter(_ center: UNUserNotificationCenter,
     didReceive response: UNNotificationResponse,
     withCompletionHandler completionHandler: @escaping () -> Void) {
     NotificationCenter.default.post(name: NSNotification.Name("tap"), object: nil)
     
     }
     
     @objc func notification(_ notification:Notification) {
     let vc = storyboard!.instantiateViewController(withIdentifier: "FriendsVC") as! FriendsVC
     viewHeight.constant = CGFloat((vc.list.count * 170))
     self.navigationController?.pushViewController(vc, animated: true)
     }*/
    
    
    //MARK: - Button Action
    @IBAction func btnProfile(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Functions
    func colorForIndicator(at index: Int) -> UIColor {
        return #colorLiteral(red: 0.9966868758, green: 0.4519327283, blue: 0.0004293027159, alpha: 1)
    }
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.init(red: 226/255, green: 107/255, blue: 67/255, alpha: 1.0), for: .selected)
        button.titleLabel?.font = UIFont.init(name: "Nunito-Bold", size: 22)
        button.setTitleColor(UIColor.white, for: .normal) //selected color
        return button
    }
    
    
}
