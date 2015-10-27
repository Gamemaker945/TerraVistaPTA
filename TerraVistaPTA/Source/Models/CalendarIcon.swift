//
//  CalendarIcon.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/23/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import Foundation

public struct CalendarIcon
{
    private static var strings = ["PreK", "K", "1st", "2nd", "3rd", "4th", "5th", "PTA", "Adm", "All"]
    
    private static var fullstrings = ["Pre Kinder", "Kinder", "1st Grade", "2nd Grade", "3rd Grade", "4th Grade", "5th Grade", "PTA", "Administration", "Everyone"]
    
    private static var colors = [ColorUtils.colorWithHexString("FF7B00"),
        ColorUtils.colorWithHexString("1E5C7F"),
        ColorUtils.colorWithHexString("745F8E"),
        ColorUtils.colorWithHexString("CE665F"),
        ColorUtils.colorWithHexString("89A24C"),
        ColorUtils.colorWithHexString("FAA757"),
        ColorUtils.colorWithHexString("103051"),
        ColorUtils.colorWithHexString("941100"),
        ColorUtils.colorWithHexString("008F00"),
        ColorUtils.colorWithHexString("6C6C6C")]
    
    static func getColorForIndex (index:Int) -> UIColor
    {
        return colors[index]
    }
    
    static func getStringForIndex (index:Int) -> String
    {
        return strings[index]
    }
    
    static func getFullStringForIndex (index:Int) -> String
    {
        return fullstrings[index]
    }
    
    static func countTypes() -> Int
    {
        return CalendarIcon.colors.count;
    }
}
