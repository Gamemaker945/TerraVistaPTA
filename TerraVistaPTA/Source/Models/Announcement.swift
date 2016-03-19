//
//  Announcement.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import CloudKit

public class Announcement : CKBase
{
    public var title: String
        {
        get {
            return rObj!["title"] as! String
        }
        set (newtitle) {
            rObj!["title"] = newtitle
        }
    }
    
    public var content: String
        {
        get {
            return rObj!["content"] as! String
        }
        set (newcontent) {
            rObj!["content"] = newcontent
        }
    }
    
    public var date: NSDate
        {
        get {
            return rObj!.modificationDate!
        }
        set (newDate) {
            
        }
    }

    
    override init()
    {
        super.init()
    }
    
    override func initWithCloudKit (rObj: CKRecord)
    {
        super.initWithCloudKit(rObj)
    }
    
}