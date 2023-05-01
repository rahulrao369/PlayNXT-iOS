//
//  statusVC.swift
//  Playnxt
//
//  Created by cano on 26/05/22.
//

import UIKit

class StatusVC: UIViewController {
    
    //MARK: - IBOutlets
    
    
    @IBOutlet weak var lblTotalGame: UILabel!
    @IBOutlet weak var lblAverate: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblBreakCount: UILabel!
    @IBOutlet weak var lblCurrentPlaying: UILabel!
    @IBOutlet weak var lblCompleted: UILabel!
    @IBOutlet weak var lblRolledCredit: UILabel!
    @IBOutlet weak var lblShelfCount: UILabel!
    @IBOutlet weak var lblWishlistCount: UILabel!
    @IBOutlet weak var lblBacklogCount: UILabel!
    
    //MARK: - Variables
    
    var stats : StatsData?
    var statsNew = [String:Any]()

    let status:[Status] = [Status(name: "Total On the Shelf ", num1: "30", num2: "30"),Status(name: "% vs. total games in backlog", num1: "15", num2: "20%"),Status(name: "Total Currently Playing ", num1: "40", num2: "40")]
    let sts:[Status] = [Status(name: "Total currently playing/month ", num1: "40", num2: "40"),Status(name: "% vs. total games in backlog", num1: "25", num2: "20%")]
    let status1 : [Status] = [Status(name: "Total Finished", num1: "15", num2: "15"),Status(name: "Total Finished/Month", num1: "04", num2: "04"),Status(name: "% vs. total games in backlog", num1: "06", num2: "10%")]
    
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        apiStats()
    }
    
    //MARK: - API Calling
    
    func apiStats(){
        
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Stats, method: .post, parameter: nil, objectClass: StatsResponse.self, requestCode: Constant.URL_CONSTANT.Stats, userToken: nil) { [self] response in
            if response.status == true {
                print("response",response)
                
                self.stats = response.data
                
                self.lblRating.text = "\(stats?.ratingtotal ?? 0)"
               // self.lblAverate.text = "\(stats?.avgrate ?? 0)"
                self.lblCompleted.text = "\(stats?.completedcount ?? 0)"
                self.lblTotalGame.text = "\(stats?.totalgames ?? 0)"
                self.lblBreakCount.text = "\(stats?.takingbreakcount ?? 0)" + " %"
                self.lblShelfCount.text = "\(stats?.ontheshelfcount ?? 0)" + " %"
                self.lblBacklogCount.text = "\(stats?.backlogcount ?? 0)"
                self.lblRolledCredit.text = "\(stats?.rolledcreditcount ?? 0)" + " %"
                self.lblWishlistCount.text =  "\(stats?.wishlistcount ?? 0)"
                self.lblCurrentPlaying.text = "\(stats?.currentplayingcount ?? 0)" + " %"
                
            }else {
                print("message",response.message)
            }
        }
    }
    
    
    //MARK: - ButtonAction
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnShare(_ sender: Any) {
    }
}


