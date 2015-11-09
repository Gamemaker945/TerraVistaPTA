//
//  WebLink.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import Parse

public class WebLinkController : BaseController
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
    // MARK: WebLinks
    //------------------------------------------------------------------------------
    override func fetch (completion: (hasError: Bool, error: NSError?) -> Void)
    {
        let query:PFQuery = PFQuery(className:"PWebLink")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                self.parseArray.removeAll()
                
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) weblinks.")
                
                // Do something with the found objects
                for object in objects! {
                    let link:WebLink = WebLink()
                    link.initWithParse(object)
                    self.parseArray.append(link)
                }
                
                self.sortParseObjects()
                completion (hasError: false, error: nil)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion (hasError: true, error: error)
            }
        }
    }

    
    //------------------------------------------------------------------------------
    // MARK: Active Msg
    //------------------------------------------------------------------------------
    
    override func sortParseObjects ()
    {
        self.parseArray.sortInPlace({ (pb1:ParseBase, pb2:ParseBase) -> Bool in
            let link1 = pb1 as! WebLink
            let link2 = pb2 as! WebLink
            return link1.order > link2.order
        })
    }
}
