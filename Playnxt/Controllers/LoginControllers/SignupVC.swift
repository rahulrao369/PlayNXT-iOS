//
//  SignupVC.swift
//  Playnxt
//
//  Created by cano on 19/05/22.
//

import UIKit
import Alamofire

class SignupVC: UIViewController,UITextFieldDelegate{
    
    //MARK: - IBOutlets
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var checkbtn: UIButton!
    @IBOutlet weak var checkBtn1: UIButton!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    
    //MARK: - variables
    
    var userId:Int?
    var strToken:String?
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtName.attributedPlaceholder = NSAttributedString(string: "Enter Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtName.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.removeObject(forKey: "SUBSCRIBED")
        if !Connectivity.isConnectedToInternet {
            self.showAlert(message: "Please check your internet connection")
            
            return
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignupVC.tapFunction))
        lblPrivacyPolicy.isUserInteractionEnabled = true
        lblPrivacyPolicy.addGestureRecognizer(tap)
    }
    
    //MARK: - Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = txtName.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                  return false
              }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 20
    }
    
    //MARK: -  Function
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working-----")
        let storyboard = UIStoryboard(name: "Tab", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactUsWebView") as! ContactUsWebView
        vc.privacyUrl = "https://playnxt.app/privacy-policy"
        vc.screenType = "PRIVACY_POLICY"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Button Action
    
    @IBAction func btnCircleLogin(_ sender: UIButton) {
        
        sender.isSelected.toggle()
    }
    
    /*@IBAction func btnCircleOTP(_ sender: UIButton) {
     sender.isSelected.toggle()
     }*/
    
    @IBAction func btnSignUp(_ sender: Any){
        //        UserDefaults.standard.set(true, forKey: "USER_SIGNUP")
        //        UserDefaults.standard.synchronize()
        // UserDefaults.standard.setValue(token, forKey: Constant.Token)
        if txtName.text?.isEmpty == true{
            showAlert(message: "Please enter name")
        }else if txtEmail.text?.isEmpty == true{
            showAlert(message: "Please enter email")
        }else if !txtEmail.text!.isValidEmail() {
            showAlert(message: "Please enter valid email")
        }else if checkbtn.isSelected == false {
            self.showAlert(message: "please select term & condition and privacy policies.")
        }else {
            apiRegister()
        }
        
    }
    
    @IBAction func btnAccount(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func passwordBtn(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected == true{
            txtPassword.isSecureTextEntry = false
        } else {
            txtPassword.isSecureTextEntry = true
        }
    }
    /*  @objc func textFieldDidChange(_ textField: UITextField) {
     if textField == txtPassword {
     print("Result--",txtPassword.text ?? "")
     //            self.searchTableView.reloadData()
     if !txtPassword.text!.isEmpty{
     apiRegister()
     }
     }else  {
     print("No Result")
     }
     
     }*/
    //MARK: - Api Calling
    
    func apiRegister(){
        //showActivity(myView: self.view, myTitle: "Loading...")
        let udid = getDeviceId()
        let param : [String:Any] = ["user_name":txtName.text!,
                                    "email":txtEmail.text!,
                                    "password":txtPassword.text!,
                                    "role":1,
                                    "device_token":udid,
                                    "fcm_token":"123456666"]
        
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Register, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Register, userToken: nil) { [self] response  in
            print("RESP",response)
            if response.status == true {
                /*self.strToken = response.data.token
                 self.userId = response.data.userID
                 print("-----",strToken)
                 UserDefaults.standard.setValue(strToken, forKey: Constant.Token)
                 UserDefaults.standard.set(userId, forKey: "User_ID")
                 print("user_id------",(UserDefaults.standard.string(forKey: "User_ID") ?? ""))
                 UserDefaults.standard.synchronize()*/
                
                
               // self.removeActivity(myView: self.view)
                
                UserDefaults.standard.set(true, forKey: "USER_SIGNUP")
                UserDefaults.standard.synchronize()
           
                self.showAlertWithOkComplitionHandler(message: response.message, buttonTitle: "OK") { action in
                    if action.title == "OK" {
                        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                /*  let storyboard = UIStoryboard(name: "Tab", bundle: nil)
                 let myNav = storyboard.instantiateViewController(withIdentifier: "myNavigation") as! UINavigationController
                 let appDelegate = UIApplication.shared.delegate as! AppDelegate
                 appDelegate.window?.rootViewController = myNav*/
                
            }else {
                
                print("MESG",response.message)
               
            }
        }
    }
    
}
