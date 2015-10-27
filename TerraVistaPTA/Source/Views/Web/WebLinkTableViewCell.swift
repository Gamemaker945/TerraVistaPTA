//
//  WebLinkTableViewCell.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class WebLinkTableViewCell: UITableViewCell {

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    
    override func awakeFromNib ()
    {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
    }
    
    public func setLink (link: String)
    {
        linkLabel.text = link
    }
    
}
