//
//  CalendarEntry.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/16/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import CloudKit

public class CalendarEntry : CKBase
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
    
    public var location: String?
        {
        get {
            return rObj!["location"] as? String
        }
        set (newloc) {
            rObj!["location"] = newloc
        }
    }
    
    public var info: String?
        {
        get {
            return rObj!["info"] as? String
        }
        set (newinfo) {
            rObj!["info"] = newinfo
        }
    }
    
    public var iconIndex: Int
        {
        get {
            return rObj!["iconIndex"] as! Int
        }
        set (newvalue) {
            rObj!["iconIndex"] = newvalue
        }
    }
    
    public var startDate: NSDate?
        {
        get {
            return rObj!["startDate"] as? NSDate
        }
        set (newDate) {
            rObj!["startDate"] = newDate
        }
    }
    
    public var stopDate: NSDate?
        {
        get {
            return rObj!["stopDate"] as? NSDate
        }
        set (newDate) {
            rObj!["stopDate"] = newDate
        }
    }

    
    
    override init()
    {
        super.init()        
    }
    
    func getIconColor() -> UIColor
    {
        return CalendarIcon.getColorForIndex(self.iconIndex)
    }
    
    func getIconString() -> String
    {
        return CalendarIcon.getStringForIndex(self.iconIndex)
    }
    
    func getFullString() -> String
    {
        return CalendarIcon.getFullStringForIndex(self.iconIndex)
    }
    
    

    
}