//
//  UITextField.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 11/13/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import UIKit

extension UITextField
{
    
    func isEmpty () -> Bool
    {
        if let str = self.text
        {
            if (str.isEmpty) { return true }
        }
        else
        {
            return true
        }
        
        return false
    }
    
    // Validate the textfield has a valid email address
    func validateEmailInput () -> Bool
    {
        if (self.isEmpty()) { return false }
        
        let emailRegex = "[A-Z0-9a-z._]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(self.text)
    }
    
    // Validate the textfield has a valid password
    func validatePasswordInput () -> Bool
    {
        if (self.isEmpty()) { return false }
        
        let passwordMinLen:Int = 6
        if let str = self.text
        {
            if str.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "0123456789")) != nil
            {
                return str.characters.count >= passwordMinLen
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
    }
    
    
    // Validate the textfield has a valid username
    func validateUsernameInput () -> Bool
    {
        if (self.isEmpty()) { return false }
        
        let usernameMinLen:Int = 4
        if let str = self.text
        {
            return str.characters.count >= usernameMinLen
        }
        else
        {
            return false
        }
    }
}