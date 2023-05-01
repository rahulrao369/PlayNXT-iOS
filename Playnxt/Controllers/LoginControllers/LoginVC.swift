//
//  LoginVC.swift
//  Playnxt
//
//  Created by cano on 19/05/22.
//

import UIKit
import Alamofire

class LoginVC: UIViewController{
    
    //MARK: - IBOutlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //MARK: - ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !Connectivity.isConnectedToInternet {
            self.showAlert(message: "Please check your internet connection")
               return
           }
    }
    //MARK: - Button Action
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tab", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnkeepSigning(_ sender: UIButton) {
      
        sender.isSelected.toggle()
    }
    @IBAction func btnLogin(_ sender: Any) {
       
        apiLogin()
        
        // apiLogin()
    }
    @IBAction func btnAccount(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(identifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func passwordBtn(_ sender: UIButton){
        sender.isSelected.toggle()
        if sender.isSelected == true{
            txtPassword.isSecureTextEntry = false
        } else {
            txtPassword.isSecureTextEntry = true
        }
    }
    
    //MARK: - Api Calling
    
    func apiLogin(){
        
        let udid = getDeviceId()
        let param : [String:Any] = ["email":txtEmail.text!,
                                    "password":txtPassword.text!,
                                    "role":1,
                                    "lat": "00",
                                    "long": "00",
                                    "device_token": udid,
                                    "fcm_token":"123456666"]
        
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Login, method: .post, parameter: param, objectClass: Login.self, requestCode: Constant.URL_CONSTANT.Login, userToken: nil) { response  in
            if response.status == true {
                print("RESP",response)
                
                if response.message == "email and password does not matched."{
                    self.showAlert(message: "your email and password do not match please try again.")
                }else {
                   
                    if response.data.accountStatus == "active" {
                        
                        UserDefaults.standard.set(true, forKey: "USER_LOGIN")
                        print("USER_LOGIN........",UserDefaults.standard.set(true, forKey: "USER_LOGIN"))
                        UserDefaults.standard.removeObject(forKey: "USER_SIGNUP")
                        print("removeee.......",UserDefaults.standard.removeObject(forKey: "USER_SIGNUP"))
                        UserDefaults.standard.synchronize()
                        UserDefaults.standard.setValue(response.data.token, forKey: Constant.Token)
                        UserDefaults.standard.set(response.data.userID, forKey: "User_ID")
                        print("user_id------",(UserDefaults.standard.string(forKey: "User_ID") ?? ""))
                        UserDefaults.standard.synchronize()
                        
                        let storyboard = UIStoryboard(name: "Tab", bundle: nil)
                    let myNav = storyboard.instantiateViewController(withIdentifier: "myNavigation") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = myNav
                    }else {
                        self.showAlertWithResendCompletion(title: "Alert", message: "Your account is not verified yet. Please verify by your email.", completion: { [self] UIAlertAction in
                           apiResendEmail()
                        })
                    }
                    
                }
            }else {
                print("MESG",response.message)
            }
            
        }
    }
    
    //MARK: -  Resend Email verification api
    
    func apiResendEmail(){
        showActivity(myView: self.view, myTitle: "Loading...")
        let param : [String:Any] = ["email":txtEmail.text!]
        
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Resend_email, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Resend_email, userToken: nil) { response in
            if response.status == true {
                self.removeActivity(myView: self.view)
                self.showAlert(message: response.message)
            }else {
                print("Resend email...........",response.message)
            }
        }
        
    }
    
}
