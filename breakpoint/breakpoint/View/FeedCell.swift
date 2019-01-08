//
//  FeedCell.swift
//  breakpoint
//
//  Created by Jamil Jalal on 1/5/19.
//  Copyright © 2019 Jamil Jalal. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLml: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell(profileImage: UIImage, email: String, content: String){
        self.profileImg.image = profileImage
        self.emailLml.text = email
        self.contentLbl.text = content
    }
    
}
