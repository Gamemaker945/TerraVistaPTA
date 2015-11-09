//
//  CalendarEntry.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/16/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation


public class CalendarEntry : ParseBase
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
    
    public var location: String
        {
        get {
            return pObj!["location"] as! String
        }
        set (newloc) {
            pObj!["location"] = newloc
        }
    }
    
    public var info: String
        {
        get {
            return pObj!["info"] as! String
        }
        set (newinfo) {
            pObj!["info"] = newinfo
        }
    }
    
    public var iconIndex: Int
        {
        get {
            return pObj!["iconIndex"] as! Int
        }
        set (newvalue) {
            pObj!["iconIndex"] = newvalue
        }
    }
    
    public var startDate: NSDate?
        {
        get {
            return pObj!["startDate"] as? NSDate
        }
        set (newDate) {
            pObj!["startDate"] = newDate
        }
    }
    
    public var stopDate: NSDate?
        {
        get {
            return pObj!["stopDate"] as? NSDate
        }
        set (newDate) {
            pObj!["stopDate"] = newDate
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