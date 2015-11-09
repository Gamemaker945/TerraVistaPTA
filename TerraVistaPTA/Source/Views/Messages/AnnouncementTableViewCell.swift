//
//  AnnoucementTableViewCell.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    override func awakeFromNib ()
    {
        super.awakeFromNib()
        
    }
    
    func setAnnouncement (msg: Announcement)
    {
        titleLabel.text = msg.title;
        contentLabel.text = msg.content;
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY"
        dateLabel.text = dateFormatter.stringFromDate(msg.date)
    }
    
}

