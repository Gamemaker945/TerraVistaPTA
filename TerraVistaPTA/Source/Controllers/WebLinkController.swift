//
//  WebLink.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import CloudKit

public class WebLinkController : BaseController
{

    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    // Mark: Singleton Instance
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------

    class var sharedInstance : WebLinkController {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: WebLinkController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = WebLinkController()
        }
        return Static.instance!
    }
    
    
    //------------------------------------------------------------------------------
    // MARK: WebLinks
    //------------------------------------------------------------------------------
    override func fetch (completion: (hasError: Bool, error: NSError?) -> Void)
    {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "PWebLink", predicate: predicate)
        
        dispatch_async(dispatch_get_main_queue()) {

            self.publicDB?.performQuery (query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
                
                if error == nil {
                    
                    self.ckArray.removeAll()
                    
                    // The find succeeded.
                    print("Successfully retrieved \(results!.count) weblinks.")
                    
                    // Do something with the found objects
                    for object in results! {
                        let link:WebLink = WebLink()
                        link.initWithCloudKit(object)
                        self.ckArray.append(link)
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
    
    
    
    func createEntry () -> WebLink {
        let timestampAsString = String(format: "%f", NSDate.timeIntervalSinceReferenceDate())
        let timestampParts = timestampAsString.componentsSeparatedByString(".")
        
        let entryID = CKRecordID(recordName: timestampParts[0])
        let entryRecord = CKRecord(recordType: "PWebLink", recordID: entryID)
        let entry = WebLink()
        entry.initWithCloudKit(entryRecord)
        entry.isNew = true
        return entry
    }
    
    //------------------------------------------------------------------------------
    // MARK: Active Msg
    //------------------------------------------------------------------------------
    
    override func sortCKObjects ()
    {
        self.ckArray.sortInPlace({ (pb1:CKBase, pb2:CKBase) -> Bool in
            let link1 = pb1 as! WebLink
            let link2 = pb2 as! WebLink
            return link1.order < link2.order
        })
    }
}
