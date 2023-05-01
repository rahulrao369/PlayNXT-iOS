//
//  WishlistCreatePopupVc.swift
//  Playnxt
//
//  Created by CP on 11/10/22.
//

import UIKit

class WishlistCreatePopupVc: UIViewController {

    //MARK: - IBOutlet
    
    @IBOutlet weak var tblWishlist: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    //MARK: - Variable
    
    var wish = [Wishlist]()
    var viewController = AddGameVC()
    var Controller = GameInfoVC()
    var categoryType:String?
    var screnType:String?
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblWishlist.dataSource = self
        tblWishlist.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        apiGetCategory()
    }
    
    //MARK: - Api Calling
    
    func apiGetCategory(){
        showActivity(myView: self.view, myTitle: "Loading...")
        let param : [String:Any] = ["category":categoryType ?? ""]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_category_List, method: .post, parameter: param, objectClass: GetcategoryListResponse.self, requestCode: Constant.URL_CONSTANT.Get_category_List, userToken: nil) { response in
            print("response=======",response)
            if response.status == true{
                print("response-----",response)
                self.wish = response.data.wishlist
                self.tblWishlist.reloadData()
                self.removeActivity(myView: self.view)
            }else {
                print("message--",response.message)
            }
        }
    }
    //MARK: - Button Action
    
    @IBAction func btnCreate(_ sender: Any) {
       
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupAddWishlist") as! PopupAddWishlist
            vc.modalTransitionStyle = .coverVertical
            vc.screentype = "Addwishlist"
            vc.VController = self
            self.present(vc, animated: true)
            self.removeActivity(myView: self.view)
       
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if screnType == "AddGame"{
            if Singleton.sharedInstance.list_Name?.isEmpty == true{
                showAlert(message: "Please select one category")
            }else {
                viewController.apiAddGame()
                self.dismiss(animated: true)
                self.showAlert(message: "Update list Successfully")
                
            }
        }
        else if screnType == "WishlistGameInfo" {
            if Singleton.sharedInstance.list_Name?.isEmpty == true{
                showAlert(message: "Please select one category")
            }else {
                Controller.apiAddFriendGame()
                self.dismiss(animated: true)
                
            }
        }
    }
}

//MARK: -  extension
extension WishlistCreatePopupVc : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return wish.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblWishlist.dequeueReusableCell(withIdentifier: "WishListTableCell") as! WishListTableCell
       
            cell.lblCate.text = wish[indexPath.row].name
            cell.btnTick.tag = indexPath.row
            cell.btnTick.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            Singleton.sharedInstance.list_Name = wish[indexPath.row].name
            Singleton.sharedInstance.List_id = wish[indexPath.row].id
       
        return cell
    }
    
    @objc func connected(sender: UIButton){
        let path = IndexPath(item: sender.tag, section: 0)
        let cell = self.tblWishlist.cellForRow(at: path) as? WishListTableCell
        cell?.btnTick.isSelected.toggle()
       /* if categoryType == "backlog" {
            if cell?.btnTick.isSelected == true{
                Singleton.sharedInstance.list_Name = cat[sender.tag].name
                Singleton.sharedInstance.List_id = cat[sender.tag].id
                print("ID , Name ----", Singleton.sharedInstance.list_Name ?? "", Singleton.sharedInstance.List_id ?? "")
            }else {
                Singleton.sharedInstance.list_Name?.removeAll()
                print("Remove----",Singleton.sharedInstance.list_Name ?? "")
            }
        }else {*/
        
            if cell?.btnTick.isSelected == true{
                Singleton.sharedInstance.list_Name = wish[sender.tag].name
                Singleton.sharedInstance.List_id = wish[sender.tag].id
                print("ID , Name ----", Singleton.sharedInstance.list_Name ?? "" , Singleton.sharedInstance.List_id ?? "")
            }else {
                Singleton.sharedInstance.list_Name?.removeAll()
                print("Remove----",Singleton.sharedInstance.list_Name ?? "")
            }
        }
    }
//}
//MARK: - TableClass
class WishListTableCell:UITableViewCell{
    
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var lblCate: UILabel!
}
