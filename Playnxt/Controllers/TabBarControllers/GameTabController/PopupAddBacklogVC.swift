//
//  PopupAddBacklogVC.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit

class PopupAddBacklogVC: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var gestureView: RoundedCornerView!
    //MARK: - Variable
    
    var screenType:String?
    var backlogId:Int?
    var viewController = BackLogVC()
    var Controller = CategoryListPopupVC()
   // var VController = WishlistCreatePopupVc()
    var list_name:String?
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        txtName.attributedPlaceholder = NSAttributedString(string: "Enter Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        
        self.showAnimate()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.gestureView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.gestureView.addGestureRecognizer(swipeDown)
        //dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if screenType == "Edit" {
            txtName.text = list_name
        }
    }
    
    
    //MARK: - ButtonAction
    @IBAction func btnSave(_ sender: Any) {
        if screenType == "Create" {
            apiAddBacklog()
        }else if screenType == "Edit" {
            apiEditBacklogList()
        }else if screenType == "AddBackLogList" {
            apiAddBacklogGame()
        }else {
            print("Backlog List")
        }
    }
    @IBAction func btnView(_ sender: Any) {
        //  dismiss(animated: true)
    }
    //MARK: - Functions
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        });
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.gestureView.removeFromSuperview()
            }
        });
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
            case .down:
                print("Swiped down")
                //  dismiss(animated: true)
                removeAnimate()
            case .left:
                print("Swiped left")
            case .up:
                print("Swiped up")
                // showAnimate()
            default:
                break
            }
        }
    }
    
    //MARK: - Api Calling
    func apiAddBacklog(){
        let param : [String:Any] = [
            "name":txtName.text!]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Add_BackLog_List, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Add_BackLog_List, userToken: nil) { response in
            if response.status == true {
                if response.message == "You dont have backlog free limit"{
                    self.showAlert(message: "You dont have free backlog limit")
                }else {
                    print("response-----",response)
                    self.dismiss(animated: true)
                    self.showAlert(message: "Crearte new backlog list successfully")
                    self.viewController.apiBacklogList()
                    // self.navigationController?.popViewController(animated: true)
                }
            }else{
                print("message---",response.message)
            }
        }
    }
    
    
    func apiAddBacklogGame(){
        let param : [String:Any] = [
            "name":txtName.text!]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Add_BackLog_List, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Add_BackLog_List, userToken: nil) { response in
            if response.status == true {
                if response.message == "You dont have backlog free limit"{
                    self.showAlert(message: "You dont have free backlog limit")
                }else {
                    print("response-----",response)
                    self.dismiss(animated: true)
                    self.showAlert(message: "Crearte new backlog list successfully")
                    self.Controller.apiGetCategory()
                    // self.navigationController?.popViewController(animated: true)
                }
            }else{
                print("message---",response.message)
            }
        }
    }
    
    func apiEditBacklogList(){
        showActivity(myView: self.view, myTitle: "Loading...")
        let param : [String:Any] = ["backlog_id":backlogId ?? 0,
                                    "backlog_name": txtName.text ?? ""]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Edit_BacklogList, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Edit_Profile, userToken: nil) { response in
            if response.status == true{
                print("response-----",response)
                self.dismiss(animated: true)
                self.showAlert(message: "Edit backlog list successfully")
                self.viewController.apiBacklogList()
                
            }else {
                print("message--",response.message)
            }
        }
    }
}
