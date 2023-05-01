//
//  WishListXboxVC.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit
import SDWebImage

class WishListXboxVC: UIViewController {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var dataCollectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK: - Variables
    var List_Id : Int?
    var gameData = [BacklogGame]()
    var gameId:Int?
    var titleName:String?
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiViewGame()
        lblTitle.text = titleName
    }
    //MARK: - Api Calling
    
    func apiViewGame(){
        let param:[String:Any] = ["list_id": List_Id ?? 0]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.View_My_wishlistGame, method: .post, parameter: param, objectClass: ViewMyGame.self, requestCode: Constant.URL_CONSTANT.View_My_wishlistGame, userToken: nil) { response  in
            if response.status == true {
                if response.data.games.isEmpty {
                    self.dataCollectionView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    print("Response",response)
                    self.gameData = response.data.games
                    self.dataCollectionView.reloadData()
                }
            }else {
                print("Message",response.message)
            }
        }
    }
    
    
    //MARK: - Button Action
    
    @IBAction func bntBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAdd(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddGameVC") as! AddGameVC
        vc.titleName = titleName
        vc.screenType = "wishlistXbox"
        vc.list_id = List_Id
        print("idd",List_Id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - Extension

extension WishListXboxVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dataCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WishlistXboxCell
        let data = gameData[indexPath.row]
        cell.lblGameName.text = data.title
        
        if data.image_type == "thirdparty" {
         
            let urlBanner = URL(string: (data.image))
            cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "image_icon"), options: .refreshCached, context: nil)
        }else {
            let urlBanner = URL(string: Constant.ImageUrl + (data.image))
            cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "image_icon"), options: .refreshCached, context: nil)
        }
        
        cell.viewController = self
        cell.btnView.tag  = indexPath.row
        cell.btnView.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func connected(sender: UIButton){
        let vc = storyboard!.instantiateViewController(withIdentifier: "XboxGameInfoVC") as! XboxGameInfoVC
        vc.gameId = gameData[sender.tag].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Extension

extension WishListXboxVC:UICollectionViewDelegateFlowLayout {
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

class WishlistXboxCell:UICollectionViewCell{
    @IBOutlet weak var imgGame: DesignImage!
    @IBOutlet weak var lblGameName: UILabel!
    var viewController:WishListXboxVC?
    @IBOutlet weak var btnView: UIButton!
    /*@IBAction func bntBuy(_ sender: Any) {
     let vc = viewController?.storyboard!.instantiateViewController(withIdentifier:  "XboxGameInfoVC") as! XboxGameInfoVC
     self.viewController?.navigationController?.pushViewController(vc, animated: true)
     }*/
}
