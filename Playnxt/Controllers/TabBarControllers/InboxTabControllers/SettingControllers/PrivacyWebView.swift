//
//  PrivacyWebView.swift
//  Playnxt
//
//  Created by CP on 08/12/22.
//

import UIKit
import WebKit

class PrivacyWebView: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var privacyUrl:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.load(URLRequest(url: URL(string: privacyUrl ?? "")!))
        print("URL1111111111111........",(URLRequest(url: URL(string: privacyUrl ?? "")!)))
        
    }
    


}
