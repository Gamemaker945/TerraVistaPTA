//
//  ColorUtils.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/16/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import Foundation

public class ColorUtils
{
    // Short cut for setting colors using standard RGB
    static func color (r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor
    {
        return self.color(r, g: g, b: b, a: 1.0);
    }
    
    // Short cut for setting colors using standard RGBA
    static func color (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor
    {
        // Confirm colors are in the proper ranges
        if (0.0 > r || r > 255.0)
        {
            NSLog("ERROR - Attemping generate a color with a red value that is out of range (%f)", r);
        }
        if (0.0 > g || g > 255.0)
        {
            NSLog("ERROR - Attemping generate a color with a green value that is out of range (%f)", g);
        }
        if (0.0 > b || b > 255.0)
        {
            NSLog("ERROR - Attemping generate a color with a blue value that is out of range (%f)", b);
        }
        
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a / 255.0)
    }
    
    
    static func colorWithHexString (hex:String) -> UIColor
    {
        return self.colorWithHexString(hex, alpha: 1.0)
    }
    
    static func colorWithHexString (hex:String, alpha:CGFloat) -> UIColor
    {
        var cString:String =  hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        // String should be 6 or 8 characters
        if (cString.characters.count < 6) { return UIColor.grayColor() }
        
        // strip 0X if it appears
        if (cString.hasPrefix("0X")) { cString = cString.substringFromIndex(cString.startIndex.advancedBy(2)) }
        if (cString.hasPrefix("#")) { cString = cString.substringFromIndex(cString.startIndex.advancedBy(1)) }
        
        if (cString.characters.count != 6) { return UIColor.grayColor() }
        
        // Separate into r, g, b substrings
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        
        // Scan values
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}