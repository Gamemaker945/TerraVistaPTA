//
//  UpdateController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 1/16/16.
//  Copyright © 2016 Brain Glove Apps. All rights reserved.
//

import Foundation

public class FetchController
{
   private let fetchTime = 60.0 * 5.0
   
   //------------------------------------------------------------------------------
   //------------------------------------------------------------------------------
   // Singleton Instance
   //------------------------------------------------------------------------------
   //------------------------------------------------------------------------------
   
   class var sharedInstance : FetchController {
      struct Static {
         static var onceToken: dispatch_once_t = 0
         static var instance: FetchController? = nil
      }
      dispatch_once(&Static.onceToken) {
         Static.instance = FetchController()
      }
      return Static.instance!
   }
   
   //------------------------------------------------------------------------------
   // VARS
   //------------------------------------------------------------------------------
   private var lastFetchDate: NSDate?
   
   //------------------------------------------------------------------------------
   // MARK: Init
   //------------------------------------------------------------------------------
   init() {
      lastFetchDate = nil
   }
   
   func reset ()
   {
      lastFetchDate = NSDate()
   }
   
   
   func shouldUpdate() -> Bool
   {
      if lastFetchDate == nil {
         return true
      } else {
         let elapsedTime = NSDate().timeIntervalSinceDate(lastFetchDate!)
         if elapsedTime > fetchTime {
            return true
         } else {
            return false
         }
      }
   }
    
    var GlobalUserInitiatedQueue: dispatch_queue_t {
        return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
    }
    
    var GlobalMainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }

    
    func updateAll (completion: (error: NSError?) -> Void) {
        
        var storedError: NSError!
        let downloadGroup = dispatch_group_create()
        var foundError = false
        
        dispatch_apply(3, GlobalUserInitiatedQueue) {
            i in
            let index = Int(i)
            
            dispatch_group_enter(downloadGroup)
            
            if foundError {dispatch_group_leave(downloadGroup)}
            
            switch (index) {
            case 0:
                CalendarController.sharedInstance.fetch { (hasError, error) -> Void in
                    foundError = true
                    storedError = error
                    dispatch_group_leave(downloadGroup)
                    
            }
            case 1:
               AnnouncementController.sharedInstance.fetch { (hasError, error) -> Void in
                    foundError = true
                    storedError = error
                    dispatch_group_leave(downloadGroup)
                    
                }
            case 2:
                WebLinkController.sharedInstance.fetch { (hasError, error) -> Void in
                    foundError = true
                    storedError = error
                    dispatch_group_leave(downloadGroup)
                    
                }
            default:
                dispatch_group_leave(downloadGroup)
            }
            
        }
        
        dispatch_group_notify(downloadGroup, self.GlobalMainQueue) {
            completion(error: storedError)
        }
    }
}
