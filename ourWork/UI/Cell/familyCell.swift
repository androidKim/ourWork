//
//  familyCell.swift
//  ourWork
//
//  Created by taejun on 15/04/2019.
//  Copyright © 2019 midasgo. All rights reserved.
//

import UIKit
class familyCell:UITableViewCell
{
    @IBOutlet weak var lb_UserKey: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // code common to all your cells goes here
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
