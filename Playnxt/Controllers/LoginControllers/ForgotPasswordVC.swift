//
//  ForgotPasswordVC.swift
//  Playnxt
//
//  Created by CP on 13/07/22.
//

import UIKit

class ForgotPasswordVC: UIViewController,UITextFieldDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        txtEmail.delegate = self
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])

    }
    
    //MARK: - Api Calling
    
    func apiForgotPassword(){
        
        let param:[String:Any] = ["email":txtEmail.text!]
        
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Forgot_Password, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Forgot_Password, userToken: nil) { response  in
            if response.status == true {
            print("RESPO---- ",response)
                    self.showAlert(message: "Link has sent to your mail.")
            }else {
                print(response.message)
            }
        }
    }
   
    //MARK: - button action
    
    @IBAction func btnSend(_ sender: Any) {
        apiForgotPassword()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
