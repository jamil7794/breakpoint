//
//  GroupFeedCell.swift
//  breakpoint
//
//  Created by Jamil Jalal on 1/12/19.
//  Copyright © 2019 Jamil Jalal. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {
   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell(profileImage: UIImage, email: String, contentLbl: String){
        self.profileImage.image = profileImage
        self.emailLbl.text = email
        self.contentLbl.text = contentLbl
    }
}
