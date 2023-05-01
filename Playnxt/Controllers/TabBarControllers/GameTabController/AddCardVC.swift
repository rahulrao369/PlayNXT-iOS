//
//  AddCardVC.swift
//  Playnxt
//
//  Created by CP on 16/07/22.
//

import UIKit

class AddCardVC: UIViewController,UITextFieldDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var txtCcv: UITextField!
    @IBOutlet weak var txtExpiring: UITextField!
    @IBOutlet weak var txtCardNo: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    //MARK: - variables
    
    var plan_id : Int?
    var expiryDate = Bool()
    var month:String?
    var year:String?
    
    //MARK: - ViewDidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        txtName.attributedPlaceholder = NSAttributedString(string: "Name of Card ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtExpiring.attributedPlaceholder = NSAttributedString(string: "MM/YY", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtCardNo.attributedPlaceholder = NSAttributedString(string: "Card No", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtCcv.attributedPlaceholder = NSAttributedString(string: "CVV", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtName.delegate = self
        txtCcv.delegate = self
        txtExpiring.delegate = self
        txtCardNo.delegate = self
        
    }
    
    //MARK: - Functions
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtExpiring{
            
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            let updatedText = oldText.replacingCharacters(in: r, with: string)
            
            if string == "" {
                if updatedText.count == 2 {
                    textField.text = "\(updatedText.prefix(1))"
                    return false
                }
            } else if updatedText.count == 1 {
                if updatedText > "1" {
                    return false
                }
            } else if updatedText.count == 2 {
                if updatedText <= "12" { //Prevent user to not enter month more than 12
                    textField.text = "\(updatedText)/" //This will add "/" when user enters 2nd digit of month
                }
                return false
            } else if updatedText.count == 5 {
                self.expDateValidation(dateStr: updatedText)
            } else if updatedText.count > 5 {
                return false
            }
            return true
        }
        return false
    }
    
    func expDateValidation(dateStr:String) {
        
        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)
        
        let enteredYear = Int(dateStr.suffix(2)) ?? 0 // get last two digit from entered string as year
        let enteredMonth = Int(dateStr.prefix(2)) ?? 0 // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user
        
        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                print("Entered Date Is Right")
                self.expiryDate = true
            } else {
                print("Entered Date Is Wrong")
                self.expiryDate = false
                
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                    print("Entered Year Is Right")
                    self.expiryDate = true
                    
                } else {
                    print("Entered Date Is Wrong")
                    showAlert(message: "Entered year Is Wrong")
                    self.expiryDate = false
                }
            } else {
                print("Entered Date Is Wrong")
                showAlert(message: "Entered year Is Wrong")
                self.expiryDate = false
                
            }
        } else {
            print("Entered Date Is Wrong Last")
            showAlert(message: "Entered year Is Wrong")
            self.expiryDate = false
        }
    }
    
    //MARK: - Button Actions
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        
        let username_array = (txtExpiring.text?.components(separatedBy: "/"))!
        print("Month",username_array[0])
        print("year",username_array[1])
        month = username_array[0]
        year = username_array[1]
        let vc = storyboard!.instantiateViewController(withIdentifier: "ConfirmVC") as! ConfirmVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
