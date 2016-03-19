//
//  AnnouncementController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import CloudKit

public class AnnouncementController : BaseController
{
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    // Singleton Instance
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------

    class var sharedInstance : AnnouncementController {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: AnnouncementController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AnnouncementController()
        }
        return Static.instance!
    }
    
    //------------------------------------------------------------------------------
    // MARK: Announcements
    //------------------------------------------------------------------------------
    override func fetch (completion: (hasError: Bool, error: NSError?) -> Void)
    {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "PAnnouncement", predicate: predicate)
        
        dispatch_async(dispatch_get_main_queue()) {

            self.publicDB?.performQuery (query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
                if error == nil {
                    
                    self.ckArray.removeAll()
                    
                    // The find succeeded.
                    print("Successfully retrieved \(results!.count) announcements.")
                    
                    // Do something with the found objects
                    for object in results! {
                        let msg:Announcement = Announcement()
                        msg.initWithCloudKit(object)
                        self.ckArray.append(msg)
                    }
                    
                   self.sortCKObjects()
                    completion (hasError: false, error: nil)
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                    completion (hasError: true, error: error)
                }
            })
        }
    }
    
    func createEntry () -> Announcement {
        let timestampAsString = String(format: "%f", NSDate.timeIntervalSinceReferenceDate())
        let timestampParts = timestampAsString.componentsSeparatedByString(".")
        
        let entryID = CKRecordID(recordName: timestampParts[0])
        let entryRecord = CKRecord(recordType: "PAnnouncement", recordID: entryID)
        let entry = Announcement()
        entry.initWithCloudKit(entryRecord)
        entry.isNew = true
        return entry
    }
    
    override func sortCKObjects ()
    {
        self.ckArray.sortInPlace({ (pb1, pb2) -> Bool in
            let link1 = pb1 as! Announcement
            let link2 = pb2 as! Announcement

            return link1.date > link2.date
        })
    }
    //------------------------------------------------------------------------------
    // MARK: DEBUG
    //------------------------------------------------------------------------------
    
}