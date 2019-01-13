//
//  GroupFeedVC.swift
//  breakpoint
//
//  Created by Jamil Jalal on 1/12/19.
//  Copyright © 2019 Jamil Jalal. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    
    @IBOutlet weak var sendBtnView: UIView!
    
    @IBOutlet weak var messageTxtField: InsertTextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    

    
    var group: Group?
    
    func initData(froGroup group: Group){
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtnView.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        DataService.instance.getEmailsForGroup(group: group!) { (returnedEmail) in
             self.membersLbl.text = returnedEmail.joined(separator: ", ")
        }
       
    }
    
    @IBAction func bacButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnWasPressed(_ sender: Any) {
    }
}
