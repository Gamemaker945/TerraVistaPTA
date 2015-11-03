//
//  WebLinkTableViewCell.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class WebLinkTableViewCell: UITableViewCell
{

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var myLink: WebLink! = nil
    
    override func awakeFromNib ()
    {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5

    }
    
    func setLink (link: WebLink)
    {
        self.myLink = link
        linkLabel.text = link.title
        
    }
    
}
