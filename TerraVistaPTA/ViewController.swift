//
//  ViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var animView: UIView!
    @IBOutlet var wolfImage: UIImageView!
    @IBOutlet var adminLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    
    
    
    var printController:PrintController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "wolfLongPressed:")
        self.wolfImage.addGestureRecognizer(longPressRecognizer)
    }
   
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
        printController = PrintController.init(animView: animView)
        
        self.updateAdminItems()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        printController!.startPrints()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        printController!.stopPrints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        printController!.stopPrints()
    }


    func wolfLongPressed(sender: UILongPressGestureRecognizer)
    {
        if (sender.state == UIGestureRecognizerState.Ended) {
            
        }
        else if (sender.state == UIGestureRecognizerState.Began){
            self.performSegueWithIdentifier("SegueToLogin", sender: self)
        }
        
    }
    
    private func updateAdminItems ()
    {
        self.adminLabel.hidden = !LoginController.sharedInstance.getLoggedIn()
        self.logoutButton.hidden = !LoginController.sharedInstance.getLoggedIn()
    }
    
    
    @IBAction func logoutButtonPressed(sender: UIButton)
    {
        LoginController.sharedInstance.setLoggedIn(false);
        self.updateAdminItems()
    }
}

