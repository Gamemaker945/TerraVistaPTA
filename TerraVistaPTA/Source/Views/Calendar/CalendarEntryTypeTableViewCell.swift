//
//  CalendarEntryTypeTableViewCell.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/23/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class CalendarEntryTypeTableViewCell: UITableViewCell {

    @IBOutlet var iconBg: UIView!
    @IBOutlet var iconLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setType (type:Int)
    {
        iconBg.backgroundColor = CalendarIcon.getColorForIndex(type)
        iconLabel.text = CalendarIcon.getFullStringForIndex(type)
    }

}
