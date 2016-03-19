//
//  BaseController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 11/5/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import CloudKit

public class BaseController
{
    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    var ckArray: [CKBase]
    var active: CKBase?
    var publicDB: CKDatabase?
    
    subscript (index:Int) -> CKBase? {
        if (index > 0 && index < ckArray.count)
        {
            return nil;
        }
        else
        {
            return ckArray[index];
        }
    }
    
    var GlobalUserInitiatedQueue: dispatch_queue_t {
        return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
    }
    
    var GlobalMainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    
    //------------------------------------------------------------------------------
    // MARK: Init
    //------------------------------------------------------------------------------
    init() {
        
        ckArray = [CKBase]()
        active = nil
        publicDB = CKContainer.defaultContainer().publicCloudDatabase
    }
    
    func reset ()
    {
        active = nil;
    }
    
    //------------------------------------------------------------------------------
    // MARK: Base
    //------------------------------------------------------------------------------
    func fetch (completion: (hasError: Bool, error: NSError?) -> Void)
    {
        // Override in subclass
    }
    
    
    func add (className: String, msg:CKBase, completion: (hasError: Bool, error: NSError?) -> Void)
    {
        publicDB?.saveRecord(msg.rObj!, completionHandler: { (savedRecord, error) -> Void in
            if (error == nil) {
                msg.rObj = savedRecord
                
                self.sortCKObjects()
                completion (hasError: false, error: nil)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion (hasError: true, error: error)
            }
        })
    }
    
    func update  (msg:CKBase, completion: (hasError: Bool, error: NSError?) -> Void)
    {
        publicDB?.saveRecord(msg.rObj!, completionHandler: { (savedRecord, error) -> Void in
            if (error == nil) {
                msg.rObj = savedRecord
                self.sortCKObjects()
                completion (hasError: false, error: nil)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion (hasError: true, error: error)
            }
        })
    }
    
    func delete (msg:CKBase, completion: (hasError: Bool, error: NSError?) -> Void)
    {
        let msgIndex = self.getCKByIndex(msg)
        publicDB?.deleteRecordWithID ((msg.rObj?.recordID)!, completionHandler: { (deletedRecord, error) -> Void in
            if (error == nil) {
                
                if (msgIndex != -1)
                {
                    self.ckArray.removeAtIndex(msgIndex);
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
    
    func updateAll (completion: (error: NSError?) -> Void) {
        
        var storedError: NSError!
        let updateGroup = dispatch_group_create()
        var foundError = false
        
        dispatch_apply(self.ckArray.count, GlobalUserInitiatedQueue) {
            i in
            let index = Int(i)
            
            dispatch_group_enter(updateGroup)
            
            if foundError {dispatch_group_leave(updateGroup)}
            
            let msg = self.ckArray[index]
            self.publicDB?.saveRecord(msg.rObj!, completionHandler: { (savedRecord, error) -> Void in
                if (error == nil) {
                    msg.rObj = savedRecord
                    
                } else {
                    storedError = error
                    foundError = true
                }
                dispatch_group_leave(updateGroup)
            })
            
        }
        
        dispatch_group_notify(updateGroup, self.GlobalMainQueue) {
            self.sortCKObjects()
            completion(error: storedError)
        }
    }

    
    func getByID (ID: String) -> CKBase?
    {
        for var i=0; i < ckArray.count; i++
        {
            let msg:CKBase = ckArray[i]
            if (msg.rObj?.recordID == ID) {
                return msg;
            }
        }
        return nil;
    }
    
    func count () -> Int
    {
        return ckArray.count;
    }
    
    func getCKObjects () -> [CKBase]
    {
        return ckArray
    }
    
    func insertObject (obj: CKBase) {
        ckArray.append(obj)
    }
    
    
    //------------------------------------------------------------------------------
    // MARK: Active
    //------------------------------------------------------------------------------
    func setActive (msg: CKBase?)
    {
        active = msg;
    }
    
    func getActive () -> CKBase?
    {
        return active;
    }
    
    func getCKByIndex (msg: CKBase) -> Int
    {
        for var i=0; i < ckArray.count; i++
        {
            let mymsg:CKBase = ckArray[i]
            if (mymsg.rObj?.recordID == msg.rObj?.recordID) {
                return i
            }
        }
        return -1
    }
    
    // virtual function of sorts, expects parents to override depending on
    // underlying object being sorted.
    internal func sortCKObjects ()
    {
        
    }
    
    //------------------------------------------------------------------------------
    // MARK: Latest
    //------------------------------------------------------------------------------
    func storeLatestDate (date: NSDate, usingKey: String)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(date, forKey: usingKey)
        defaults.synchronize()
    }
    
    func getLatestStoredDate (usingKey: String) -> NSDate?
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(usingKey) as? NSDate
    }
    
    
    func countNewObjects (usingKey: String) -> Int
    {
        let latestDate = getLatestStoredDate(usingKey)
        var count = 0
        for var i=0; i < ckArray.count; i++
        {
            let mymsg:CKBase = ckArray[i]
            if mymsg.rObj?.modificationDate > latestDate {
                count += 1
            }
        }
        
        return count
    }

}