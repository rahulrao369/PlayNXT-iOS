//
//  PremiumVC.swift
//  Playnxt
//
//  Created by cano on 25/05/22.
//

import UIKit

class PremiumVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblAnnual: UILabel!
    @IBOutlet weak var dashView1: UIView!
    @IBOutlet weak var dashView2: UIView!
    @IBOutlet weak var dashView3: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var dataTblView: UITableView!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblAnual: UILabel!
    @IBOutlet weak var btnAnual: UIButton!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    //MARK:- Variables
    var prim : [Premium] = [Premium(name: "Ad-Free Experience", img: "cross_icon", non: "1 Only", prim: "1 Only", imgRight: "greenRight_icon"),Premium(name: "Manage Backlogs", img: "cross_icon", non: "1 Only ", prim: "Unlimited", imgRight: "greenRight_icon"),Premium(name: "Manage Wishlists", img: "cross_icon", non: "1 Only ", prim: "Unlimited", imgRight: "greenRight_icon"),Premium(name: "Calendar Tool ", img: "cross_icon", non: "1 Only ", prim: "Unlimited", imgRight: "greenRight_icon"),Premium(name: "Personal Stats", img: "cross_icon", non: "1 Only ", prim: "Unlimited", imgRight: "greenRight_icon"),Premium(name: "View Community Activity", img: "cross_icon", non: "", prim: "Unlimited", imgRight: "greenRight_icon"),Premium(name: "Follow Friends", img: "cross_icon", non: "1 Only ", prim: "Unlimited", imgRight: "greenRight_icon"),Premium(name: "View Friend Backlog and Wishlists ", img: "cross_icon", non: "1 Only ", prim: "Unlimited", imgRight: "greenRight_icon"),Premium(name: "Message Friends", img: "cross_icon", non: "1 Only ", prim: "Unlimited", imgRight: "greenRight_icon"),Premium(name: "Barcode Scanning Tool (coming soon) ", img: "cross_icon", non: "", prim: "Unlimited", imgRight: "greenRight_icon"),Premium(name: "Early Access to New Features", img: "cross_icon", non: "1 Only ", prim: "Unlimited", imgRight: "greenRight_icon")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lblPrice.text = "$40"
        lblAnnual.text = "Monthly"
        // dashView1.addLineDashedStroke(pattern: [5, 5], radius: 0, color: UIColor.gray.cgColor)
        // dashView2.addLineDashedStroke(pattern: [5,5], radius: 0, color: UIColor.gray.cgColor)
        //dashView3.addLineDashedStroke(pattern: [3, 3], radius: 0, color: UIColor.gray.cgColor)
        
    }
    //MARK:- Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCheckOut(_ sender: Any) {
        
    }
    @IBAction func btnMonthly(_ sender: UIButton) {
        lblPrice.text = "$40"
        lblAnnual.text = "Monthly"
        btnAnual.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for:UIControl.State.normal)
        btnMonth.setTitleColor(#colorLiteral(red: 0.8862745098, green: 0.4196078431, blue: 0.262745098, alpha: 1), for:UIControl.State.normal)
        // sender.isSelected.toggle()
        lblMonth.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4196078431, blue: 0.262745098, alpha: 1)
        lblAnual.backgroundColor = .clear
    }
    @IBAction func btnAnnua(_ sender: UIButton) {
        lblPrice.text = "$350"
        lblAnnual.text = "Annual"
        btnAnual.setTitleColor(#colorLiteral(red: 0.8862745098, green: 0.4196078431, blue: 0.262745098, alpha: 1), for:UIControl.State.normal)
        btnMonth.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for:UIControl.State.normal)
        //sender.isSelected.toggle()
        lblAnual.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4196078431, blue: 0.262745098, alpha: 1)
        lblMonth.backgroundColor = .clear
    }
}
//MARK:- Extension

extension PremiumVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prim.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTblView.dequeueReusableCell(withIdentifier: "cell") as! PremiumTableCell
        let data = prim[indexPath.row]
        cell.lblName.text = data.name
        cell.lblPrim.text = data.prim
        cell.lblNonPrim.text = data.nonPrim
        cell.imgRight.image = UIImage(named: data.rightImg)
        cell.imgCross.image = UIImage(named: data.image)
        if indexPath.row == 1 {
            cell.imgCross.isHidden = true
            cell.imgRight.isHidden = true
            cell.lblPrim.isHidden = false
            cell.lblNonPrim.isHidden = false
        }else  if indexPath.row == 2 {
            cell.imgCross.isHidden = true
            cell.imgRight.isHidden = true
            cell.lblPrim.isHidden = false
            cell.lblNonPrim.isHidden = false
        }else {
            cell.lblPrim.isHidden = true
            cell.lblNonPrim.isHidden = true
            cell.imgCross.isHidden = false
            cell.imgRight.isHidden = false
        }
        return cell
    }
    override func viewDidLayoutSubviews() {
        self.viewHeight.constant = CGFloat((prim.count * 55) + 128)
    }
}
//MARK:- Class

class PremiumTableCell:UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCross: UIImageView!
    @IBOutlet weak var imgRight: UIImageView!
    @IBOutlet weak var lblNonPrim: UILabel!
    @IBOutlet weak var lblPrim: UILabel!
}
