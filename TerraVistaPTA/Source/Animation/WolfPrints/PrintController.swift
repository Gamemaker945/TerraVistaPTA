//
//  PrintController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/23/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import Foundation
import UIKit

public class PrintController : NSObject
{
    let printArray = []
    
    let printsView:UIView
    
    var nextY:CGFloat, nextX:CGFloat
    var xSep:CGFloat, ySep:CGFloat
    var isLeft = true
    
    let nextPrintDelay:NSTimeInterval = 0.5
    let printFadeTime:NSTimeInterval = 2
    
    var printTimer:NSTimer?
    
    init (animView:UIView)
    {
        printsView = animView
        
        nextY = printsView.frame.size.height
        nextX = CGFloat(arc4random_uniform(UInt32(printsView.frame.size.width - 50)))
        
        xSep = 30
        ySep = 20
        
    }
    
    func startPrints ()
    {
        printTimer = NSTimer.scheduledTimerWithTimeInterval(nextPrintDelay, target: self, selector: "createPrint", userInfo: nil, repeats: true)
    }
    
    func stopPrints ()
    {
        printTimer?.invalidate()
    }
    
    func clearPrints ()
    {
        
    }
    
    func createPrint ()
    {
        // Create the print
        let print:UIImageView = UIImageView.init(image: UIImage.init(named: "WolfPrint"))
        
        var frame:CGRect = print.frame
        frame.origin.x = nextX
        frame.origin.y = nextY
        print.frame = frame
        printsView.addSubview (print)
        
        // Setup the print fade
        UIView.animateWithDuration(printFadeTime, animations: { () -> Void in
            print.alpha = 0;
            }) { (Bool) -> Void in
                print.removeFromSuperview()
                
        }
        
        //NSLog ("Print at \(nextX) and \(nextY)")
        
        
        // Setup the coordinates for the next print
        if (isLeft) {
            nextX += frame.size.width + xSep
            isLeft = false
        } else {
            nextX -= frame.size.width + xSep
            isLeft = true
        }
        
        nextY = nextY - frame.size.height - ySep
        if (nextY < 0) {
            nextY = printsView.frame.size.height
            nextX = CGFloat(arc4random_uniform(UInt32(printsView.frame.size.width)))
        }
    
    }
}

