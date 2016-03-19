//
//  LoginController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 10/27/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import CloudKit

public class LoginController
{
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    // Singleton Instance
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    
    class var sharedInstance : LoginController {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: LoginController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LoginController()
        }
        return Static.instance!
    }
    
    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    private var isLoggedIn: Bool
    private var adminUser:AdminUser?
    private var publicDB: CKDatabase?
    
    
    //------------------------------------------------------------------------------
    // MARK: Init
    //------------------------------------------------------------------------------
    init() {
        isLoggedIn = false
        publicDB = CKContainer.defaultContainer().publicCloudDatabase
    }
    
    func reset ()
    {
        isLoggedIn = false
    }
    
    
    func getLoggedIn() -> Bool
    {
        return isLoggedIn
    }
    
    func setLoggedIn(loggedIn: Bool)
    {
        isLoggedIn = loggedIn
    }
    
    
    func getActiveUser() -> AdminUser?
    {
        return adminUser
    }
    
    func setActiveUser (newUser: AdminUser?)
    {
        adminUser = newUser
    }
    
    func login (username: String, password: String, completion: (loggedIn: Bool, error: NSError?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "AdminUser", predicate: predicate)
        publicDB?.performQuery (query, inZoneWithID: nil, completionHandler: { (results, error) -> Void in
            
            if error == nil {
                
                let user:CKRecord = results![0]
                if ((user["username"] as! String) == username && (user["password"] as! String) == password) {
                    self.isLoggedIn = true
                    self.adminUser = AdminUser()
                    self.adminUser!.initWithCloudKit(user)
                } else {
                    self.isLoggedIn = false;
                    self.adminUser = nil
                }
                completion (loggedIn: self.isLoggedIn, error: error)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion (loggedIn: false, error: error)
            }
        })
    }
    
    func update (username: String, password: String, completion: (error: NSError?) -> Void) {
        
        if isLoggedIn == false {
            completion (error:nil)
        }
        
        adminUser?.username = username
        adminUser?.password = password
        
        publicDB?.saveRecord((adminUser?.rObj)!, completionHandler: { (newRecord, error) -> Void in
            if error == nil {
                
                self.adminUser = AdminUser()
                self.adminUser!.initWithCloudKit(newRecord!)
                completion (error: error)
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion (error: error)
            }
        })
    }
}
