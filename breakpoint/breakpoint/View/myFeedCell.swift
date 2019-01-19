//
//  myFeedCell.swift
//  breakpoint
//
//  Created by Jamil Jalal on 1/18/19.
//  Copyright © 2019 Jamil Jalal. All rights reserved.
//

import UIKit

class myFeedCell: UITableViewCell {

    @IBOutlet weak var myFeeds: UILabel!
    

    func configureCell(feed: String){
       myFeeds.text = feed
    }
}
