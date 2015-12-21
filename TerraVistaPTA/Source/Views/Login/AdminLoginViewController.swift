//
//  AdminLoginViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 10/27/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import UIKit
import Parse

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
        
        self.usernameTextField.text = "test";
        self.passwordTextField.text = "test12345";
        
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
        PFUser.logInWithUsernameInBackground(self.usernameTextField.text!, password: self.passwordTextField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                
                LoginController.sharedInstance.setActiveUser(user)
                LoginController.sharedInstance.setLoggedIn(true)
                self.navigationController?.popToRootViewControllerAnimated(true);
                
                print("User Logged In")

            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                LoginController.sharedInstance.setActiveUser(nil)
                LoginController.sharedInstance.setLoggedIn(false)
            }
            self.activityIndicator.stopAnimating()
        }
        
    }

    @IBAction func forgotPasswordPressed(sender: UIButton)
    {
    
    }
}
