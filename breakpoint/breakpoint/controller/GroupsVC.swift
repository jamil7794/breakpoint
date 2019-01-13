//
//  GroupsVC.swift
//  breakpoint
//
//  Created by Jamil Jalal on 1/8/19.
//  Copyright © 2019 Jamil Jalal. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {
    
    var groupsArray = [Group]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapShot) in
            DataService.instance.getAllGroups { (returnedGroupArray) in
                self.groupsArray = returnedGroupArray
                self.tableView.reloadData()
            }
        }
    }
    
    

}
extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else {return UITableViewCell()}
        
        let groups = groupsArray[indexPath.row]
        
        cell.configureCell(title: groups.groupTitle, description: groups.groupDesc, memberCount: groups.memberCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC else {return}
        groupFeedVC.initData(froGroup: groupsArray[indexPath.row])
        presentDetail(viewControllerToPresent: groupFeedVC)
        //present(groupFeedVC, animated: true, completion: nil)
    }
}
