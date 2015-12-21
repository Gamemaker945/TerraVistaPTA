//
//  CalendarController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/16/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import Parse

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
        let query:PFQuery = PFQuery(className:"PCalEntry")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                self.parseArray.removeAll()
                
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) calendar entries.")
                
                // Do something with the found objects
                for object in objects! {
                    let link:CalendarEntry = CalendarEntry()
                    link.initWithParse(object)
                    self.parseArray.append(link)
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
        }
    }
    
    
    func getEntriesForDate (date: NSDate) -> NSMutableArray
    {
        let result = NSMutableArray()
        for var i=0; i < parseArray.count; i++
        {
            let entry:CalendarEntry = parseArray[i] as! CalendarEntry
            if (isSameDays(entry.startDate!, date)) {
                result.addObject(entry)
            }
        }
        return result;
    }
    
    func hasEntriesForDate (date: NSDate) -> Bool
    {
        for var i=0; i < parseArray.count; i++
        {
            let entry:CalendarEntry = parseArray[i] as! CalendarEntry
            if (isSameDays(entry.startDate!, date)) {
                return true
            }
        }
        return false
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