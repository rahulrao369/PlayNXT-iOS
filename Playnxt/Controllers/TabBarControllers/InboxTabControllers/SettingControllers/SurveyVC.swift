//
//  SurveyVC.swift
//  Playnxt
//
//  Created by cano on 21/05/22.
//

import UIKit

class SurveyVC: UIViewController,UITextViewDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var txtSurvey: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        txtSurvey.text = "Survey for why user is deleting...."
        txtSurvey.textColor = UIColor.lightGray
        txtSurvey.font = UIFont(name: "Nunito Bold", size: 22)
        txtSurvey.returnKeyType = .done
        txtSurvey.delegate = self
        
    }
    //MARK:- Function
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Survey for why user is deleting...." {
            textView.text = ""
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "Nunito Bold", size: 22)
        }
    }
    //MARK:- Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
    }
}
