//
//  WebLink.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import Parse

public class WebLink : ParseBase
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
    
    public var urlStr: String
        {
        get {
            return pObj!["url"] as! String
        }
        set (newurl) {
            pObj!["url"] = newurl
        }
    }
    
    public var order: Int
        {
        get {
            return pObj!["order"] as! Int
        }
        set (newvalue) {
            pObj!["order"] = newvalue
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