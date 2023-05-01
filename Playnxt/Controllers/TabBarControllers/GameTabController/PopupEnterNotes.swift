//
//  PopupEnterNotes.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit

class PopupEnterNotes: UIViewController,UITextViewDelegate {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var txtName: UITextView!
    @IBOutlet weak var gestureView: RoundedCornerView!
    
    //MARK: - Variable
    
    var gameId:Int?
    var noteId:Int?
    var screenType:String?
    var viewController = XboxGameInfoVC()
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        txtName.text = "Enter note here..."
        txtName.textColor = UIColor.lightGray
        txtName.font = UIFont(name: "Nunito Regular", size: 15)
        txtName.returnKeyType = .done
        txtName.delegate = self
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.gestureView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.gestureView.addGestureRecognizer(swipeDown)
        //dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - ButtonAction
    @IBAction func btnSave(_ sender: Any) {
        if screenType == "Add"{
            apiAddNote()
        }
        else {
            apiNewNote()
        }
    }
    @IBAction func btnView(_ sender: Any) {
        //  dismiss(animated: true)
    }
    
    //MARK: - Api Calling
    
    func apiAddNote(){
        let param:[String:Any] = ["game_id":gameId ?? 0,
                                  "note": txtName.text ?? ""]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Add_Note, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Add_Note, userToken: nil) { response in
            if response.status == true {
                print("Response ===",response)
                self.dismiss(animated: true)
                self.viewController.apiGetNote()
                self.showAlert(message: "Crearte note successfully")
                
            }else {
                print("Message===",response.message)
            }
        }
    }
    func apiNewNote(){
        let param:[String:Any] = ["game_id":gameId ?? 0,
                                  "note_id":noteId ?? 0,
                                  "newnote":txtName.text ?? ""]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Edit_Game_Note, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Edit_Game_Note, userToken: nil) { response in
            if response.status == true {
                print("Response ===",response)
                self.dismiss(animated: true)
                self.viewController.apiGetNote()
                self.showAlert(message: "Edit note successfully")
                
            }else {
                print("Message===",response.message)
            }
        }
    }
    
    //MARK: - Function
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter note here..." {
            textView.text = ""
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "Nunito Regular", size: 15)
        }
    }
    
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
                self.gestureView.removeFromSuperview()
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
}
