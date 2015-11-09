//
//  NSDate.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 11/5/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import Foundation

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate : Comparable
{
    func combineWithTime (time:NSDate) -> NSDate
    {
        let calendar = NSCalendar.currentCalendar()

        let timeComps = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate:time)
        let selfComps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate:self)
        selfComps.hour = timeComps.hour
        selfComps.minute = timeComps.minute
        selfComps.second = timeComps.second
        
        return calendar.dateFromComponents(selfComps)!
    }
}