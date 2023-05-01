//
//  AddEventVC.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit
import DropDown

class AddEventVC: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var txtGameTitle: UITextField!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var btnDrop: UIButton!
    
    //MARK: - Variable
    
    var event_id:Int?
    var end_date:String?
    var start_date:String?
    var note:String?
    var event_title:String?
    var screenType:String?
    let dropDown = DropDown()
    
    //MARK: - ViewDidLoadd
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtStartDate.attributedPlaceholder = NSAttributedString(string: "Enter planned start date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtEndDate.attributedPlaceholder = NSAttributedString(string: "Enter planned end date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtGameTitle.attributedPlaceholder = NSAttributedString(string: "Select Game ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtNote.text = "Enter note here..."
        txtNote.textColor = UIColor.lightGray
        txtNote.font = UIFont(name: "Nunito Medium", size: 15)
        txtNote.returnKeyType = .done
        txtNote.delegate = self
        txtEndDate.delegate = self
        txtStartDate.delegate = self
        self.txtStartDate.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        self.txtEndDate.setInputViewDatePicker(target:  self, selector: #selector(done))
        txtStartDate.text = start_date
        if screenType == "Edit" {
            txtStartDate.text = start_date
            txtGameTitle.text = event_title
            txtNote.text = note
            txtEndDate.text = end_date
        }
    }
    
    //MARK: - Function
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtNote.text == "Enter note here..." {
            txtNote.text = ""
            txtNote.textColor = UIColor.lightGray
            txtNote.font = UIFont(name: "Nunito Medium", size: 15)
        }
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func tapDone() {
        if let datePicker = self.txtStartDate.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "yyyy-MM-dd"
            self.txtStartDate.text = dateformatter.string(from: datePicker.date)
        }
        self.txtStartDate.resignFirstResponder()
    }
    @objc func done() {
        if let datePicker = self.txtEndDate.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            
            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "yyyy-MM-dd"
            self.txtEndDate.text = dateformatter.string(from: datePicker.date)
        }
        self.txtEndDate.resignFirstResponder()
    }
    
    //MARK: - API Calling
    
    func apiAddEvent(){
        let param : [String:Any] = [
            "title":txtGameTitle.text!,
            "start_date":txtStartDate.text!,
            "end_date":txtEndDate.text!]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Add_Event, method: .post, parameter: param, objectClass: AddEvent.self, requestCode: Constant.URL_CONSTANT.Add_Event, userToken: nil) { response in
            if response.status == true {
                print("response-----",response)
                self.navigationController?.popViewController(animated: true)
            }else{
                print("message---",response.message)
            }
        }
    }
    //MARK: -
    
    func apiEditEvent(){
        let param : [String:Any] = [
            "event_id":event_id ?? 0,
            "title":event_title ?? "",
            "end_date":end_date ?? "",
            "start_date": start_date ?? ""]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Edit_Event, method: .post, parameter: param, objectClass: AddEvent.self, requestCode: Constant.URL_CONSTANT.Edit_Event, userToken: nil) { response in
            if response.status == true {
                print("Response-----",response)
                self.navigationController?.popViewController(animated: true)
            }else{
                print("message---",response.message)
            }
        }
    }
    
    //MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /* @IBAction func btnDown(_ sender: Any) {
     
     dropDown.anchorView = btnDrop
     dropDown.dataSource = ["Edit Name","Delete"]
     dropDown.show()
     dropDown.direction = .bottom
     dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
     print("Selected item: \(item) at index: \(index)")
     }
     }*/
    
    @IBAction func btnSave(_ sender: Any) {
        if screenType == "Edit"{
            apiEditEvent()
        }else if screenType == "Add"{
            apiAddEvent()
        }
        print("Event")
    }
}
