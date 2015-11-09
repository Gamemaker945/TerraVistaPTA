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
    private static let iconInfo = [(string:"K", fullstring:"Kinder", color:ColorUtils.colorWithHexString("FF7B00")),
        (string:"1st", fullstring:"1st Grade",      color:ColorUtils.colorWithHexString("745F8E")),
        (string:"2nd", fullstring:"2st Grade",      color:ColorUtils.colorWithHexString("CE665F")),
        (string:"3rd", fullstring:"3nd Grade",      color:ColorUtils.colorWithHexString("89A24C")),
        (string:"4th", fullstring:"4rd Grade",      color:ColorUtils.colorWithHexString("FAA757")),
        (string:"5th", fullstring:"5th Grade",      color:ColorUtils.colorWithHexString("103051")),
        (string:"PTA", fullstring:"PTA",            color:ColorUtils.colorWithHexString("941100")),
        (string:"Adm", fullstring:"Administration", color:ColorUtils.colorWithHexString("008F00")),
        (string:"All", fullstring:"Everyone",       color:ColorUtils.colorWithHexString("6C6C6C"))]
    
    static func getColorForIndex (index:Int) -> UIColor
    {
        return iconInfo[index].color
    }
    
    static func getStringForIndex (index:Int) -> String
    {
        return iconInfo[index].string
    }
    
    static func getFullStringForIndex (index:Int) -> String
    {
        return iconInfo[index].fullstring
    }
    
    static func countTypes() -> Int
    {
        return CalendarIcon.iconInfo.count;
    }
}
