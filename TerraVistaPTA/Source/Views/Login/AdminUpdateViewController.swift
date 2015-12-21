//
//  AdminUpdateViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 11/13/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import UIKit
import Parse

class AdminUpdateViewController: UIViewController
{

    //--------------------------------------------------------------------------
    // VARS
    //--------------------------------------------------------------------------
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField:    UITextField!

    @IBOutlet var updateButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    //--------------------------------------------------------------------------
    // Mark: - Lifecycle Methods
    //--------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        self.usernameTextField.delegate = self;
        self.passwordTextField.delegate = self;
        self.emailTextField.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = PFUser.currentUser()
        {
            self.usernameTextField.text = user.username
            self.passwordTextField.text = user.password
            self.emailTextField.text = user.email
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //--------------------------------------------------------------------------
    // Mark: - IBAction Methods
    //--------------------------------------------------------------------------
    @IBAction func updatePressed(sender: UIButton)
    {
        if (self.verifyInput())
        {
            activityIndicator.startAnimating()
            if let user:PFUser = PFUser.currentUser()
            {
                if self.usernameTextField.isEmpty() == false {
                    user.username = self.usernameTextField.text
                }
                
                if self.passwordTextField.isEmpty() == false {
                    user.password = self.passwordTextField.text
                }
                
                if self.emailTextField.isEmpty() == false {
                    user.email = self.emailTextField.text
                }
                
                user.saveInBackgroundWithBlock({ (hasError, error) -> Void in
                    if (error == nil) {
                        self.activityIndicator.stopAnimating()
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        // Log details of the failure
                        ParseErrorHandler.showErrorWithTitle(self, title: "Update Error", errorCode: error?.code)
                    }
                })
            }
        }
    }
    
    //--------------------------------------------------------------------------
    // Mark: - Private Methods
    //--------------------------------------------------------------------------
    func verifyInput () -> Bool
    {
        if self.usernameTextField.isEmpty() == false && !usernameTextField.validateUsernameInput()
        {
            ParseErrorHandler.showError(self, errorMsg: "Invalid Username. Must be atleast 4 characters long.")
            return false
        }
        
        else if self.passwordTextField.isEmpty() == false && !passwordTextField.validatePasswordInput()
        {
            ParseErrorHandler.showError(self, errorMsg: "Invalid Password. Must be atleast 6 characters long.")
            return false
        }
        
        else if self.emailTextField.isEmpty() == false && !emailTextField.validateEmailInput()
        {
            ParseErrorHandler.showError(self, errorMsg: "Invalid Email. Please check the format of the email address and try again.")
            return false
        }
        
        return true
    }
}

extension AdminUpdateViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
}
