//
//  PopupSelectStatus.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit

class PopupSelectStatus: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var lblTaking: UILabel!
    @IBOutlet weak var lblComplete: UILabel!
    @IBOutlet weak var lblRolled: UILabel!
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var lblOnShelf: UILabel!
    @IBOutlet weak var btnOnshelf: UIButton!
    @IBOutlet weak var btnCurrently: UIButton!
    @IBOutlet weak var btnStory: UIButton!
    @IBOutlet weak var btnBreak: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var gestureView: RoundedCornerView!
    
    //MARK: - variable
    
    var status:String?
    var gameID:Int?
    var viewController = XboxGameInfoVC()
    var checkSatus:String?
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.gestureView.addGestureRecognizer(swipeUp)
        self.showAnimate()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.gestureView.addGestureRecognizer(swipeDown)
        //dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  status?.removeAll()
        
        if checkSatus == "On the shelf"{
            btnOnshelf.setImage(UIImage(named: "Right-icon"), for: .normal)
        }else if checkSatus == "Currently playing"{
            btnCurrently.setImage(UIImage(named: "Right-icon"), for: .normal)
        } else if checkSatus == "Rolled Credits"{
            btnStory.setImage(UIImage(named: "Right-icon"), for: .normal)
        }else if checkSatus == "100% completed"{
            btnComplete.setImage(UIImage(named: "Right-icon"), for: .normal)
        }else if checkSatus == "Taking break"{
            btnBreak.setImage(UIImage(named: "Right-icon"), for: .normal)
        }else {
            btnOnshelf.setImage(UIImage(named: ""), for: .normal)
            btnBreak.setImage(UIImage(named: ""), for: .normal)
            btnStory.setImage(UIImage(named: ""), for: .normal)
            btnComplete.setImage(UIImage(named: ""), for: .normal)
            btnCurrently.setImage(UIImage(named: ""), for: .normal)
        }
    }
    
    //MARK: - ButtonAction
    
    @IBAction func btnView(_ sender: Any) {
        // dismiss(animated: true)
    }
    
    @IBAction func btnShelf(_ sender: UIButton) {
        sender.isSelected.toggle()
        status = lblOnShelf.text
        print("Status-----",status ?? "")
        apiSelectStatus()
        dismiss(animated: true)
    }
    @IBAction func btnCurrently(_ sender: UIButton) {
        sender.isSelected.toggle()
        status = lblCurrent.text
        print("Status-----",status ?? "")
        apiSelectStatus()
        dismiss(animated: true)
    }
    
    @IBAction func btnStory(_ sender: UIButton) {
        sender.isSelected.toggle()
        status = lblRolled.text
        print("Status-----",status ?? "")
        apiSelectStatus()
        dismiss(animated: true)
    }
    
    @IBAction func btnComplete(_ sender: UIButton) {
        sender.isSelected.toggle()
        status = lblComplete.text
        print("Status-----",status ?? "")
        apiSelectStatus()
        dismiss(animated: true)
    }
    
    @IBAction func btnTaking(_ sender: UIButton) {
        sender.isSelected.toggle()
        status = lblTaking.text
        print("Status-----",status ?? "")
        apiSelectStatus()
        dismiss(animated: true)
    }
    
    //MARK: -
    
    func apiSelectStatus(){
        let param : [String:Any] = ["game_id":gameID ?? 0,
                                    "status":status ?? ""]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Add_Game_Status, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Add_Game_Status, userToken: nil) { response in
            if response.status == true{
                print("response",response)
                self.viewController.apiGameInfo()
                self.showAlert(message: "Update status successfully")
            }else {
                print("message",response.message)
            }
        }
    }
    
    //MARK: - Functions
    
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
                //  dismiss(animated: true)
                removeAnimate()
            case .left:
                print("Swiped left")
            case .up:
                print("Swiped up")
                //showAnimate()
            default:
                break
            }
        }
    }
}
