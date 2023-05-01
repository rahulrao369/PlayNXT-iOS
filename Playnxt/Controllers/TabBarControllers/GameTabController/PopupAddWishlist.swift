//
//  PopupAddWishlist.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit

class PopupAddWishlist: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var gestureView: RoundedCornerView!
    
    //MARK: - Variable
    
    var viewController = WishlistVC()
    var screentype:String?
    var wishlistID:Int?
    var list_name:String?
   // var Controller = CategoryListPopupVC()
    var VController = WishlistCreatePopupVc()
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        txtName.attributedPlaceholder = NSAttributedString(string: "Enter Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        //dismiss(animated: true)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.gestureView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.gestureView.addGestureRecognizer(swipeDown)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if screentype == "Edit"{
            txtName.text = list_name
        }
    }
    //MARK: - ButtonAction
    @IBAction func btnSave(_ sender: Any) {
        if screentype == "Create" {
            apiAddWishlist()
        }else if screentype == "Edit" {
            apiEditWishListList()
        }else if screentype == "Addwishlist" {
            apiAddWishlistGame()
        }else {
            print("Wishlist")
        }
    }
    @IBAction func btnView(_ sender: Any) {
        // dismiss(animated: true)
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
                //showAnimate()
            default:
                break
            }
        }
    }
    //MARK: - Api Calling
    func apiAddWishlist(){
        let param : [String:Any] = [
            "name":txtName.text!]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Add_Wishlist, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Add_Wishlist, userToken: nil) { response in
            if response.status == true {
                print("response-----",response)
                self.dismiss(animated: true)
                self.showAlert(message: "Create wishlist successfully")
                self.viewController.apiwishList()
            }else{
                print("message---",response.message)
            }
        }
    }
    
    func apiAddWishlistGame(){
        let param : [String:Any] = [
            "name":txtName.text!]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Add_Wishlist, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Add_Wishlist, userToken: nil) { response in
            if response.status == true {
                print("response-----",response)
                self.dismiss(animated: true)
                self.showAlert(message: "Create wishlist successfully")
                self.VController.apiGetCategory()
            }else{
                print("message---",response.message)
            }
        }
    }
    
    func apiEditWishListList(){
        showActivity(myView: self.view, myTitle: "Loading...")
        let param : [String:Any] = ["wishlist_id": wishlistID ?? 0 ,
                                    "wishlist_name":txtName.text ?? ""]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Edit_WishList, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Edit_WishList, userToken: nil) { response in
            if response.status == true{
                print("response-----",response)
                self.dismiss(animated: true)
                self.showAlert(message: "Edit wishlist successfully")
                self.viewController.apiwishList()
            }else {
                print("message--",response.message)
            }
        }
    }
}
