//
//  FriendActivityVC.swift
//  Playnxt
//
//  Created by cano on 23/05/22.
//

import UIKit
import SDWebImage

class FriendActivityVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var activityCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    //MARK: - variable
    var frndGame = [FriendGame]()
    var screenType:String?
    var userID:Int?
    //MARK: - viewdidload
    
    override func viewDidLoad() {
        activityCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        apiFriendGame()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    //MARK: - Function
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.collectionHeight.constant = self.activityCollectionView.contentSize.height
    }
    
    //MARK: -  Api Calling
    
    func apiFriendGame(){
        let param:[String:Any] = ["user_id":userID ?? 0]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_Friend_Profile, method: .post, parameter:param, objectClass: GetFriendProfile.self, requestCode: Constant.URL_CONSTANT.Get_Friend_Profile, userToken: nil) { response  in
            if response.status == true {
                if response.data.games.isEmpty{
                    self.activityCollectionView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    print("Response---",response)
                    self.frndGame = response.data.games
                    self.activityCollectionView.reloadData()
                }
            }  else {
                print("message",response.message)
            }
        }
    }
}
//MARK: - Extension

extension FriendActivityVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frndGame.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = frndGame[indexPath.row]
        let cell = activityCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendActivityCell
        cell.lblGameName.text = data.title
        let urlBanner = URL(string: Constant.ImageUrl + (data.image))
        cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "splash_icon-1"), options: .refreshCached, context: nil)
        /* cell.btnBuy.tag = indexPath.row
         cell.btnBuy.addTarget(self, action: #selector(ViewGame(sender:)), for: .touchUpInside)*/
        
        cell.btnBuy.tag = indexPath.row
        cell.btnBuy.addTarget(self, action: #selector(ViewGame(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func ViewGame(_ sender: UIButton){
        let vc = storyboard!.instantiateViewController(withIdentifier: "GameInfoVC") as! GameInfoVC
        vc.gameId = frndGame[sender.tag].gameID
        print("GameId----",frndGame[sender.tag].gameID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Extension

extension FriendActivityVC:UICollectionViewDelegateFlowLayout {
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

class FriendActivityCell:UICollectionViewCell{
    @IBOutlet weak var imgGame: DesignImage!
    @IBOutlet weak var lblGameName: UILabel!
    @IBOutlet weak var btnBuy: RoundButton!
    
}

