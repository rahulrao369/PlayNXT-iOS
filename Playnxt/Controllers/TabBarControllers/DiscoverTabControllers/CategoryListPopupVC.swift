//
//  CategoryListPopupVC.swift
//  Playnxt
//
//  Created by CP on 10/06/22.
//

import UIKit
import Alamofire

class CategoryListPopupVC: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    //MARK: - Variable
    
    var cat = [Backlog]()
    var viewController = AddGameVC()
    var Controller = GameInfoVC()
    var categoryType:String?
    var screnType:String?
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTable.dataSource = self
        categoryTable.delegate = self
        
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
                self.cat = response.data.backlog
                self.categoryTable.reloadData()
                self.removeActivity(myView: self.view)
            }else {
                print("message--",response.message)
            }
        }
    }
    //MARK: - Button Action
    
    @IBAction func btnCreate(_ sender: Any) {
      //  if screnType == "GameInfo"{
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupAddBacklogVC") as! PopupAddBacklogVC
            vc.modalTransitionStyle = .coverVertical
            vc.screenType = "AddBackLogList"
            vc.Controller = self
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
        else if screnType == "GameInfo" {
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
extension CategoryListPopupVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return cat.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "cell") as! categoryListTableCell
        
            let data = cat[indexPath.row]
            cell.lblCate.text = data.name
            cell.btnTick.tag = indexPath.row
            cell.btnTick.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            Singleton.sharedInstance.list_Name = cat[indexPath.row].name
            Singleton.sharedInstance.List_id = cat[indexPath.row].id
      
        return cell
    }
    
    @objc func connected(sender: UIButton){
        let path = IndexPath(item: sender.tag, section: 0)
        let cell = self.categoryTable.cellForRow(at: path) as? categoryListTableCell
        cell?.btnTick.isSelected.toggle()
       // if categoryType == "backlog" {
            if cell?.btnTick.isSelected == true{
                Singleton.sharedInstance.list_Name = cat[sender.tag].name
                Singleton.sharedInstance.List_id = cat[sender.tag].id
                print("ID , Name ----", Singleton.sharedInstance.list_Name ?? "", Singleton.sharedInstance.List_id ?? "")
            }else {
                Singleton.sharedInstance.list_Name?.removeAll()
                print("Remove----",Singleton.sharedInstance.list_Name ?? "")
            }
      //  }
        /*else {
            if cell?.btnTick.isSelected == true{
                Singleton.sharedInstance.list_Name = wish[sender.tag].name
                Singleton.sharedInstance.List_id = wish[sender.tag].id
                print("ID , Name ----", Singleton.sharedInstance.list_Name ?? "" , Singleton.sharedInstance.List_id ?? "")
            }else {
                Singleton.sharedInstance.list_Name?.removeAll()
                print("Remove----",Singleton.sharedInstance.list_Name ?? "")
            }
        }*/
    }
}
//MARK: - TableClass
class categoryListTableCell:UITableViewCell{
    
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var lblCate: UILabel!
}
