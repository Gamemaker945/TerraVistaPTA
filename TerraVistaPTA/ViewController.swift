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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var calendarButton: UIButton!
    @IBOutlet var accouncementButton: UIButton!
    @IBOutlet var webButton: UIButton!
    
    
    var printController:PrintController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
   
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
        printController = PrintController.init(animView: animView)
        
        self.updateAdminItems()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "wolfLongPressed:")
        self.wolfImage.addGestureRecognizer(longPressRecognizer)
        
        self.enableButtons(true)
        
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
    
    private func enableButtons (flag: Bool)
    {
        self.calendarButton.userInteractionEnabled = flag;
        self.accouncementButton.userInteractionEnabled = flag;
        self.webButton.userInteractionEnabled = flag;
    }
    
    
    @IBAction func logoutButtonPressed(sender: UIButton)
    {
        LoginController.sharedInstance.setLoggedIn(false);
        self.updateAdminItems()
    }
    
    func signup ()
    {
        let user = PFUser()
        user.username = "test"
        user.password = "test12345"
        user.email = "admin@test.com"
        // other fields can be set just like with PFObject
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                //let errorString = error.userInfo?["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
            }
        }
    }
}

