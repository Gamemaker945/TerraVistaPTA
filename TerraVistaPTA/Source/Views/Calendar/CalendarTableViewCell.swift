//
//  CalendarTableViewCell.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/16/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var startTimeAMPMLabel: UILabel!
    @IBOutlet weak var stopTimeLabel: UILabel!
    @IBOutlet weak var stopTimeAMPMLabel: UILabel!
    
    @IBOutlet var iconBg: UIView!
    @IBOutlet var iconLabel: UILabel!
    
    
    override func awakeFromNib ()
    {
        super.awakeFromNib()
        
    }
    
    func setEntry (entry: CalendarEntry)
    {
        titleLabel.text = entry.title;
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm"
        startTimeLabel.text = dateFormatter.stringFromDate(entry.startDate!)
        stopTimeLabel.text = dateFormatter.stringFromDate(entry.stopDate!)
        
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "a"
        startTimeAMPMLabel.text = dateFormatter2.stringFromDate(entry.startDate!)
        stopTimeAMPMLabel.text = dateFormatter2.stringFromDate(entry.stopDate!)
        
        iconBg.backgroundColor = entry.getIconColor()
        iconLabel.text = entry.getIconString()
        
        iconBg.layer.cornerRadius = 4
    }

}
