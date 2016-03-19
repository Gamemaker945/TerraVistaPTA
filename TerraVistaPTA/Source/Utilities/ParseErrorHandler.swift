//
//  ParseErrorHandler.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 11/8/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import Foundation


public enum TVErrorCode: Int {
    case UNINIT_PARSE_OBJ = 1000
}

public class ParseErrorHandler
{
    private static let errorCodes :[(Int, String)] =
        [
            // Parse error codes:  http://parse.com/docs/dotnet/api/html/T_Parse_ParseException_ErrorCode.htm
            (-1, "The backend has returned an unknown error."),
            (1,  "The backend returned an internal server error. Please try again in a little bit."),
            (100, "The backend cannot be reached. Please check your connection to the internet and try again."),
            (101, "The requested object(s) was not found."),
            (102, "Server returned: Invalid Query."),
            (103, "Server returned: Invalid Class Name."),
            (104, "Server returned: Missing Object Id."),
            (105, "Server returned: Invalid Key Name."),
            (106, "Server returned: Invalid Pointer."),
            (109, "Server returned: Parse library not initialized."),
            (111, "Server returned: Incorrect Type"),
            (112, "Server returned: Invalid Channel Name"),
            (115, "Server returned: Push Misconfigured"),
            (116, "Server returned: Object Too Large"),
            (124, "Server returned: Server Timeout"),
            (155, "Server returned: Request Limit Exceeded"),
            (200, "Username was empty or missing"),
            (201, "Password was empty or missing"),
            (201, "Username was already taken"),
            (205, "Server returned: Email not found"),
            
            // My personal codes
            (1000, "Attempting to save an unintialized parse object.")
            
        ]
    
    static func showErrorWithTitle (src:UIViewController, title: String, errorMsg: String)
    {
        let alert = UIAlertController(title: title, message: errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",  style: UIAlertActionStyle.Cancel, handler: nil))
        src.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func showErrorWithTitle (src:UIViewController, title: String, errorCode: Int?)
    {
        let errorMsg = getErrorMsgForCode(errorCode)
        let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",  style: UIAlertActionStyle.Cancel, handler: nil))
        src.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func showError (src:UIViewController, errorMsg: String)
    {
        self.showErrorWithTitle(src, title: "Error", errorMsg: errorMsg)
    }
    
    static func showError (src:UIViewController, errorCode: Int?)
    {
        self.showErrorWithTitle(src, title: "Error", errorCode: errorCode)
    }
    
    
    private static func getErrorMsgForCode (code: Int?) -> String
    {
        if let codeToFind = code
        {
            for c:(Int, String) in errorCodes
            {
                if c.0 == codeToFind {
                    return c.1
                }
            }
        }
        
        return "Unknown Error"
    }
}