//
//  WebLink.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import CloudKit

public class WebLink : CKBase
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
    
    public var urlStr: String
        {
        get {
            return rObj!["url"] as! String
        }
        set (newurl) {
            rObj!["url"] = newurl
        }
    }
    
    public var order: Int
        {
        get {
            return rObj!["order"] as! Int
        }
        set (newvalue) {
            rObj!["order"] = newvalue
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