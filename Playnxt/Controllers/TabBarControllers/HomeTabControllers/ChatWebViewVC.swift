//
//  ChatWebViewVC.swift
//  Playnxt
//
//  Created by CP on 22/07/22.
//

import UIKit
import WebKit
import SDWebImage

class ChatWebViewVC: UIViewController {
    
    //MARK: - IBOtleta
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: DesignImage!
    var frndName:String?
    var img:String?
    var urlContact:String?
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        webView.load(URLRequest(url: URL(string: "https://playnxt.app/webview/chat?uuid=\(Int(UserDefaults.standard.string(forKey: "User_ID") ?? "") ?? 0)&receiver_id=\(Singleton.sharedInstance.reciver_id ?? 0)") ?? URL(fileURLWithPath: "")))
        
        print("user_id ===",(UserDefaults.standard.string(forKey: "User_ID") ?? ""))
        print("reciver_id ===",(Singleton.sharedInstance.reciver_id ?? 0))
        lblName.text = frndName ?? ""
        let urlBanner = URL(string: Constant.ImageUrl + (img ?? ""))
        imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgProfile.sd_setImage(with: urlBanner, placeholderImage: UIImage(named: "user_img"), options: .refreshCached, context: nil)
    }
    
    //MARK: - Button action
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
