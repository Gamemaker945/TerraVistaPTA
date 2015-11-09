//
//  TVBaseViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 11/8/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class TVBaseViewController: UIViewController {

    
    func showError (errorMsg: String)
    {
        let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",  style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}
