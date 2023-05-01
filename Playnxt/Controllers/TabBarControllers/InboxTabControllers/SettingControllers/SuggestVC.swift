//
//  SuggestVC.swift
//  Playnxt
//
//  Created by cano on 25/05/22.
//

import UIKit

class SuggestVC: UIViewController,UITextViewDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var txtSuggest: UITextView!
    
    //MARK: -Variable
    
    var sugg : Suggest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        txtSuggest.text = "Write your suggestion here..."
        txtSuggest.textColor = UIColor.lightGray
        txtSuggest.font = UIFont(name: "Nunito-Light", size: 20)
        txtSuggest.returnKeyType = .done
        txtSuggest.delegate = self
    }
    //MARK: - Function
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write your suggestion here..." {
            textView.text = ""
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "Nunito-Light", size: 20)
        }
    }
    
    //MARK: - Api Calling
    
    func apiSuggest(){
        
        let param : [String:Any] = ["text":txtSuggest.text!]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Suggest_new_feature, method: .post, parameter: param, objectClass: Suggestion.self, requestCode: Constant.URL_CONSTANT.Suggest_new_feature, userToken: nil) { response in
            if response.status == true {
                print("response",response)
                self.sugg = response.data.suggest
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankyouPopupVC") else { return }
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
                self.removeActivity(myView: self.view)
                self.showAlert(message: "Your suggestion is submit")
            }else{
                print("mesage",response.message)
            }
        }
    }
    
    //MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubmit(_ sender: Any) {
        apiSuggest()
    }
}
