//
//  ParseBase.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation

public class ParseBase
{
    public var pObj: PFObject?

    init () {
        
    }
    
    func initWithParse (parseObj: PFObject)
    {
        pObj = parseObj
    }
}