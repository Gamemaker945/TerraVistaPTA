//
//  BaseController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 11/5/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import Parse

public class BaseController
{
    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    var parseArray: [ParseBase]
    var active: ParseBase?
    
    subscript (index:Int) -> ParseBase? {
        if (index > 0 && index < parseArray.count)
        {
            return nil;
        }
        else
        {
            return parseArray[index];
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: Init
    //------------------------------------------------------------------------------
    init() {
        
        parseArray = [ParseBase]()
        active = nil
    }
    
    func reset ()
    {
        active = nil;
    }
    
    //------------------------------------------------------------------------------
    // MARK: Announcements
    //------------------------------------------------------------------------------
    func fetch (completion: (hasError: Bool, error: NSError?) -> Void)
    {
        // Override in subclass
    }
    
    
    func add (className: String, msg:ParseBase, completion: (hasError: Bool, error: NSError?) -> Void)
    {
        msg.pObj = PFObject (className: className);
        msg.save { (hasError, error) -> Void in
            if (error == nil)
            {
                self.parseArray.append(msg)
                self.sortParseObjects()
                completion (hasError: false, error: nil)
            }
            else
            {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion (hasError: true, error: error)
            }
        }
    }
    
    func update  (msg:ParseBase, completion: (hasError: Bool, error: NSError?) -> Void)
    {
        msg.save ( { (hasError, error) -> Void in
            if (error == nil) {
                self.sortParseObjects()
                completion (hasError: false, error: nil)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion (hasError: true, error: error)
            }
        } )
    }
    
    func delete (msg:ParseBase, completion: (hasError: Bool, error: NSError?) -> Void)
    {
        let msgIndex = self.getParseByIndex(msg)
        
        msg.delete ({ (hasError, error) -> Void in
            if (error == nil) {

                if (msgIndex != -1)
                {
                    self.parseArray.removeAtIndex(msgIndex);
                }

                self.sortParseObjects()
                completion (hasError: false, error: nil)
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion (hasError: true, error: error)
            }
        })
    }
    
    func getByID (ID: String) -> ParseBase?
    {
        for var i=0; i < parseArray.count; i++
        {
            let msg:ParseBase = parseArray[i]
            if (msg.pObj?.objectId == ID) {
                return msg;
            }
        }
        return nil;
    }
    
    func count () -> Int
    {
        return parseArray.count;
    }
    
    func getParseObjects () -> [ParseBase]
    {
        return parseArray
    }
    
    //------------------------------------------------------------------------------
    // MARK: Active Msg
    //------------------------------------------------------------------------------
    func setActive (msg: ParseBase?)
    {
        active = msg;
    }
    
    func getActive () -> ParseBase?
    {
        return active;
    }
    
    func getParseByIndex (msg: ParseBase) -> Int
    {
        for var i=0; i < parseArray.count; i++
        {
            let mymsg:ParseBase = parseArray[i]
            if (mymsg.pObj?.objectId == msg.pObj?.objectId) {
                return i
            }
        }
        return -1
    }
    
    // virtual function of sorts, expects parents to override depending on 
    // underlying object being sorted.
    func sortParseObjects ()
    {
        
    }

}