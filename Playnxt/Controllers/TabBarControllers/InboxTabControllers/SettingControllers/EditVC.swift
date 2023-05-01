//
//  EditVC.swift
//  Playnxt
//
//  Created by cano on 21/05/22.
//

import UIKit
import Alamofire
import SDWebImage

class EditVC: BaseViewController,UITextFieldDelegate{
    
    //MARK: - IBOutlet
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var imgProfile: DesignImage!
    @IBOutlet weak var imgUplod: UIImageView!
    //MARK: - Variable
    
    var name:String?
    var email:String?
    var imgPick:String?
    //MARK: - Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtName.attributedPlaceholder = NSAttributedString(string: "Anamwp ... ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 132/255, green: 133/255, blue: 137/255, alpha: 1.0)])
        txtName.text = name ?? ""
        txtEmail.text = email ?? ""
        txtName.delegate = self
        let urlBanner = URL(string: Constant.ImageUrl + (imgPick ?? ""))
        self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
    }
    
    
    override func didSelectedImage(selectedImage: UIImage) {
        imgProfile.image = selectedImage
    }
    
    //MARK: - Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = txtName.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                  return false
              }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 20
    }
    //MARK: - Api Calling
    func apiEditProfile(){
        
        //showActivity(myView: self.view, myTitle: "Loading...")
        let parameters:[String:Any] = ["name":txtName.text ?? "",
                                       "email":txtEmail.text ?? ""]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                
                multipartFormData.append((self.imgProfile.image!.jpegData(compressionQuality: 0.1)!), withName: "image" , fileName: "file.jpeg", mimeType: "image/jpeg")
                
                
            },
            to: Constant.URL_CONSTANT.Edit_Profile, method: .post , headers: SessionManager.shared.getHeader(reqCode:Constant.URL_CONSTANT.Edit_Profile, userToken: nil))
            .validate(statusCode: 200..<300)
            .response { resp in
                
                switch resp.result{
                case .failure(let error): break
                    
                case.success( _):
                    
                    print(resp.data)
                    let decoder = JSONDecoder()
                    let decoded = try? decoder.decode(CommonResponse.self, from: resp.data!)
                    let data = decoded
                    if !(decoded?.status)!{
                        self.showAlert(message: decoded?.message ?? "")
                        
                    }else {
                        //self.apiGetProfile()
                        self.showAlert(message: decoded?.message ?? "")
                    }
                    
                }
            }
    }
    //MARK: - Api
    
    func apiDelete(){
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Delete_Account, method: .post, parameter: nil, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Delete_Account, userToken: nil) { response in
            if response.status == true {
                print("Response",response)
                // self.showAlert(message: "Your account delete successfully")
                UserDefaults.standard.removeObject(forKey: Constant.Token)
                UserDefaults.standard.removeObject(forKey: "USER_LOGIN")
                UserDefaults.standard.removeObject(forKey: "User_ID")
                UserDefaults.standard.removeObject(forKey: "USER_SIGNUP")
                UserDefaults.standard.removeObject(forKey: "SUBSCRIBED")
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                print("Message",response.message)
            }
        }
    }
    
    //MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btncamera(_ sender: Any) {
        selectPhoto(isCircular: false)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        apiEditProfile()
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        showAlertWithCompletion(title: "Alert", message: "Are you sure you want to delete", completion: {  UIAlertAction in
            self.apiDelete()
        })
    }
    @IBAction func btnChangePass(_ sender:Any){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") else { return }
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
        //        self.removeActivity(myView: self.view)
    }
}
