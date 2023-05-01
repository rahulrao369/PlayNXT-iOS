//
//  ApplyCouponVC.swift
//  Playnxt
//
//  Created by CP on 18/04/23.
//

import UIKit

class ApplyCouponVC: UIViewController {
    
 //MARK: - IBOutlets
    
    
    @IBOutlet weak var txtCoupon: TextField!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblFinalPrice: UILabel!
    @IBOutlet weak var stackSummery: UIStackView!
    @IBOutlet weak var btnNextHide : RoundButton!
    
    //MARK: - Variable
    
    var plan_id : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtCoupon.attributedPlaceholder = NSAttributedString(string: "Enter Coupon Code ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stackSummery.isHidden = true
        txtCoupon.text = ""
        btnNextHide.isHidden = true
    }
    
    //MARK: - Api calling
    
    func apiApplyCupon(){
        
       // showActivity(myView: self.view, myTitle: "Loading...")
        
        let param : [String:Any] = [ "plan_id":plan_id,
                                     "code":txtCoupon.text!]
        
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Cupon_Summery, method: .post, parameter: param, objectClass: PaymentSummery.self, requestCode: Constant.URL_CONSTANT.Cupon_Summery, userToken: nil) { [self] response in
            if response.status == true {
                print("Response---",response)
               // self.removeActivity(myView: self.view)
                self.btnNextHide.isHidden = false
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CuponPopupVC") else { return }
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
                
                    self.stackSummery.isHidden = false
                lblDiscount.text = response.data.discount
                lblFinalPrice.text =  "- " + "$"  + (response.data.finalprice)
                lblActualPrice.text = response.data.actualprice
            
                
            }else {
               
                print("msg---",response.message)
            }
        }
    }
    
    
  
    //MARK: - Button Action
    
    @IBAction func allBtnAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            // Back
        
            self.navigationController?.popViewController(animated: true)
            break
            
        case 1:
            // Apply
            if txtCoupon.text!.isEmpty {
                btnNextHide.isHidden = true
            }else {
                apiApplyCupon()
            }
            
           
            break
        case 2:
            // Next
            print("idd---",plan_id ?? 0)
            let vc = storyboard?.instantiateViewController(withIdentifier: "CardVC") as! CardVC
            vc.plan_id = plan_id
            vc.cuponCode = txtCoupon.text
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case 3:
            // Skip
            print("idd---",plan_id ?? 0)
            let vc = storyboard?.instantiateViewController(withIdentifier: "CardVC") as! CardVC
            vc.plan_id = plan_id
            vc.cuponCode = txtCoupon.text
            self.navigationController?.pushViewController(vc, animated: true)
            break
          
        default:
            break
        }
    }
    
}
