//
//  WishlistVC.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit
import DropDown

class WishlistVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var backLogTableView: UITableView!
    let dropDown = DropDown()
    var backlogData = [Count]()
    var deleteId:Int?
    
    //MARK: - Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiwishList()
    }
    
    //MARK: - ButtonAction
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddBacklogList(_ sender: Any) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupAddWishlist") as! PopupAddWishlist
        // vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.screentype = "Create"
        vc.viewController = self
        self.present(vc, animated: true)
        self.removeActivity(myView: self.view)
    }
    
    //MARK: -  Api calling
    func apiwishList(){
        showActivity(myView: self.view, myTitle: "Loading...")
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_My_Wishlist, method: .post, parameter: nil, objectClass: GetMyBackLog.self, requestCode: Constant.URL_CONSTANT.Get_My_Wishlist, userToken: nil) { response in
            if response.status == true{
                print("response-----",response)
                if response.data.count.isEmpty {
                    self.backLogTableView.setEmptyImage(strImage: UIImage(named: "Empty_Icon")!)
                }else {
                    self.backlogData = response.data.count
                    self.backLogTableView.reloadData()
                    
                }
                self.removeActivity(myView: self.view)
            }else {
                print("message--",response.message)
            }
        }
    }
    func apiDeletewishList(id:Int){
        
        let param : [String:Any] = ["type":"wishlist",
                                    "list_id":deleteId ?? 0]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Delete_Backlog_Wishlist, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Delete_Backlog_Wishlist, userToken: nil) { response in
            if response.status == true{
                print("response-----",response)
                self.apiwishList()
            } else
            {
                print("message--",response.message)
            }
        }
    }
}

//MARK: - Extension

extension WishlistVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backlogData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  backLogTableView.dequeueReusableCell(withIdentifier: "cell") as! WishListCell
        let data = backlogData[indexPath.row]
        cell.lblCategory.text = data.listName
        cell.lblName.text = String(data.totalGame)
        cell.btnDrop.tag = indexPath.row
        cell.btnDrop.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func connected(sender: UIButton){
        let path = IndexPath(item: sender.tag, section: 0)
        let cell = self.backLogTableView.cellForRow(at: path) as? WishListCell
        dropDown.anchorView = cell?.btnDrop
        dropDown.dataSource = ["Edit Name","Delete"]
        dropDown.show()
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            if item == "Edit"{
                print("WislistID-----",backlogData[sender.tag].id)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupAddWishlist") as! PopupAddWishlist
                vc.modalTransitionStyle = .coverVertical
                vc.screentype = "Edit"
                vc.viewController = self
                vc.wishlistID = backlogData[sender.tag].id
                vc.list_name = backlogData[sender.tag].listName
                self.present(vc, animated: true)
                self.removeActivity(myView: (view)!)
            }else if item == "Delete" {
                print("WislistID-----",backlogData[sender.tag].id)
                deleteId = backlogData[sender.tag].id
                showAlertWithCompletion(title: "Alert", message: "Are you sure you want to delete", completion: {  UIAlertAction in
                    apiDeletewishList(id: self.backlogData[sender.tag].id)
                    
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WishListXboxVC") as! WishListXboxVC
        vc.List_Id = backlogData[indexPath.row].id
        vc.titleName = backlogData[indexPath.row].listName
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

//MARK: - Claass

class WishListCell:UITableViewCell{
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDrop: UIButton!
    
}

