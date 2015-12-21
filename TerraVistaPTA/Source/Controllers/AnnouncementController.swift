//
//  AnnouncementController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import Parse

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
        let query:PFQuery = PFQuery(className:"PAnnouncement")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                self.parseArray.removeAll()
                
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) announcements.")
                
                // Do something with the found objects
                for object in objects! {
                    let msg:Announcement = Announcement()
                    msg.initWithParse(object)
                    self.parseArray.append(msg)
                }
                
               self.sortParseObjects()
                completion (hasError: false, error: nil)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion (hasError: true, error: error)
            }
        }
    }
    

    
    override func sortParseObjects ()
    {
        self.parseArray.sortInPlace({ (pb1, pb2) -> Bool in
            let link1 = pb1 as! Announcement
            let link2 = pb2 as! Announcement

            return link1.date > link2.date
        })
    }
    //------------------------------------------------------------------------------
    // MARK: DEBUG
    //------------------------------------------------------------------------------
    
}