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
        
        if (CommonDefines.DEBUG_APP) {
            DEBUG_LOAD();
        }
        
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
    
    func getCalendarEntryByID (ID: Int) -> CalendarEntry?
    {
        for var i=0; i < entryArray.count; i++
        {
            let entry:CalendarEntry = entryArray[i]
            if (entry.parseID == ID) {
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
    func DEBUG_LOAD ()
    {
        let entry1:CalendarEntry = CalendarEntry();
        entry1.parseID = 1;
        entry1.title = "Google";
        entry1.startDate = NSDate();
        entry1.stopDate = NSDate()
        entry1.iconIndex = 0
        entry1.location = "Google San Fransisco"
        entry1.info = "Going to meet with the google people for my share of the money."
        entryArray.append(entry1);
        
        let entry2:CalendarEntry = CalendarEntry();
        entry2.parseID = 2;
        entry2.title = "Apple";
        entry2.startDate = NSDate();
        entry2.stopDate = NSDate()
        entry2.iconIndex = 1
        entry2.location = "Apple San Fransisco"
        entry2.info = "Meeting with apple to discuss the new extreme elementary app."
        entryArray.append(entry2);
        
        let entry3:CalendarEntry = CalendarEntry();
        entry3.parseID = 3;
        entry3.title = "Awards Assembly";
        entry3.startDate = NSDate(timeInterval: 20000, sinceDate: entry2.startDate!);
        entry3.stopDate = NSDate()
        entry3.iconIndex = 2
        entry3.location = "General Purpose Room"
        entry3.info = "Tonight is the awards assembly for best app."
        entryArray.append(entry3);
    }
    
    private func isSameDays(date1:NSDate, _ date2:NSDate) -> Bool
    {
        let calendar = NSCalendar.currentCalendar()
        
        let comps1 = calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Day], fromDate:date1)
        
        let comps2 = calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Day], fromDate:date2)
        
        return (comps1.day == comps2.day) && (comps1.month == comps2.month) && (comps1.year == comps2.year)
    }
    
}