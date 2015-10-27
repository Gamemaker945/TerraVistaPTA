//
//  LoginController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 10/27/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import Foundation

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
    
    
    //------------------------------------------------------------------------------
    // MARK: Init
    //------------------------------------------------------------------------------
    init() {
        isLoggedIn = false
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
}
