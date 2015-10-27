//
//  WebLink.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation

public class WebLinkController
{

    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    // Mark: Singleton Instance
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------

    class var sharedInstance : WebLinkController {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: WebLinkController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = WebLinkController()
        }
        return Static.instance!
    }
    
    
    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    private var linkArray: [WebLink]
    private var activeLink: WebLink?
    
    
    //------------------------------------------------------------------------------
    // MARK: Init
    //------------------------------------------------------------------------------
    init() {
        
        linkArray = [WebLink]()
        activeLink = nil
        
        if (CommonDefines.DEBUG_APP) {
            DEBUG_LOAD();
        }
        
    }
    
    func reset ()
    {
        activeLink = nil;
    }
    
    //------------------------------------------------------------------------------
    // MARK: WebLinks
    //------------------------------------------------------------------------------
    func fetchWebLinks ()
    {
        // TODO - Backend Fetch
    }
    
    
    func addWebLink (msg:WebLink)
    {
        // TODO - Backend Add
        linkArray.append(msg);
    }
    
    func getWebLinkByID (ID: Int) -> WebLink?
    {
        for var i=0; i < linkArray.count; i++
        {
            let msg:WebLink = linkArray[i]
            if (msg.parseID == ID) {
                return msg;
            }
        }
        return nil;
    }
    
    func getWebLinkAtIndex (index: Int) -> WebLink?
    {
        return linkArray[index];
    }
    
    func countWebLinks () -> Int
    {
        return linkArray.count;
    }
    
    //------------------------------------------------------------------------------
    // MARK: Active Msg
    //------------------------------------------------------------------------------
    func setActiveLink (msg: WebLink)
    {
        activeLink = msg;
    }
    
    //------------------------------------------------------------------------------
    // MARK: DEBUG
    //------------------------------------------------------------------------------
    func DEBUG_LOAD ()
    {
        let wl1:WebLink = WebLink();
        wl1.parseID = 1;
        wl1.title = "Google";
        wl1.urlStr = "http://www.google.com";
        linkArray.append(wl1);
        
        let wl2:WebLink = WebLink();
        wl2.parseID = 2;
        wl2.title = "Apple";
        wl2.urlStr = "http://www.apple.com";
        linkArray.append(wl2);
        
        let wl3:WebLink = WebLink();
        wl3.parseID = 3;
        wl3.title = "Teacher Web";
        wl3.urlStr = "http://www.teacherweb.com"
        linkArray.append(wl3);
    }

}
