//
//  FirstViewController.swift
//  breakpoint
//
//  Created by Jamil Jalal on 12/27/18.
//  Copyright © 2018 Jamil Jalal. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var messageArray = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Happens before it finishes loading
        super.viewDidAppear(animated)
        
        DataService.instance.getAllFeedMessages { (returnMessageArray) in
            self.messageArray = returnMessageArray.reversed()
  
            self.tableView.reloadData()
        }
    }


}

extension FeedVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else {return UITableViewCell()}
        
        let image = UIImage(named: "defaultProfileImage")
        let message = messageArray[indexPath.row]
        
        DataService.instance.getUserName(forUID: message.senderId) { (returnedUsername) in
             cell.configureCell(profileImage: image!, email: returnedUsername, content: message.content)
        }
       
        
        return cell
    }
}
