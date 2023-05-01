//
//  ChangePasswordVC.swift
//  Playnxt
//
//  Created by CP on 09/06/22.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtOldPass: UITextField!
    //MARK: -  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        txtNewPass.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtOldPass.attributedPlaceholder = NSAttributedString(string: "Old Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtConfirmPass.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    //MARK: - Function
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
                self.view.removeFromSuperview()
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
                //dismiss(animated: true)
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
    
    //MARK: - Api calling
    
    func apiChangePassword(){
        let param:[String:Any] = [
            "oldpass":txtOldPass.text ?? "",
            "newpass":txtNewPass.text ?? ""]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Change_password, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Change_password, userToken: nil) { response in
            print( "Response  --------",response)
            if response.status == true  {
                self.showAlert(message: "Password change successfully")
                self.dismiss(animated: true)
                
            }else {
                print( "message --------",response.message)
            }
        }
    }
    //MARK: - Button Action
    
    @IBAction func btnchange(_ sender: Any) {
        if txtNewPass.text !=  txtConfirmPass.text {
            showAlert(message: "Password not match")
        }else {
            apiChangePassword()
            
        }
    }
    
    @IBAction func btnOld(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected == true{
            txtOldPass.isSecureTextEntry = false
        } else {
            txtOldPass.isSecureTextEntry = true
        }
    }
    @IBAction func btnNewPass(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected == true{
            txtNewPass.isSecureTextEntry = false
        } else {
            txtNewPass.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnConfirmPass(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected == true{
            txtConfirmPass.isSecureTextEntry = false
        } else {
            txtConfirmPass.isSecureTextEntry = true
        }
    }
}
