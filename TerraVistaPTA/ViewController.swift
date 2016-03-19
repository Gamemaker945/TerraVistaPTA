//
//  ViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    @IBOutlet var animView: UIView!
    @IBOutlet var wolfImage: UIImageView!
    @IBOutlet var adminLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var calendarButton: UIButton!
    @IBOutlet var accouncementButton: UIButton!
    @IBOutlet var webButton: UIButton!
    
    @IBOutlet var calendarCountLabel: UILabel!
    @IBOutlet var weblinkCountLabel: UILabel!
    @IBOutlet var announcementCountLabel: UILabel!
    
    internal let CalID = "PTACalendarDate"
    internal let MsgID = "PTAMsgDate"
    internal let WebID = "PTAWebDate"
    
    var newCalCount = 0
    var newMsgCount = 0
    var newWebCount = 0
    
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
        
        self.enableButtons(false)
        
        calendarCountLabel.layer.masksToBounds = true
        weblinkCountLabel.layer.masksToBounds = true
        announcementCountLabel.layer.masksToBounds = true
        
        calendarCountLabel.layer.cornerRadius = 13
        weblinkCountLabel.layer.cornerRadius = 13
        announcementCountLabel.layer.cornerRadius = 13
        
        calendarCountLabel.hidden = true
        weblinkCountLabel.hidden = true
        announcementCountLabel.hidden = true
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        printController!.startPrints()
        
        CKContainer.defaultContainer().accountStatusWithCompletionHandler { (accountStatus, error) -> Void in
            if (accountStatus == .NoAccount) {
                let alert = UIAlertController (title: "Sign in to iCloud", message: "Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction (title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                self.enableButtons (false)

                if FetchController.sharedInstance.shouldUpdate()
                {
                    FetchController.sharedInstance.reset()                    
                    self.activityIndicator.startAnimating()
                    FetchController.sharedInstance.updateAll({ (error) -> Void in
                        if (error == nil)
                        {
                            // Update Counts
                            // Calendar
                            self.newCalCount = CalendarController.sharedInstance.countNewObjects(self.CalID)
                            if self.newCalCount > 0
                            {
                                self.calendarCountLabel.text = "\(self.newCalCount)"
                                self.calendarCountLabel.hidden = false
                            }
                            
                            // Msgs
                            self.newMsgCount = AnnouncementController.sharedInstance.countNewObjects(self.MsgID)
                            if self.newMsgCount > 0
                            {
                                self.announcementCountLabel.text = "\(self.newMsgCount)"
                                self.announcementCountLabel.hidden = false
                            }
                            
                            // Web
                            self.newWebCount = WebLinkController.sharedInstance.countNewObjects(self.WebID)
                            if self.newWebCount > 0
                            {
                                self.weblinkCountLabel.text = "\(self.newWebCount)"
                                self.weblinkCountLabel.hidden = false
                            }
                            
                            self.enableButtons(true)
                            self.activityIndicator.stopAnimating()
                        }
                        else
                        {
                            print("Error: \(error!) \(error!.userInfo)")
                            ParseErrorHandler.showError(self, errorCode: error?.code)
                        }
                        self.activityIndicator.stopAnimating()
                    })

                } else {
                    self.enableButtons(true)
                }
            }
        }
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
            if (LoginController.sharedInstance.getActiveUser() != nil)
            {
                self.performSegueWithIdentifier("SegueToAccount", sender: self)
            }
            else
            {
                self.performSegueWithIdentifier("SegueToLogin", sender: self)
            }
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
        //PFUser.logOut()
        LoginController.sharedInstance.setLoggedIn(false);
        LoginController.sharedInstance.setActiveUser(nil)
        self.updateAdminItems()
    }
    
    func signup ()
    {
//        let user = PFUser()
//        user.username = "test"
//        user.password = "test12345"
//        user.email = "admin@test.com"
//        // other fields can be set just like with PFObject
//        
//        user.signUpInBackgroundWithBlock {
//            (succeeded: Bool, error: NSError?) -> Void in
//            if let _ = error {
//                //let errorString = error.userInfo?["error"] as? NSString
//                // Show the errorString somewhere and let the user try again.
//            } else {
//                // Hooray! Let them use the app now.
//            }
//        }
    }
}

