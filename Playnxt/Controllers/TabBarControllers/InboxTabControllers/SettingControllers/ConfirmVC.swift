//
//  ConfirmVC.swift
//  Playnxt
//
//  Created by cano on 25/05/22.
//

import UIKit

class ConfirmVC: UIViewController {
    
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiSubscription()
    }
    
    //MARK: -
    
    func apiSubscription(){
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Check_Subscription, method: .post, parameter: nil, objectClass: CheckSubsRespo.self, requestCode: Constant.URL_CONSTANT.Check_Subscription, userToken: nil) { response  in
            if response.status == true {
                print("Response",response)
                self.subs = response.data
                self.commonSub = response.data.subscription
                UserDefaults.standard.setValue(response.data.subscribed, forKey: "SUBSCRIBED")
            }else {
                print("message",response.message)
            }
        }
    }
    
    
    //MARK: - Button Action
    @IBAction func btnOk(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tab", bundle: nil)
        let myNav = storyboard.instantiateViewController(withIdentifier: "myNavigation") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = myNav
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
