//
//  PlaynxtPremiumVC.swift
//  Playnxt
//
//  Created by CP on 15/07/22.
//

import UIKit

class PlaynxtPremiumVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    
    
    //MARK: - Variable
    
    var plan = [PremiumSubscriptionPlan]()
    var screen_type : String?
    //MARK: - ViewDidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiPremiumPlan()
    }
    
    //MARK: - Api calling
    
    func apiPremiumPlan(){
        
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Premium_Plan, method: .post, parameter: nil, objectClass: PremiumSubscriptionRespo.self, requestCode: Constant.URL_CONSTANT.Premium_Plan, userToken: nil) { response in
            if response.status == true {
                print("Response---",response)
                self.plan = response.data.plan
                self.lblYear.text = "$\(self.plan[1].price) per year "
                self.lblMonth.text = "$\(self.plan[0].price) per month"
            }else {
                print("msg---",response.message)
            }
        }
    }
    
    
    //MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        
        if screen_type == "Subscribe" {
            let storyboard = UIStoryboard(name: "Tab", bundle: nil)
            let myNav = storyboard.instantiateViewController(withIdentifier: "myNavigation") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = myNav
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
   
    @IBAction func btnMonthPay(_ sender: Any) {
        
       /* print("idd---",plan[0].id)
        let vc = storyboard?.instantiateViewController(withIdentifier: "CardVC") as! CardVC
        vc.plan_id = plan[0].id
        self.navigationController?.pushViewController(vc, animated: true)*/
        let vc = storyboard?.instantiateViewController(withIdentifier: "ApplyCouponVC") as! ApplyCouponVC
        vc.plan_id = plan[0].id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnYrlyPay(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ApplyCouponVC") as! ApplyCouponVC
        vc.plan_id = plan[1].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
