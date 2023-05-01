//
//  FriendFollowingVC.swift
//  Playnxt
//
//  Created by cano on 23/05/22.
//

import UIKit
import SDWebImage

class FriendFollowingVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var activityTableView: UITableView!
    
    //MARK: - variable
    var following = [FriendFollowing]()
    var userId:Int?
    var followerData : Follower?
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        activityTableView.dataSource = self
        activityTableView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiGetFollowing()
    }
    //MARK: -  Api Calling
    
    func apiGetFollowing(){
        let param:[String:Any] = ["user_id":userId ?? 0]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_Friend_Profile, method: .post, parameter: param, objectClass: GetFriendProfile.self, requestCode: Constant.URL_CONSTANT.Get_Friend_Profile, userToken: nil) { response in
            if response.status == true {
                if response.data.following.isEmpty {
                    self.activityTableView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    print("response-------",response)
                    self.following = response.data.following
                    self.activityTableView.reloadData()
                }
            }else {
                print("message-----",response.message)
            }
        }
    }
    
    //MARK: -
    func apiFollow(){
        
        let param:[String:Any] = ["user_id":userId ?? 0]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.follow_Add_Friend, method: .post, parameter: param, objectClass: FollowUnfollow.self, requestCode: Constant.URL_CONSTANT.follow_Add_Friend, userToken: nil) { response in
            if response.status == true {
                print("Response---",response)
                self.followerData = response.data.follower
                self.activityTableView.reloadData()
                self.apiGetFollowing()
            }else {
                print("Message-",response.message)
            }
        }
    }
    func apiUnFollow(userId:Int){
        let param:[String:Any] = ["user_id":userId ]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Unfollow, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Unfollow, userToken: nil) { response in
            if response.status == true {
                print("Response---",response)
                self.apiGetFollowing()
            }else {
                print("Message-",response.message)
            }
        }
    }
}
//MARK: - Extension

extension FriendFollowingVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return following.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activityTableView.dequeueReusableCell(withIdentifier: "cell") as! FriendFollowingCell
        let data = following[indexPath.row]
        cell.lblName.text = data.name
        cell.lblMututal.text =  "\(data.mutualFriend)"
        if data.isFollow == 0 {
            cell.btnChange.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4196078431, blue: 0.262745098, alpha: 1)
            cell.btnChange.setTitle("Follow", for: .normal)
        }else {
            cell.btnChange.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
            cell.btnChange.setTitle("Unfollow", for: .normal)
        }
        let urlBanner = URL(string: Constant.ImageUrl + (data.image))
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
        cell.btnChange.tag = indexPath.row
        cell.btnChange.addTarget(self, action: #selector(follow(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func follow(sender: UIButton){
        let path = IndexPath(item: sender.tag, section: 0)
        let cell = self.activityTableView.cellForRow(at: path) as? FriendFollowingCell
        sender.isSelected.toggle()
        userId = following[sender.tag].userID
        print("UserID----",userId ?? 0)
        if sender.isSelected == true {
            apiFollow()
            
        }else
        {
            print("follow")
            apiUnFollow(userId: following[sender.tag].userID)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "FriendProfileVC") as! FriendProfileVC
        Singleton.sharedInstance.frndUserID = following[indexPath.row].userID
        vc.userID = following[indexPath.row].userID
        vc.screenType = "Activity"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: -

class FriendFollowingCell:UITableViewCell {
    
    @IBOutlet weak var imgProfile: DesignImage!
    @IBOutlet weak var lblbFriend: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMututal: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    
}
