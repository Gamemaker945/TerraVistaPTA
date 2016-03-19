//
//  AdminLoginViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 10/27/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class AdminLoginViewController: UIViewController {
    
    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    
    //------------------------------------------------------------------------------
    // Mark: - Lifecycle Methods
    //------------------------------------------------------------------------------


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.usernameTextField.text = " ";
        //self.passwordTextField.text = "test12345";
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }

    //------------------------------------------------------------------------------
    // Mark: - IBAction Methods
    //------------------------------------------------------------------------------

    @IBAction func loginPressed(sender: UIButton)
    {
        self.activityIndicator.startAnimating()
        LoginController.sharedInstance.login(self.usernameTextField.text!, password: self.passwordTextField.text!) { (loggedIn, error) -> Void in
            if error == nil && loggedIn == true{
                
                dispatch_async(dispatch_get_main_queue()) {

                    self.activityIndicator.stopAnimating()
                    self.navigationController?.popToRootViewControllerAnimated(true);
                }
                
                print("User Logged In")
                
            } else {
                // Log details of the failure
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    
                    let alert = UIAlertController(title: "Error", message: "Either the username or password was incorrect. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    LoginController.sharedInstance.setActiveUser(nil)
                    LoginController.sharedInstance.setLoggedIn(false)
                }
            }
        }
    }

    @IBAction func forgotPasswordPressed(sender: UIButton)
    {
    
    }
}
