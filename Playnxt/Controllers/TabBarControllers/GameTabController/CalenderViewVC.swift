//
//  CalenderViewVC.swift
//  Playnxt
//
//  Created by cano on 24/05/22.
//

import UIKit
import FSCalendar


class CalenderViewVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var lblAlert: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    //MARK: - Variable
    var arrEvent = [GetEventUserEvent]()
    var event_id : Int?
    var selectedDate : String?
    //MARK: - ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiGetEvent()
        calenderView.allowsMultipleSelection = false
        
    }
    //MARK: - Function
    
    //MARK: - Button Action
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddEvent(_ sender: Any) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        let vc = storyboard!.instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        vc.screenType = "Add"
        vc.start_date = selectedDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - API Calling
    
    func apiGetEvent(){
        
        let param : [String:Any] = ["date": selectedDate ?? ""]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Get_Event, method: .post, parameter: param, objectClass: GetEventUser.self, requestCode: Constant.URL_CONSTANT.Get_Event, userToken: nil) { response in
            if response.status == true {
                print("Response1--",response)
                self.arrEvent = response.data.event
                self.tableHeight.constant = CGFloat((self.arrEvent.count * 130))
                self.dataTableView.reloadData()
            }else{
                print("message",response.message)
            }
        }
    }
    func apiDeletewishList(id:Int){
        
        let param : [String:Any] = ["event_id": event_id ?? 0]
        SessionManager.shared.methodForApiCallingJson(url: Constant.URL_CONSTANT.Delete_Event, method: .post, parameter: param, objectClass: CommonResponse.self, requestCode: Constant.URL_CONSTANT.Delete_Event, userToken: nil) { response in
            if response.status == true{
                print("response-----",response)
                self.apiGetEvent()
            } else
            {
                print("message--",response.message)
            }
        }
    }
}

//MARK: - Extension
extension CalenderViewVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count---",arrEvent.count)
        if arrEvent.count == 0 {
            lblAlert.isHidden = false
        }else {
            lblAlert.isHidden = true
        }
        return arrEvent.count
        ///return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTableView.dequeueReusableCell(withIdentifier: "cell") as! CalenderViewCell
        let data = arrEvent[indexPath.row]
        cell.lblTopic.text = data.title
        cell.lblStart.text = data.startDate
        cell.lblEnd.text = data.endDate
        cell.btnBin.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
        cell.btnBin.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.btnEdit.addTarget(self, action: #selector(edit(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    @objc func connected(sender: UIButton){
        event_id = arrEvent[sender.tag].id
        showAlertWithCompletion(title: "Alert", message: "Are you sure you want to delete", completion: { [self]  UIAlertAction in
            apiDeletewishList(id: self.arrEvent[sender.tag].id)
            
        })
    }
    
    @objc func edit(sender: UIButton){
        let vc = storyboard!.instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        vc.screenType = "Edit"
        vc.event_title = arrEvent[sender.tag].title
        //vc.note = arrEvent[sender.tag].note
        vc.start_date = arrEvent[sender.tag].startDate
        vc.end_date = arrEvent[sender.tag].endDate
        vc.event_id = arrEvent[sender.tag].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews",arrEvent.count)
        self.tableHeight.constant = CGFloat((arrEvent.count * 130))
    }
}
//MARK: - Class

class CalenderViewCell:UITableViewCell {
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnBin: UIButton!
    
}

//MARK: -

extension CalenderViewVC : FSCalendarDataSource,FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        calenderView.today = nil
        let CurrentDate = formatter.string(from: date)
        print("CurrentDate=\(CurrentDate)")
        selectedDate = CurrentDate
        apiGetEvent()
    }
    
}
