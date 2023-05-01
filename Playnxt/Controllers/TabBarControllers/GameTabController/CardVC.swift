//
//  CardVC.swift
//  HairGo
//
//  Created by CW-01 on 25/03/22.
//

import UIKit
import Stripe
import CreditCardForm

class CardVC: UIViewController, STPPaymentCardTextFieldDelegate {
    
    @IBOutlet weak var creditCardView: CreditCardFormView!
    @IBOutlet weak var btnTap: UIButton!
    
    
    let paymentTextField = STPPaymentCardTextField()
    var cardHolderName = String()
    var cardNum = String()
    var expiryMont = UInt()
    var expiryYear = UInt()
    var cvc = String()
    var transtionId = Int()
    var plan_id : Int?
    var recurring: String?
    var cuponCode:String?
    
    @IBOutlet var successPopupView: UIView!
    
    private var cardHolderNameTextField: TextField!
    private var cardParams: STPPaymentMethodCardParams!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentTextField.postalCodeEntryEnabled = false
        createTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recurring = "0"
        print("cksdfhdefv.....",cuponCode)
    }
    
    func createTextField() {
        
        cardHolderNameTextField = TextField(frame: CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44))
        //cardHolderNameTextField.placeholder = "CARD HOLDER"
        cardHolderNameTextField.delegate = self
        cardHolderNameTextField.attributedPlaceholder = NSAttributedString(string: "CARD HOLDER", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        cardHolderNameTextField.textColor = .white
        cardHolderNameTextField.translatesAutoresizingMaskIntoConstraints = false
        cardHolderNameTextField.setBottomBorder()
        cardHolderNameTextField.addTarget(self, action: #selector(CardVC.textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(cardHolderNameTextField)
        
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.delegate = self
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        //paymentTextField.borderWidth = 0
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        
        view.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
            cardHolderNameTextField.topAnchor.constraint(equalTo: creditCardView.bottomAnchor, constant: 20),
            cardHolderNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardHolderNameTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-25),
            cardHolderNameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            paymentTextField.topAnchor.constraint(equalTo: cardHolderNameTextField.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
        
        self.cardNum = textField.cardNumber ?? ""
        self.expiryMont = UInt(textField.expirationMonth)
        self.expiryYear = UInt(textField.expirationYear)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
        
        self.cardHolderName = cardHolderNameTextField.text!
        self.cardNum = textField.cardNumber ?? ""
        self.expiryMont = UInt(textField.expirationMonth)
        self.expiryYear = UInt(textField.expirationYear)
        self.cvc = "\(textField.cvc ?? "")"
        
        print("self.cardHolderName111..\(self.cardHolderName)")
        print("self.cardNum111..\(self.cardNum)")
        print("self.expiryMont111..\(self.expiryMont)")
        print("self.expiryYear111..\(self.expiryYear)")
        print("self.cvc111..\(self.cvc)")
        
    }
    
    
    @IBAction func BackAction(_ sender: Any) {
        // backViewController()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        if isValidateFields(){
            apiPurchasePlan()
        }
    }
    
    @IBAction func btnCheck(_ sender: UIButton) {
        sender.isSelected.toggle()
        if btnTap.isSelected == true{
            self.recurring = "1"
            print("resurring---",recurring ?? "")
        }else {
            self.recurring = "0"
            print("resurring---",recurring ?? "")
        }
        
    }
    
    @IBAction func okAction(_ sender: Any) {
        //  HideSuccessPopup()
        /*appControllerManger.workerAppointmentsVC.camefromMenu = "yes"
         self.goToViewController(viewController: appControllerManger.workerAppointmentsVC)*/
        // backViewController()
    }
    
    //MARK: Funcation Calling
    
    func isValidateFields() -> Bool {
        
        if self.cardHolderName.isEmpty {
            self.showAlert(message: "Please enter card holder name.")
            return false
        }else if self.cardNum.isEmpty {
            self.showAlert(message: "Please enter card number.")
            return false
        }else if self.expiryMont == 0 {
            self.showAlert(message: "Please enter month")
            return false
        }else if self.expiryYear == 0 {
            self.showAlert(message: "Please enter year")
            return false
        }else if self.cvc.isEmpty {
            self.showAlert(message: "Please enter cvc")
            return false
        }
        return true
    }
}

extension CardVC: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        creditCardView.cardHolderString = textField.text!
        self.cardHolderName = cardHolderNameTextField.text!
        self.cardNum = paymentTextField.cardNumber ?? ""
        self.expiryMont = UInt(paymentTextField.expirationMonth)
        self.expiryYear = UInt(paymentTextField.expirationYear)
        self.cvc = "\(paymentTextField.cvc ?? "")"
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cardHolderNameTextField {
            textField.resignFirstResponder()
            paymentTextField.becomeFirstResponder()
        } else if textField == paymentTextField  {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension UITextField {
    
    func setBottomBorder() {
        self.borderStyle = UITextField.BorderStyle.none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

//MARK: API Calling

extension CardVC {
   
    func apiPurchasePlan(){
        showActivity(myView: self.view, myTitle: "Loading...")
        let param : [String:Any] = ["plan_id": plan_id ?? 0,
                                    "code":cuponCode ?? "",
                                    "name": cardHolderName,
                                    "card_number": cardNum,
                                    "month": expiryMont,
                                    "year": expiryYear,
                                    "cvv": cvc,
                                    "recurring":recurring ?? ""]
        print("yearr.....",expiryYear)
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Purchase_Plan, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Purchase_Plan, userToken: nil) { response  in
            if response.status == true {
                print("response",response)
                self.removeActivity(myView: self.view)
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "ConfirmVC") as! ConfirmVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                print("message",response.message)
            }
        }
    }
}


/*  func ShowSuccessPopup()
 {
 let appDelegate = UIApplication.shared.delegate as! AppDelegate
 
 appDelegate.window?.addSubview((successPopupView)!)
 successPopupView.frame = (appDelegate.window?.bounds)!
 
 UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
 self.successPopupView.isHidden = false
 self.successPopupView.alpha = 1
 }, completion: nil)
 
 }
 
 func HideSuccessPopup()
 {
 UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
 self.successPopupView.isHidden = true
 self.successPopupView.alpha = 0
 }, completion: nil)
 }
 
 }
 */
