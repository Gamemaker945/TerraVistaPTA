//
//  ParseBase.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import Parse

public class ParseBase
{
    // Parse Object
    public var pObj: PFObject?

    init () {
        
    }
    
    func initWithParse (parseObj: PFObject)
    {
        pObj = parseObj
    }
    
    // Update the parse object in the database
    func save  (completion: (hasError: Bool, error: NSError?) -> Void)
    {
        if let parseObject = pObj
        {
            parseObject.saveInBackgroundWithBlock( { (success:Bool, error: NSError?) -> Void in
                
                // There was no error
                if (error == nil)
                {
                    completion (hasError: false, error: nil)
                }
                else
                {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                    completion (hasError: true, error: error)
                }
            })
        }
        else
        {
            // pObj not set. So nothing happened.
            let err = NSError (domain: "TerraVistaParseError", code: TVErrorCode.UNINIT_PARSE_OBJ.rawValue, userInfo: nil)
            completion (hasError: true, error: err)
        }
    }
    
    // Update the parse object in the database
    func delete  (completion: (hasError: Bool, error: NSError?) -> Void)
    {
        if let parseObject = pObj
        {
            parseObject.deleteInBackgroundWithBlock( { (success:Bool, error: NSError?) -> Void in
                
                // There was no error
                if (error == nil)
                {
                    completion (hasError: false, error: nil)
                }
                else
                {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                    completion (hasError: true, error: error)
                }
            })
        }
        else
        {
            // pObj not set. So nothing happened.
            let err = NSError (domain: "TerraVistaParseError", code: TVErrorCode.UNINIT_PARSE_OBJ.rawValue, userInfo: nil)
            completion (hasError: true, error: err)
        }
    }
}