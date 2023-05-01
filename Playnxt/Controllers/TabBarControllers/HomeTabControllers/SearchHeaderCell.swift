//
//  SearchHeaderCell.swift
//  Playnxt
//
//  Created by cano on 03/06/22.
//

import UIKit

class SearchHeaderCell: UITableViewHeaderFooterView {
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnAddGame: UIButton!
    var viewController = SearchVC()
    //MARK:- ViewDidLoad
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    /* @IBAction func btnAdd(_ sender: Any) {
     if viewController.commonSub?.type == "Free" {
     if viewController.commonSub?.backlog == 1 {
     let vc = viewController.storyboard!.instantiateViewController(withIdentifier: "AddGameVC") as! AddGameVC
     self.viewController.navigationController?.pushViewController(vc, animated: true)
     }else {
     let vc = viewController.storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
     viewController.navigationController?.pushViewController(vc, animated: true)
     }
     }else if viewController.commonSub?.type == "Paid"{
     let vc = viewController.storyboard!.instantiateViewController(withIdentifier: "AddGameVC") as! AddGameVC
     self.viewController.navigationController?.pushViewController(vc, animated: true)
     }else {
     let vc = viewController.storyboard!.instantiateViewController(withIdentifier: "PlaynxtPremiumVC") as! PlaynxtPremiumVC
     viewController.navigationController?.pushViewController(vc, animated: true)
     }
     
     }*/
}
