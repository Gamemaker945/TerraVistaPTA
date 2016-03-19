//
//  AdminUser.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 3/4/16.
//  Copyright © 2016 Brain Glove Apps. All rights reserved.
//

import Foundation
import CloudKit

public class AdminUser : CKBase
{
    public var username: String
        {
        get {
            return rObj!["username"] as! String
        }
        set (newusername) {
            rObj!["username"] = newusername
        }
    }
    
    public var email: String
        {
        get {
            return rObj!["email"] as! String
        }
        set (newemail) {
            rObj!["email"] = newemail
        }
    }
    
    public var password: String
        {
        get {
            return rObj!["password"] as! String
        }
        set (newpassword) {
            rObj!["password"] = newpassword
        }
    }
    
    override init()
    {
        super.init()
    }
    
    override func initWithCloudKit (rObj: CKRecord)
    {
        super.initWithCloudKit(rObj)
    }
    
}