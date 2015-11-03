//
//  AnnouncementController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation

public class AnnouncementController
{
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    // Singleton Instance
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------

    class var sharedInstance : AnnouncementController {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: AnnouncementController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AnnouncementController()
        }
        return Static.instance!
    }
    
    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    private var msgArray: [Announcement]
    private var activeMsg: Announcement?
    
    
    //------------------------------------------------------------------------------
    // MARK: Init
    //------------------------------------------------------------------------------
    init() {
        
        msgArray = [Announcement]()
        activeMsg = nil
    }
    
    func reset ()
    {
        activeMsg = nil;
    }
    
    //------------------------------------------------------------------------------
    // MARK: Announcements
    //------------------------------------------------------------------------------
    func fetchAnnouncements ()
    {
    // TODO - Backend Fetch
    }
    
    
    func addAnnouncement (msg:Announcement)
    {
        // TODO - Backend Add
        msgArray.append(msg);
    }
    
    func getAnnouncementByID (ID: String) -> Announcement?
    {
        for var i=0; i < msgArray.count; i++
        {
            let msg:Announcement = msgArray[i]
            if (msg.pObj?.objectId == ID) {
                return msg;
            }
        }
        return nil;
    }
    
    func getAnnouncementAtIndex (index: Int) -> Announcement?
    {
        return msgArray[index];
    }
    
    func countAnnouncements () -> Int
    {
        return msgArray.count;
    }
    
    //------------------------------------------------------------------------------
    // MARK: Active Msg
    //------------------------------------------------------------------------------
    func setActiveMsg (msg: Announcement)
    {
        activeMsg = msg;
    }
    
    //------------------------------------------------------------------------------
    // MARK: DEBUG
    //------------------------------------------------------------------------------
    
}