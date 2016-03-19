//
//  CalendarController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/16/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import CloudKit

public class CalendarController : BaseController
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
    // MARK: CalendarEntrys
    //------------------------------------------------------------------------------
    override func fetch (completion: (hasError: Bool, error: NSError?) -> Void)
    {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "PCalEntry", predicate: predicate)
        
         dispatch_async(dispatch_get_main_queue()) {
        
            self.publicDB?.performQuery (query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
                if error == nil {
                    
                    self.ckArray.removeAll()
                    
                    // The find succeeded.
                    print("Successfully retrieved \(results!.count) calendar entries.")
                    
                    // Do something with the found objects
                    for object in results! {
                        let link:CalendarEntry = CalendarEntry()
                        link.initWithCloudKit(object)
                        self.ckArray.append(link)
                    }
                    
    //                self.entryArray.sortInPlace({ (link1, link2) -> Bool in
    //                    return link1.order < link2.order
    //                })
                    completion (hasError: false, error: nil)
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                    completion (hasError: true, error: error)
                }
            })
        }
    }
    
    
    func getEntriesForDate (date: NSDate) -> NSMutableArray
    {
        let result = NSMutableArray()
        for var i=0; i < ckArray.count; i++
        {
            let entry:CalendarEntry = ckArray[i] as! CalendarEntry
            if (isSameDays(entry.startDate!, date)) {
                result.addObject(entry)
            }
        }
        return result;
    }
    
    func hasEntriesForDate (date: NSDate) -> Bool
    {
        for var i=0; i < ckArray.count; i++
        {
            let entry:CalendarEntry = ckArray[i] as! CalendarEntry
            if (isSameDays(entry.startDate!, date)) {
                return true
            }
        }
        return false
    }

    func createEntry () -> CalendarEntry {
        let timestampAsString = String(format: "%f", NSDate.timeIntervalSinceReferenceDate())
        let timestampParts = timestampAsString.componentsSeparatedByString(".")
        
        let entryID = CKRecordID(recordName: timestampParts[0])
        let entryRecord = CKRecord(recordType: "PCalEntry", recordID: entryID)
        let entry = CalendarEntry()
        entry.initWithCloudKit(entryRecord)
        entry.isNew = true
        return entry
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