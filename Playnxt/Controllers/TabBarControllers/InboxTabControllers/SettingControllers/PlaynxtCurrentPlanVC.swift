//
//  PlaynxtCurrentPlanVC.swift
//  Playnxt
//
//  Created by CP on 18/07/22.
//

import UIKit

class PlaynxtCurrentPlanVC: UIViewController {
    
    //MARK: -  IBOutlets
    
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCountdown: UILabel!
    @IBOutlet weak var lblShow: UILabel!
    
    
    //@IBOutlet weak var btnChange: RoundButton!
    @IBOutlet weak var btnBuy: RoundButton!
    @IBOutlet weak var btnRecurring: RoundButton!
    
    var plan : ActivePlan?
    var planData : ActiveData?
    var recurring:Int?
    var grace_taken:Int?
    var subs : CheckSubsData?
    var commonSub : CheckSubscription?
    var recurring_payment:String?
    var count:Int?
    
    let Subscribe = UserDefaults.standard.bool(forKey: "SUBSCRIBED")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // apiSubscription()
        apiActivePlan()
        
        
        if grace_taken == 1 {
            lblShow.isHidden = false
            lblCountdown.isHidden = false
            lblCountdown.text = "\(count ?? 0)"
            btnBuy.isHidden = false
            
        }else {
            if recurring_payment == "Yes"{
                btnRecurring.isHidden = false
            }else {
                btnRecurring.isHidden = true
            }
            lblShow.isHidden = true
            lblCountdown.isHidden = true
            btnBuy.isHidden = true
        }
    }
    
    //MARK: - Api Calling
    
    func apiActivePlan(){
        
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.My_Active_Plan, method: .post, parameter: nil, objectClass: ActivePlanRespo.self, requestCode: Constant.URL_CONSTANT.My_Active_Plan, userToken: nil) { [self] response  in
            if response.status == true {
                print("response",response)
                self.plan = response.data.activePlan
                self.planData = response.data
                self.lblEnd.text = plan?.endDate
                self.lblPlan.text = plan?.title
                self.lblPrice.text = "\(plan?.amount ?? 0)"
                self.lblStart.text = plan?.startDate
            }else {
                print("msg",response.message)
            }
        }
    }
    //MARK: -
    
  /*  func apiSubscription(){
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.My_Active_Plan, method: .post, parameter: nil, objectClass: ActivePlanRespo.self, requestCode: Constant.URL_CONSTANT.Check_Subscription, userToken: nil) { [self] response  in
            if response.status == true {
                print("Response",response)
                self.subs = response.data
                self.commonSub = response.data.subscription
                self.lblEnd.text = commonSub?.endDate
                self.lblPlan.text = commonSub
                self.lblPrice.text = "\(commonSub?.amount ?? 0)"
                self.lblStart.text = commonSub?.startDate
                self.lblDescription.text = commonSub?.subscriptionDescription
            }else {
                print("message",response.message)
            }
        }
    }*/
    
    func apiCancelSubscription(){
          SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.CANCEL_SUBSCRIPTION, method: .post, parameter: nil, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.CANCEL_SUBSCRIPTION, userToken: nil) { [self] response  in
              if response.status == true {
                  print("Response----",response)
                
                  guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelSubsPopupVC") else { return }
                  vc.modalPresentationStyle = .overFullScreen
                  vc.modalTransitionStyle = .crossDissolve
                  self.present(vc, animated: true)
                  self.removeActivity(myView: self.view)
                  
                  //self.showAlert(message: "Cancel Subscription Sucessfully")
                  
              }else {
                  print("mesage-----",response.message)
              }
          }
        
    }
    
    //MARK: -  Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   /* @IBAction func btnCancel(_ sender: Any) {
        showAlertWithCompletion(title: "Alert", message: "Are you sure you want to cancel subscription", completion: { [self]  UIAlertAction in
            apiCancelSubscription()
        })
    }*/
    
    @IBAction func btnBuySubs(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnCancelRecurring(_ sender: Any) {
        showAlertWithCompletion(title: "Alert", message: "Are you sure you want to cancel recurring", completion: { [self]  UIAlertAction in
            apiCancelSubscription()
        })
    }
}
