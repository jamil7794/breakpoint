//
//  GroupCell.swift
//  breakpoint
//
//  Created by Jamil Jalal on 1/12/19.
//  Copyright © 2019 Jamil Jalal. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var groupDescriptionLbl: UILabel!
    
    @IBOutlet weak var membersLbl: UILabel!
    
    func configureCell(title: String, description: String, memberCount: Int){
        self.groupTitleLbl.text = title
        self.groupDescriptionLbl.text = description
        self.membersLbl.text = "\(memberCount) members"
    }
}
