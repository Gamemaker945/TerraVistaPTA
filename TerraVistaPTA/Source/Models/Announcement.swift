//
//  Announcement.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation

public class Announcement : ParseBase
{
    public var title: String = ""
    public var content: String = ""
    public var date: NSDate? = NSDate()
    
    override init()
    {
        super.init()
        self.title = ""
        self.date = nil
        self.content = ""
    }
    
}