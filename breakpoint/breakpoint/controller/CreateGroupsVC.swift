//
//  SecondViewController.swift
//  breakpoint
//
//  Created by Jamil Jalal on 12/27/18.
//  Copyright © 2018 Jamil Jalal. All rights reserved.
//

import UIKit

class CreateGroupsVC: UIViewController {
    @IBOutlet weak var titleTxtField: InsertTextField!
    
    @IBOutlet weak var descriptionTxtField: InsertTextField!
    
    @IBOutlet weak var emailSearchTextfield: InsertTextField!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var groupMemberLbl: UILabel!
    
    var emailArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTextfield.delegate = self
        emailSearchTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(){
        if emailSearchTextfield.text == "" {
            emailArray = []
            self.tableView.reloadData()
        }else{
            
            DataService.instance.getEmail(forSearchQuery: emailSearchTextfield.text!) { (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func doneBtnWasPressed(_ sender: Any) {
        
    }

    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else {return UITableViewCell()}
        let profileImg = UIImage(named: "defaultProfileImage")
        cell.configureCell(profileImage: profileImg!, email: emailArray[indexPath.row], isSelected: true)
        return cell
    }
}

extension CreateGroupsVC: UITextFieldDelegate {
    
}

