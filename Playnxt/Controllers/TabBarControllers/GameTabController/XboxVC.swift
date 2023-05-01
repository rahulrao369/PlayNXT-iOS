//
//  XboxVC.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit
import SDWebImage

class XboxVC: UIViewController,UITextFieldDelegate {
    
    
    //MARK : - IBOutlets
    @IBOutlet weak var dataCollectionView: UICollectionView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    
    
    //MARK: - Variables
    var List_Id : Int?
    var gameData = [BacklogGame]()
    var list_name:String?
    var lstId:Int?
    var backlogData : MybacklogGame!
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblTitle.text = list_name
        txtSearch.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtSearch.attributedPlaceholder = NSAttributedString(string: "Search backlog game", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 147/255, green: 147/255, blue: 147/255, alpha: 1.0)])
        apiViewGame()
    }
    
    //MARK: - Function
    
    @objc func textFieldDidChange(_ textField: UITextField) {
         if textField == txtSearch {
             print("Result--",txtSearch.text ?? "")
             apiViewGame()
            self.dataCollectionView.reloadData()
             if !txtSearch.text!.isEmpty{
                 self.dataCollectionView.reloadData()
                 apiViewGame()
             }
         }else  {
             print("No Result")
         }
     }
    
    //MARK: - Api Calling
    
    func apiViewGame(){
        let param:[String:Any] = ["list_id": List_Id ?? 0,
                                  "keyword":txtSearch.text!]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.View_my_backlogGame, method: .post, parameter: param, objectClass: ViewMyGame.self, requestCode: Constant.URL_CONSTANT.View_my_backlogGame, userToken: nil) { [self] response  in
            if response.status == true {
                if response.data.games.isEmpty{
                    self.dataCollectionView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    print("Response-------",response)
                    self.gameData = response.data.games
                    
                    self.backlogData = response.data
                                       /* if backlogData?.backlogRemain == 0 {
                                           btnAdd.setImage(UIImage.init(named: "subs_color"), for: .normal)
                                       }
                                       else {
                                           btnAdd.setImage(UIImage.init(named: "add_icon"), for: .normal)
                                       }*/
                    
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
    
    @IBAction func btnSearch(_ sender: Any) {
        
        apiViewGame()
    }
    
    
    @IBAction func btnAdd(_ sender: Any) {
     
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddGameVC") as! AddGameVC
        vc.titleName = list_name
        vc.screenType = "XboxVC"
        vc.list_id = List_Id
        print("idd",List_Id)
        self.navigationController?.pushViewController(vc, animated: true)
        
        /*if backlogData?.backlogRemain == 0 {
                   let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
                   navigationController?.pushViewController(vc, animated: true)
               
               }else {
                   let vc = storyboard?.instantiateViewController(withIdentifier: "AddGameVC") as! AddGameVC
                   vc.titleName = list_name
                   vc.screenType = "XboxVC"
                   vc.list_id = List_Id
                   print("idd",List_Id)
                   self.navigationController?.pushViewController(vc, animated: true)
               }*/
    }
}
//MARK: - Extension

extension XboxVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.gameData.count == 0{
                   self.dataCollectionView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                     }else{
                         self.dataCollectionView.restore()
                     }

                     return gameData.count
           }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dataCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! XboxCollectionCell
        let data = gameData[indexPath.row]
        cell.lblGameName.text = data.title
        cell.lblStatus.text = data.status
        
        if data.image_type == "thirdparty"{
            let urlBanner = URL(string: (data.image))
            cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "image_icon"), options: .refreshCached, context: nil)
        }else {
            
            let urlBanner = URL(string: Constant.ImageUrl + (data.image))
            cell.imgGame.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgGame.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "image_icon"), options: .refreshCached, context: nil)
        }
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "XboxGameInfoVC") as! XboxGameInfoVC
        vc.gameId = gameData[indexPath.row].id
        vc.profileImg = gameData[indexPath.row].image
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


//MARK: - Extension

extension XboxVC:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth =  collectionView.frame.size.width
        return CGSize(width: collectionWidth/2, height: 311)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
}

//MARK: - CollectionView Class

class XboxCollectionCell:UICollectionViewCell{
    @IBOutlet weak var imgGame: DesignImage!
    @IBOutlet weak var lblGameName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblupdate: UILabel!
    var viewController:XboxVC?
    @IBAction func bntBuy(_ sender: Any) {
        
    }
}
