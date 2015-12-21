//
//  Announcement.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import Parse

public class Announcement : ParseBase
{
    public var title: String
        {
        get {
            return pObj!["title"] as! String
        }
        set (newtitle) {
            pObj!["title"] = newtitle
        }
    }
    
    public var content: String
        {
        get {
            return pObj!["content"] as! String
        }
        set (newcontent) {
            pObj!["content"] = newcontent
        }
    }
    
    public var date: NSDate
        {
        get {
            return pObj!.updatedAt!
        }
        set (newDate) {
            
        }
    }

    
    override init()
    {
        super.init()
    }
    
    override func initWithParse (parseObj: PFObject)
    {
        super.initWithParse(parseObj)
    }
    
}