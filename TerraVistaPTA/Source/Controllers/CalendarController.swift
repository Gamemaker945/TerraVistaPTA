//
//  CalendarController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/16/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation

public class CalendarController
{
    
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    // Mark: Singleton Instance
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    
    class var sharedInstance : CalendarController {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: CalendarController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CalendarController()
        }
        return Static.instance!
    }
    
    
    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    private var entryArray: [CalendarEntry]
    private var activeEntry: CalendarEntry?
    
    //------------------------------------------------------------------------------
    // MARK: Init
    //------------------------------------------------------------------------------
    init() {
        
        entryArray = [CalendarEntry]()
        activeEntry = nil
        
    }
    
    func reset ()
    {
        activeEntry = nil;
    }
    
    //------------------------------------------------------------------------------
    // MARK: CalendarEntrys
    //------------------------------------------------------------------------------
    func fetchCalendarEntrys ()
    {
        // TODO - Backend Fetch
    }
    
    
    func addCalendarEntry (entry:CalendarEntry?)
    {
        // TODO - Backend Add
        if (entry != nil) {
            entryArray.append(entry!) }
    }
    
    func getCalendarEntryByID (ID: String) -> CalendarEntry?
    {
        for var i=0; i < entryArray.count; i++
        {
            let entry:CalendarEntry = entryArray[i]
            if (entry.pObj?.objectId == ID) {
                return entry;
            }
        }
        return nil;
    }
    
    func getCalendarEntryAtIndex (index: Int) -> CalendarEntry?
    {
        return entryArray[index];
    }
    
    func countCalendarEntrys () -> Int
    {
        return entryArray.count;
    }
    
    func getEntriesForDate (date: NSDate) -> NSMutableArray
    {
        let result = NSMutableArray()
        for var i=0; i < entryArray.count; i++
        {
            let entry:CalendarEntry = entryArray[i]
            if (isSameDays(entry.startDate!, date)) {
                result.addObject(entry)
            }
        }
        return result;
    }
    
    func hasEntriesForDate (date: NSDate) -> Bool
    {
        for var i=0; i < entryArray.count; i++
        {
            let entry:CalendarEntry = entryArray[i]
            if (isSameDays(entry.startDate!, date)) {
                return true
            }
        }
        return false
    }
    
    //------------------------------------------------------------------------------
    // MARK: Active entry
    //------------------------------------------------------------------------------
    func setActiveEntry (entry: CalendarEntry)
    {
        activeEntry = entry;
    }
    
    func getActiveEntry () -> CalendarEntry?
    {
        return activeEntry;
    }
    
    
    //------------------------------------------------------------------------------
    // MARK: DEBUG
    //------------------------------------------------------------------------------
    
    private func isSameDays(date1:NSDate, _ date2:NSDate) -> Bool
    {
        let calendar = NSCalendar.currentCalendar()
        
        let comps1 = calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Day], fromDate:date1)
        
        let comps2 = calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Day], fromDate:date2)
        
        return (comps1.day == comps2.day) && (comps1.month == comps2.month) && (comps1.year == comps2.year)
    }
    
}