//
//  ContactUsWebView.swift
//  Playnxt
//
//  Created by CP on 29/06/22.
//

import UIKit
import WebKit

class ContactUsWebView: UIViewController {
    
    //MARK: - IBOtleta
    @IBOutlet weak var webView: WKWebView!
    
    var urlContact:String?
    var privacyUrl:String?
    var screenType:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if screenType == "PRIVACY_POLICY"{
            webView.load(URLRequest(url: URL(string: privacyUrl ?? "")!))
            print("URL1111111111111........",(URLRequest(url: URL(string: privacyUrl ?? "")!)))
        }else {
            webView.load(URLRequest(url: URL(string: urlContact ?? "")!))
            print("URL........",(URLRequest(url: URL(string: urlContact ?? "")!)))
        }
       
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
