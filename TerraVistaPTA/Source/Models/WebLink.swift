//
//  WebLink.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation

public class WebLink : ParseBase
{
    public var title: String = ""
    public var urlStr: String = ""
    
    override init()
    {
        super.init()
        self.title = ""
        self.urlStr = ""
    }
    
    override func initWithParse (parseObj: PFObject)
    {
        super.initWithParse(parseObj)
        self.title = parseObj["title"] as! String
        self.urlStr = parseObj["url"] as! String
    }
    
}