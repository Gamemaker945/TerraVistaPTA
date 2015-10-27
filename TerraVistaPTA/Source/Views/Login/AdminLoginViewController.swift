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
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    
    
    //------------------------------------------------------------------------------
    // Mark: Lifecycle Methods
    //------------------------------------------------------------------------------


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emailTextField.text = "";
        self.passwordTextField.text = "";
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    //------------------------------------------------------------------------------
    // Mark: IBAction Methods
    //------------------------------------------------------------------------------

    @IBAction func loginPressed(sender: UIButton)
    {
        // Perform Login
        LoginController.sharedInstance.setLoggedIn(true)
        self.navigationController?.popToRootViewControllerAnimated(true);
    }

    @IBAction func forgotPasswordPressed(sender: UIButton)
    {
    
    }
}
