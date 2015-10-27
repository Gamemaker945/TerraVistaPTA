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
    public var title: String = ""
    public var location: String = ""
    public var info: String = ""
    public var iconIndex: Int = 0
    public var startDate: NSDate?
    public var stopDate: NSDate?
    
    
    override init()
    {
        super.init()
        self.title = ""
        self.iconIndex = 0
        self.info = ""
        self.startDate = NSDate()
        self.stopDate = NSDate()
        
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