//
//  ParseBase.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import CloudKit

public class CKBase
{
    // Parse Object
    public var rObj: CKRecord?
    var publicDB: CKDatabase?
    public var isNew:Bool = false

    init () {
        
    }
    
    internal func initWithCloudKit (rObj: CKRecord)
    {
        self.rObj = rObj
        publicDB = CKContainer.defaultContainer().publicCloudDatabase
        isNew = false
    }
    
    // Update the parse object in the database
    func save  (completion: (hasError: Bool, error: NSError?) -> Void)
    {
        if let ckObject = rObj
        {
            publicDB?.saveRecord(ckObject, completionHandler: { (savedRecord, error) -> Void in
                
                // There was no error
                if (error == nil)
                {
                    self.rObj = savedRecord
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
        if let ckObject = rObj
        {
            publicDB?.deleteRecordWithID (ckObject.recordID, completionHandler: { (deletedRecord, error) -> Void in
                
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