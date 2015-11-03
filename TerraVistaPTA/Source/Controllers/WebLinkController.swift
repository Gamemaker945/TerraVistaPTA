//
//  WebLink.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import Parse

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
        
    }
    
    func reset ()
    {
        activeLink = nil;
    }
    
    //------------------------------------------------------------------------------
    // MARK: WebLinks
    //------------------------------------------------------------------------------
    func fetchWebLinks (completion: (hasError: Bool, error: NSError?) -> Void)
    {
        let query:PFQuery = PFQuery(className:"PWebLink")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                self.linkArray.removeAll()
                
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) weblinks.")
                
                // Do something with the found objects
                for object in objects! {
                    let link:WebLink = WebLink()
                    link.initWithParse(object)
                    self.addWebLink(link)
                }
                completion (hasError: false, error: nil)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion (hasError: true, error: error)
            }
        }
    }
    
    
    func addWebLink (msg:WebLink)
    {
        // TODO - Backend Add
        linkArray.append(msg)
    }
    
    func deleteWebLink (msg:WebLink, completion: (hasError: Bool, error: NSError?) -> Void)
    {
        let msgIndex = self.getMsgIndex(msg)
        if (msgIndex != -1)
        {
            linkArray.removeAtIndex(msgIndex);
        }
        
        msg.pObj?.deleteInBackgroundWithBlock({ (success:Bool, error: NSError?) -> Void in
            if (error == nil) {
                completion (hasError: false, error: nil)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion (hasError: true, error: error)
            }
        });
    }
    
    func getWebLinkByID (ID: String) -> WebLink?
    {
        for var i=0; i < linkArray.count; i++
        {
            let msg:WebLink = linkArray[i]
            if (msg.pObj?.objectId == ID) {
                return msg
            }
        }
        return nil
    }
    
    func getWebLinkAtIndex (index: Int) -> WebLink?
    {
        return linkArray[index]
    }
    
    func countWebLinks () -> Int
    {
        return linkArray.count
    }
    
    //------------------------------------------------------------------------------
    // MARK: Active Msg
    //------------------------------------------------------------------------------
    func setActiveLink (msg: WebLink?)
    {
        activeLink = msg;
    }
    
    func getActiveLink () -> WebLink?
    {
        return activeLink;
    }
    
    func getMsgIndex (msg: WebLink) -> Int
    {
        for var i=0; i < linkArray.count; i++
        {
            let mymsg:WebLink = linkArray[i]
            if (mymsg.pObj?.objectId == msg.pObj?.objectId) {
                return i
            }
        }
        return -1
    }
    
   
}
