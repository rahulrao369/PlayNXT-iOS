//
//  SettingVC.swift
//  Playnxt
//
//  Created by cano on 21/05/22.
//

import UIKit
import StoreKit
import MessageUI

class SettingVC: UIViewController,MFMailComposeViewControllerDelegate {
    
    //MARK: - Variable
    
    var contactUrl:String?
    var aboutUrl:String?
    let Subscribe = UserDefaults.standard.bool(forKey: "SUBSCRIBED")
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        apiSubscription()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //apiContactUS()
        //apiAbout()
        
    }
    
    //MARK: - Api Calling
    
    func apiLogout(){
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Logout, method: .post, parameter: nil, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Logout, userToken: nil) { response  in
            if response.status == true {
                print("Response---",response)
                
                UserDefaults.standard.removeObject(forKey: Constant.Token)
                UserDefaults.standard.removeObject(forKey: "USER_LOGIN")
                UserDefaults.standard.removeObject(forKey: "User_ID")
                UserDefaults.standard.removeObject(forKey: "USER_SIGNUP")
                UserDefaults.standard.removeObject(forKey: "SUBSCRIBED")
                Singleton.sharedInstance.lat = ""
                Singleton.sharedInstance.long = ""
                Singleton.sharedInstance.list_Name = ""
                Singleton.sharedInstance.List_id = 0
                Singleton.sharedInstance.category_type = ""
                Singleton.sharedInstance.frndUserID = 0
                Singleton.sharedInstance.response = ""
                Singleton.sharedInstance.homeResponse = ""
                Singleton.sharedInstance.profileImg = ""
                Singleton.sharedInstance.gameName = ""
                Singleton.sharedInstance.gameRating = 0.0
                Singleton.sharedInstance.pass_status = ""
                Singleton.sharedInstance.reciver_id = 0
                Singleton.sharedInstance.remaning = 0
                    //self.apiSubscription()
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let navigationController = UINavigationController(rootViewController: newViewController)
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.window!.rootViewController = navigationController
            }else {
                print("message",response.message)
            }
        }
    }
    
    //MARK: -
    
    func apiSubscription(){
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Check_Subscription, method: .post, parameter: nil, objectClass: CheckSubsRespo.self, requestCode: Constant.URL_CONSTANT.Check_Subscription, userToken: nil) { [self] response  in
            if response.status == true {
                print("Response",response)
                self.subs = response.data
                self.commonSub = response.data.subscription
                if subs?.remainingDays == 0 {
                    UserDefaults.standard.removeObject(forKey: "SUBSCRIBED")
                }
                UserDefaults.standard.setValue(response.data.subscribed, forKey: "SUBSCRIBED")
                
            }else {
                print("message",response.message)
            }
        }
    }
    
    
    //MARK: -

    //MARK: - function
    
     @objc func shareTapped() {
        // guard let image = imgShare.image?.jpegData(compressionQuality: 0.8) else {
     print("No image found")
     return
     //}
      
         let messageStr:String  = "Hey check out all the games I have in my backlog!"
            let shareItems:Array = [messageStr] as [Any]
         
         let vc = UIActivityViewController(activityItems: shareItems , applicationActivities: [])
     vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
     present(vc, animated: true)
     }
    
    
    /*func apiContactUS(){
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Contact_US, method: .post, parameter: nil, objectClass: ContactUs.self, requestCode: Constant.URL_CONSTANT.Contact_US, userToken: nil) { response  in
            if response.status == true {
                print("Response ",response)
                self.contactUrl = response.data.contactUs
                
            }else {
                print("message",response.message)
            }
        }
    }
    
    //MARK: -
    
    func apiAbout(){
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.About_us, method: .post, parameter: nil, objectClass: AboutUs.self, requestCode: Constant.URL_CONSTANT.About_us, userToken: nil) { response  in
            if response.status == true{
                print("response---",response)
                self.aboutUrl = "https://www.trblclef.com/company/"
            }else{
                print("Message ",response.message)
            }
        }
    }*/
    
    //MARK: -  Function
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if (NSURL(string: urlString) != nil) {
                return true
            }
        }
        return false
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    
    //MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPremimun(_ sender: Any) {
        
        if Subscribe == true {
            let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtCurrentPlanVC") as! PlaynxtCurrentPlanVC
            vc.recurring = commonSub?.recurring
            vc.grace_taken = commonSub?.graceTaken
            vc.recurring_payment = commonSub?.recurringPayment
            vc.count = subs?.remainingDays
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    @IBAction func btnStartup(_ sender: Any) {
    }
    
    @IBAction func btnFeatures(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "SuggestVC") as! SuggestVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnContactUS(_ sender: Any) {
        //let esfgds = verifyUrl(urlString: contactUrl)
        
        if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients(["admin@trblclef.com"])
                    //mail.setSubject("Email Subject Here")
                    //mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
                    present(mail, animated: true)
                } else {
                    print("Application is not able to send an email")
                }
        
        
       /* if verifyUrl(urlString: contactUrl){
            let vc = storyboard!.instantiateViewController(withIdentifier: "ContactUsWebView") as! ContactUsWebView
            vc.urlContact = contactUrl
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            showAlert(message: "Invalid URL!!")
        }*/
    }
    
    @IBAction func btnAboutUs(_ sender: Any) {
        
            let vc = storyboard!.instantiateViewController(withIdentifier: "ContactUsWebView") as! ContactUsWebView
            vc.urlContact = "https://www.trblclef.com/company/"
            self.navigationController?.pushViewController(vc, animated: true)
      
    }
    @IBAction func btnPlay(_ sender: Any) {
        
       guard let secne = view.window?.windowScene else {
            print("no secne ")
           return
        }
        if #available(iOS 14.0, *) {
            SKStoreReviewController.requestReview(in: secne)
        } else {
            // Fallback on earlier versions
        }
    }
     /*   let text = " Rate Playnxt \n https://apps.apple.com/us/app/playnxt/id6444549960"
               
               // set up activity view controller
               let textToShare = [ text ]
               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
               
               // exclude some activity types from the list (optional)
               activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
               
               // present the view controller
               self.present(activityViewController, animated: true, completion: nil)
        
    }*/
    
    @IBAction func btnInvite(_ sender: Any) {
//shareTapped()
        
        let text = "Hey check out all the games I have in my backlog! \n https://apps.apple.com/us/app/playnxt/id6444549960"

               
               // set up activity view controller
        let textToShare = [text]
               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
               
               // exclude some activity types from the list (optional)
               activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
               
               // present the view controller
               self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnPrivacy(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "ContactUsWebView") as! ContactUsWebView
        vc.privacyUrl = "https://playnxt.app/privacy-policy"
        vc.screenType = "PRIVACY_POLICY"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        showAlertWithCompletion(title: "Alert", message: "Are you sure you want to logout", completion: { [self]  UIAlertAction in
            apiLogout()
        })
    }
    
}
