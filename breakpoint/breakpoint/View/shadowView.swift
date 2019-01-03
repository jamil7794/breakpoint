//
//  shadowView.swift
//  breakpoint
//
//  Created by Jamil Jalal on 1/2/19.
//  Copyright © 2019 Jamil Jalal. All rights reserved.
//

import UIKit

class shadowView: UIView {

   
    override func awakeFromNib() {
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 5
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        super.awakeFromNib()
    }

}
